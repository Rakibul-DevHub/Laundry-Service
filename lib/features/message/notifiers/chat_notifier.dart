// features/messaging/notifiers/chat_notifier.dart

// ignore_for_file: always_specify_types, avoid_dynamic_calls

import 'package:drop_n_fresh/app/router/app_router.dart';
import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:drop_n_fresh/features/message/notifiers/conversations_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../core/utils/app_logger.dart';
import '../models/message_model.dart';
import '../states/chat_state.dart';

class ChatNotifier extends AutoDisposeFamilyNotifier<ChatState, String> {
  late final ApiClient _apiClient;
  String _currentConversationId = '';

  @override
  ChatState build(String conversationId) {
    _apiClient = ref.read(apiClientProvider);
    _currentConversationId = conversationId;

    if (_currentConversationId.isEmpty) {
      return const ChatState(isLoading: false, messages: <MessageModel>[]);
    }

    Future<void>.delayed(Duration.zero, () {
      _fetchMessages();
    });

    return const ChatState(isLoading: true);
  }

  /// Fetch messages from API
  Future<void> _fetchMessages({int page = 1}) async {
    final bool isFirstPage = page == 1;

    state = state.copyWith(
      isLoading: isFirstPage,
      isLoadingMore: !isFirstPage,
      error: null,
    );

    try {
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.messages,
            queryParameters: <String, dynamic>{
              'conversationId': _currentConversationId,
              'page': page.toString(),
              'limit': '30',
            },
          );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to fetch messages');
      }

      final Map<String, dynamic> data =
          response['data'] as Map<String, dynamic>;
      final List<dynamic> messagesJson = data['messages'] as List;
      final Map<String, dynamic> pagination =
          data['pagination'] as Map<String, dynamic>;

      final List<MessageModel> newMessages = messagesJson
          .map(
            (json) =>
                MessageModel.fromApiResponse(json as Map<String, dynamic>),
          )
          .toList();

      final int totalPages = pagination['totalPages'] as int;
      final int currentPage = pagination['page'] as int;
      final bool hasMore = currentPage < totalPages;

      //  API returns oldest→newest, which is correct for normal ListView
      // No reversal needed
      _updateMessagesStateWithPagination(newMessages, page, hasMore);
    } catch (e, stack) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
        isLoading: false,
        isLoadingMore: false,
      );
      AppLogger().e(
        'Failed to fetch messages: $e',
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Update state with pagination-aware message list
  void _updateMessagesStateWithPagination(
    List<MessageModel> newMessages,
    int page,
    bool hasMore,
  ) {
    if (page > 1) {
      //  Loading older messages: prepend to beginning of list
      state = state.copyWith(
        messages: <MessageModel>[...newMessages, ...state.messages],
        page: page,
        hasMore: hasMore,
        isLoading: false,
        isLoadingMore: false,
      );
    } else {
      //  Initial load: replace with fresh list (oldest→newest)
      state = state.copyWith(
        messages: newMessages,
        page: page,
        hasMore: hasMore,
        isLoading: false,
        isLoadingMore: false,
      );
    }
  }

  /// Send message via API
  Future<void> sendMessage({
    required String content,
    required String receiverId,
  }) async {
    if (content.trim().isEmpty) {
      return;
    }

    state = state.copyWith(isSending: true, sendingError: null);

    try {
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.post,
            endpoint: '${ApiEndpoints.messages}/send',
            data: <String, String>{
              'receiverId': receiverId,
              'content': content,
            },
          );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to send message');
      }

      final Map<String, dynamic> messageData =
          response['data']['message'] as Map<String, dynamic>;
      final MessageModel newMessage = MessageModel.fromApiResponse(messageData);

      //  Append new message to end of list (appears at bottom)
      state = state.copyWith(
        messages: <MessageModel>[...state.messages, newMessage],
        isSending: false,
      );
    } catch (e, stack) {
      state = state.copyWith(
        sendingError: ExceptionHandler.errorMessage(e),
        isSending: false,
      );
      AppLogger().e('Failed to send message: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Refresh: fetch page 1
  Future<void> refresh() async => await _fetchMessages(page: 1);

  /// Load older messages (pagination)
  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }
    await _fetchMessages(page: state.page + 1);
  }

  Future<void> deleteConversation(String conversationId) async {
    try {
      state = const ChatState(isLoading: true);

      await _apiClient.handleRequest<Map<String, dynamic>>(
        httpMethod: HttpMethod.delete,
        endpoint: ApiEndpoints.deleteConversation(conversationId),
      );

      state = const ChatState(isLoading: false);

      AppLogger().d('Conversation deleted: $conversationId');
      ref.read(conversationsProvider.notifier).refresh();
      ref.read(appRouterProvider).pop();
    } catch (e, stack) {
      Toast.showError(ExceptionHandler.errorMessage(e));
      AppLogger().e(
        'Failed to delete conversation: $e',
        error: e,
        stackTrace: stack,
      );
      state = const ChatState(isLoading: false);
    }
  }

  Future<void> reportUser({
    required String conversationId,
    required String reason,
    required String details,
  }) async {
    try {
      await _apiClient.handleRequest<Map<String, dynamic>>(
        httpMethod: HttpMethod.post,
        endpoint: ApiEndpoints.reportConversation,
        data: <String, String>{
          'conversationId': conversationId,
          'reason': reason.trim(),
          'details': details.trim(),
        },
      );
    } catch (e, stack) {
      Toast.showError(ExceptionHandler.errorMessage(e));
      AppLogger().e('Failed to report user: $e', error: e, stackTrace: stack);
    }
  }
}

final AutoDisposeNotifierProviderFamily<ChatNotifier, ChatState, String>
chatProvider = NotifierProvider.autoDispose
    .family<ChatNotifier, ChatState, String>(ChatNotifier.new);

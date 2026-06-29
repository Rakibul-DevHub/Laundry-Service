// ignore_for_file: always_specify_types

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../core/utils/app_logger.dart';
import '../models/conversation_model.dart';
import '../states/conversations_state.dart';

class ConversationsNotifier extends AutoDisposeNotifier<ConversationsState> {
  late final ApiClient _apiClient;

  @override
  ConversationsState build() {
    _apiClient = ref.read(apiClientProvider);
    Future<dynamic>.microtask(() => _fetchConversations());
    return const ConversationsState(isLoading: true);
  }

  Future<void> _fetchConversations({int page = 1}) async {
    final bool isLoadingMore = page > 1;

    state = state.copyWith(
      isLoading: !isLoadingMore,
      isLoadingMore: isLoadingMore,
      error: null,
    );

    try {
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.conversations,
            queryParameters: <String, dynamic>{
              'page': page.toString(),
              'limit': '15',
            },
          );

      final Map<String, dynamic> data =
          response['data'] as Map<String, dynamic>;
      final List<dynamic> conversationsJson = data['conversations'] as List;
      final Map<String, dynamic> paginationJson =
          data['pagination'] as Map<String, dynamic>;

      final List<ConversationModel> newConversations = conversationsJson
          .map(
            (json) => ConversationModel.fromApiResponse(
              json as Map<String, dynamic>,
            ),
          )
          .toList();

      final int totalPages = paginationJson['totalPages'] as int;
      final bool hasMore = (paginationJson['page'] as int) < totalPages;

      _updateState(newConversations, page, hasMore, isLoadingMore);
    } catch (e, stack) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
        isLoading: false,
        isLoadingMore: false,
      );
      AppLogger().e(
        'Failed to fetch conversations: $e',
        error: e,
        stackTrace: stack,
      );
    }
  }

  //  Helper to reduce duplication
  void _updateState(
    List<ConversationModel> newConversations,
    int page,
    bool hasMore,
    bool isLoadingMore,
  ) {
    if (isLoadingMore) {
      state = state.copyWith(
        conversations: <ConversationModel>[
          ...state.conversations,
          ...newConversations,
        ],
        page: page,
        hasMore: hasMore,
        isLoading: false,
        isLoadingMore: false,
      );
    } else {
      state = state.copyWith(
        conversations: newConversations,
        page: page,
        hasMore: hasMore,
        isLoading: false,
        isLoadingMore: false,
      );
    }
  }

  Future<void> refresh() async => await _fetchConversations(page: 1);

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading || state.isLoadingMore) {
      return;
    }
    await _fetchConversations(page: state.page + 1);
  }
}

final AutoDisposeNotifierProvider<ConversationsNotifier, ConversationsState>
conversationsProvider =
    NotifierProvider.autoDispose<ConversationsNotifier, ConversationsState>(
      ConversationsNotifier.new,
    );

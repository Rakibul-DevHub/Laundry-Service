// features/messaging/states/chat_state.dart

import 'package:flutter/foundation.dart';
import '../models/message_model.dart';

@immutable
class ChatState {
  final List<MessageModel> messages;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  final String? error;
  final bool isSending;
  final String? sendingError;

  const ChatState({
    this.messages = const <MessageModel>[],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.page = 1,
    this.error,
    this.isSending = false,
    this.sendingError,
  });

  ChatState copyWith({
    List<MessageModel>? messages,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    String? error,
    bool? isSending,
    String? sendingError,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      error: error,
      isSending: isSending ?? this.isSending,
      sendingError: sendingError,
    );
  }
}

// features/messaging/state/conversations_state.dart

import 'package:flutter/foundation.dart';
import '../models/conversation_model.dart';

@immutable
class ConversationsState {
  final List<ConversationModel> conversations;
  final bool isLoading;
  final String? error;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;

  const ConversationsState({
    this.conversations = const <ConversationModel>[],
    this.isLoading = false,
    this.error,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.page = 1,
  });

  ConversationsState copyWith({
    List<ConversationModel>? conversations,
    bool? isLoading,
    String? error,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
  }) {
    return ConversationsState(
      conversations: conversations ?? this.conversations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

// features/messaging/screens/conversations_screen.dart

import 'package:drop_n_fresh/shared/widgets/asset_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../../shared/widgets/custom_refresh_indicator.dart';
import '../../bottom_nav/provider/bottom_nav_provider.dart';
import '../models/conversation_model.dart';
import '../notifiers/conversations_notifier.dart';
import '../states/conversations_state.dart';
import '../widgets/conversation_item_shimmer.dart';

// 🔍 Search providers (keep these at bottom or move to separate file)
final StateProvider<String> conversationsSearchProvider = StateProvider<String>(
  (Ref<String> ref) => '',
);

final Provider<List<ConversationModel>> filteredConversationsProvider =
    Provider<List<ConversationModel>>((
      Ref<List<ConversationModel>> ref,
    ) {
      final List<ConversationModel> conversations = ref
          .watch(conversationsProvider)
          .conversations;
      final String searchQuery = ref
          .watch(conversationsSearchProvider)
          .toLowerCase()
          .trim();

      if (searchQuery.isEmpty) {
        return conversations;
      }

      return conversations.where((ConversationModel conversation) {
        final bool nameMatch = conversation.otherUserName
            .toLowerCase()
            .contains(searchQuery);
        final bool messageMatch = conversation.lastMessage
            .toLowerCase()
            .contains(searchQuery);
        return nameMatch || messageMatch;
      }).toList();
    });

class ConversationsScreen extends ConsumerStatefulWidget {
  const ConversationsScreen({super.key});

  @override
  ConsumerState<ConversationsScreen> createState() =>
      _ConversationsScreenState();
}

class _ConversationsScreenState extends ConsumerState<ConversationsScreen> {
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchActive = false;

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        ref.read(conversationsSearchProvider.notifier).state = '';
        _searchFocusNode.unfocus();
      }
    });
    if (_isSearchActive) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_searchFocusNode);
      }
    }
  }

  void _clearSearch() {
    ref.read(conversationsSearchProvider.notifier).state = '';
    _toggleSearch();
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final ConversationsState state = ref.watch(conversationsProvider);
    final ConversationsNotifier notifier = ref.read(
      conversationsProvider.notifier,
    );
    final String searchQuery = ref.watch(conversationsSearchProvider);
    final List<ConversationModel> filteredConversations = ref.watch(
      filteredConversationsProvider,
    );

    final List<ConversationModel> displayConversations =
        searchQuery.trim().isEmpty
        ? state.conversations
        : filteredConversations;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(searchQuery),
      body: CustomRefreshIndicator(
        onRefresh: () => notifier.refresh(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: state.isLoading
                  ? _buildShimmerContent()
                  : state.error != null
                  ? _buildErrorContent(
                      error: state.error!,
                      onRetry: notifier.refresh,
                      context: context,
                    )
                  : state.conversations.isEmpty || displayConversations.isEmpty
                  ? _buildEmptyContent(context, searchQuery)
                  : _buildContent(displayConversations, state, notifier),
            ),
          ],
        ),
      ),
    );
  }

  //  AppBar with SINGLE search field
  PreferredSizeWidget _buildAppBar(String searchQuery) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _isSearchActive
            ? KeyedSubtree(
                key: const ValueKey<String>('search_field'),
                child: TextField(
                  focusNode: _searchFocusNode,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search conversations...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColors.body),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(color: AppColors.title, fontSize: 16),
                  onChanged: (String value) =>
                      ref.read(conversationsSearchProvider.notifier).state =
                          value,
                ),
              )
            : const KeyedSubtree(
                key: ValueKey<String>('title_text'),
                child: Text(
                  "Messages",
                  style: TextStyle(
                    color: AppColors.title,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
      ),
      actions: <Widget>[
        if (_isSearchActive)
          IconButton(
            icon: const Icon(Icons.clear, color: AppColors.body),
            onPressed: _clearSearch,
            tooltip: 'Clear search',
          )
        else
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.title),
            onPressed: _toggleSearch,
            tooltip: 'Search',
          ),
        const SizedBox(width: AppSizes.screenHorizontal),
      ],
    );
  }

  Widget _buildShimmerContent() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenHorizontal,
        vertical: AppSizes.screenVertical,
      ),
      itemCount: 8,
      separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
      itemBuilder: (_, _) => const ConversationItemShimmer(),
    );
  }

  Widget _buildErrorContent({
    required String error,
    required VoidCallback onRetry,
    required BuildContext context,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.error_outline, size: 48, color: AppColors.red),
          const SizedBox(height: 16),
          Text(
            'Failed to load conversations',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.body),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildEmptyContent(BuildContext context, String searchQuery) {
    final bool isSearching = searchQuery.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              isSearching ? Icons.search_off : Icons.chat_bubble_outline,
              size: 64,
              color: AppColors.body.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              isSearching ? 'No matching conversations' : 'No messages yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Try searching with different keywords'
                  : 'Start a message after you select an Agent. Open an order and tap the chat icon next to that Agent.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.body),
              textAlign: TextAlign.center,
            ),
            if (isSearching) ...<Widget>[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _clearSearch,
                child: const Text('Clear Search'),
              ),
            ] else ...<Widget>[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.read(bottomNavProvider.notifier).setIndex(2);
                  context.go(RoutePaths.user);
                },
                child: const Text('View my orders'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    List<ConversationModel> conversations,
    ConversationsState state,
    ConversationsNotifier notifier,
  ) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (ref.read(conversationsSearchProvider).trim().isEmpty &&
            notification is ScrollUpdateNotification) {
          final double maxScroll = notification.metrics.maxScrollExtent;
          final double currentScroll = notification.metrics.pixels;

          if (currentScroll >= maxScroll - 200 &&
              !state.isLoading &&
              state.hasMore) {
            notifier.loadMore();
          }
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontal,
          vertical: AppSizes.screenVertical,
        ),
        itemCount:
            conversations.length +
            (state.hasMore &&
                    ref.read(conversationsSearchProvider).trim().isEmpty
                ? 1
                : 0),
        separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
        itemBuilder: (BuildContext context, int index) {
          if (index == conversations.length &&
              state.hasMore &&
              ref.read(conversationsSearchProvider).trim().isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final ConversationModel conversation = conversations[index];
          return _ConversationItem(
            conversation: conversation,
            searchQuery: ref.read(conversationsSearchProvider).trim(),
            onTap: () async {
              ref.read(conversationsSearchProvider.notifier).state = '';
              context.push(
                RoutePaths.chat,
                extra: <String, Object>{
                  "conversationId": conversation.id,
                  "receiverId": conversation.otherUserId,
                  "conversation": conversation,
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ConversationItem extends StatelessWidget {
  final ConversationModel conversation;
  final String searchQuery;
  final VoidCallback onTap;

  const _ConversationItem({
    required this.conversation,
    this.searchQuery = '',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AssetLoader(
                    assetPath: conversation.otherUserAvatar,
                    width: 48,
                    height: 48,
                  ),
                ),
                // if (conversation.isOnline)
                //   Positioned(
                //     bottom: 0,
                //     right: 0,
                //     child: Container(
                //       width: 12,
                //       height: 12,
                //       decoration: BoxDecoration(
                //         color: Colors.green,
                //         shape: BoxShape.circle,
                //         border: Border.all(color: AppColors.white, width: 2),
                //       ),
                //     ),
                //   ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: _buildHighlightedText(
                          text: conversation.otherUserName,
                          query: searchQuery,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          highlightStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            backgroundColor: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        conversation.formattedTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.body.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _buildHighlightedText(
                          text: conversation.lastMessage,
                          query: searchQuery,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.body.withValues(alpha: 0.8),
                          ),
                          highlightStyle: TextStyle(
                            fontSize: 13,
                            color: AppColors.body.withValues(alpha: 0.8),
                            backgroundColor: Colors.yellowAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // if (conversation.unreadCount > 0) ...<Widget>[
                      //   const SizedBox(width: 8),
                      //   Container(
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 6,
                      //       vertical: 2,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: AppColors.primary,
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     child: Text(
                      //       conversation.unreadCount.toString(),
                      //       style: const TextStyle(
                      //         color: AppColors.white,
                      //         fontSize: 11,
                      //         fontWeight: FontWeight.w600,
                      //       ),
                      //     ),
                      //   ),
                      // ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedText({
    required String text,
    required String query,
    required TextStyle style,
    required TextStyle highlightStyle,
  }) {
    if (query.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final String lowerText = text.toLowerCase();
    final String lowerQuery = query.toLowerCase();
    final int index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: style,
        children: <InlineSpan>[
          TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: highlightStyle,
          ),
          if (index + query.length < text.length)
            TextSpan(text: text.substring(index + query.length)),
        ],
      ),
    );
  }
}

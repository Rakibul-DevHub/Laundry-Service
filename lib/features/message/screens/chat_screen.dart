// features/messaging/screens/chat_screen.dart

import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/constants/storage_keys.dart';
import 'package:drop_n_fresh/core/storage/secure_storage_service.dart';
import 'package:drop_n_fresh/shared/widgets/app_elevated_button.dart';
import 'package:drop_n_fresh/shared/widgets/app_outline_button.dart';
import 'package:drop_n_fresh/shared/widgets/custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../../shared/widgets/custom_refresh_indicator.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../notifiers/chat_notifier.dart';
import '../states/chat_state.dart';
import '../widgets/message_item_shimmer.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String receiverId;
  final ConversationModel? conversation;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.receiverId,
    this.conversation,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _currentUserId;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Load current user ID from secure storage
  Future<void> _loadCurrentUserId() async {
    try {
      _currentUserId = await SecureStorageService().read(StorageKeys.userId);
      // Trigger rebuild to update isMe checks
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // Handle silently - isMe will default to false
    }
  }

  void _scrollToBottom({bool immediate = false}) {
    if (!_scrollController.hasClients) {
      return;
    }

    void scroll() {
      if (_scrollController.position.maxScrollExtent > 0) {
        if (immediate) {
          //  Use jumpTo for instant scroll (no animation)
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        } else {
          //  Use animateTo for smooth scroll
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      }
    }

    if (immediate) {
      scroll();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => scroll());
    }
  }

  /// Send message via API
  void _sendMessage() {
    final String content = _messageController.text.trim();
    if (content.isEmpty) {
      return;
    }

    ref
        .read(chatProvider(widget.conversationId).notifier)
        .sendMessage(
          content: content,
          receiverId: widget.receiverId,
        );

    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToBottom(immediate: true),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final ChatState state = ref.read(chatProvider(widget.conversationId));

    if (_scrollController.position.pixels < 100 &&
        !state.isLoading &&
        !state.isLoadingMore &&
        state.hasMore) {
      ref.read(chatProvider(widget.conversationId).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ChatState state = ref.watch(chatProvider(widget.conversationId));
    final ChatNotifier notifier = ref.read(
      chatProvider(widget.conversationId).notifier,
    );

    final String userName = widget.conversation?.otherUserName ?? 'User';
    final String? userAvatar = widget.conversation?.otherUserAvatar;

    // Auto-scroll on initial load
    if (_isInitialLoad && !state.isLoading && state.messages.isNotEmpty) {
      _isInitialLoad = false;
      //  Use immediate: true for instant scroll on load
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToBottom(immediate: true),
      );
    }

    // Auto-scroll when new messages arrive (if user is near bottom)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialLoad &&
          state.messages.isNotEmpty &&
          _scrollController.hasClients) {
        // Only auto-scroll if user is near bottom (not viewing history)
        final bool isNearBottom =
            _scrollController.position.pixels >=
            (_scrollController.position.maxScrollExtent - 100);

        if (isNearBottom) {
          _scrollToBottom(immediate: true);
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(userName, userAvatar),
      body: CustomRefreshIndicator(
        onRefresh: () => notifier.refresh(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: state.isLoading && state.messages.isEmpty
                  ? _buildShimmerContent()
                  : state.error != null
                  ? _buildErrorContent(
                      error: state.error!,
                      onRetry: notifier.refresh,
                    )
                  : _buildMessagesList(state),
            ),
            _buildMessageInput(state),
          ],
        ),
      ),
    );
  }

  void _showDeleteChatDialog() {
    CustomPopup.show<Column>(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            height: AppSizes.md,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.delete_outline, color: AppColors.red, size: 24),
              const SizedBox(width: 8),
              Text(
                'Delete Chat',
                style: AppTextStyles.paragraph0,
              ),
            ],
          ),

          const SizedBox(
            height: AppSizes.md,
          ),

          Text(
            'Are you sure you want to delete this chat? This action cannot be undone.',
            textAlign: TextAlign.center,
            style: AppTextStyles.paragraph0,
          ),

          const SizedBox(
            height: AppSizes.md,
          ),

          Row(
            children: <Widget>[
              Expanded(
                child: AppOutlineButton(
                  onPressed: () => context.pop(),
                  label: 'Cancel',
                ),
              ),
              const SizedBox(
                width: AppSizes.md,
              ),
              Expanded(
                child: AppElevatedButton(
                  onPressed: () async {
                    context.pop();
                    ref
                        .read(chatProvider(widget.conversationId).notifier)
                        .deleteConversation(widget.conversationId);
                  },
                  label: 'Delete',
                ),
              ),
            ],
          ),
        ],
      ),
      context: context,
    );
  }

  void _showReportUserDialog() {
    //  Dropdown value: must match API enum exactly (lowercase)
    String?
    selectedReason; // Values: 'spam' | 'harassment' | 'abuse' | 'scam' | 'inappropriate' | 'other'

    final TextEditingController reasonDetailsController =
        TextEditingController();
    String? errorText; // For dropdown validation
    String? errorDetailsText; // For details validation

    CustomPopup.show<Column>(
      context: context,
      content: StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.report_outlined,
                  color: Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Report User',
                  style: AppTextStyles.paragraph0,
                ),
              ],
            ),
            const SizedBox(height: 8),

            Center(
              child: Text(
                'Why are you reporting ${widget.conversation?.otherUserName ?? 'this user'}?',
                textAlign: TextAlign.center,
                style: AppTextStyles.paragraph0.copyWith(color: AppColors.body),
              ),
            ),
            const SizedBox(height: 16),

            //  Reason Dropdown (REQUIRED)
            Text(
              'Reason *',
              style: AppTextStyles.paragraph0.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: errorText != null
                      ? AppColors.red
                      : AppColors.body.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedReason,
                  isExpanded: true,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Select a reason',
                      style: TextStyle(
                        color: AppColors.body.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                      value: 'spam',
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Spam or promotional content'),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'harassment',
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Harassment or bullying'),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'abuse',
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Abusive or threatening behavior'),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'scam',
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Scam or fraud attempt'),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'inappropriate',
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Inappropriate content'),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'other',
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Other'),
                      ),
                    ),
                  ],
                  onChanged: (String? value) {
                    if (errorText != null) {
                      setState(() => errorText = null);
                    }
                    setState(() => selectedReason = value);
                  },
                  borderRadius: BorderRadius.circular(12),
                  iconEnabledColor: AppColors.body,
                  style: const TextStyle(fontSize: 14, color: AppColors.title),
                ),
              ),
            ),
            //  Dropdown error message
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  errorText!,
                  style: const TextStyle(
                    color: AppColors.red,
                    fontSize: 12,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            //  Details TextField (REQUIRED - Always visible)
            Text(
              'Details *',
              style: AppTextStyles.paragraph0.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: reasonDetailsController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Please describe what happened in detail...',
                hintStyle: TextStyle(
                  color: AppColors.body.withValues(alpha: 0.6),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: errorDetailsText != null
                        ? AppColors.red
                        : AppColors.body.withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.body.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                errorText: errorDetailsText,
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: (String value) {
                if (errorDetailsText != null) {
                  setState(() => errorDetailsText = null);
                }
              },
            ),

            const SizedBox(height: 24),

            //  Action Buttons
            Row(
              children: <Widget>[
                Expanded(
                  child: AppOutlineButton(
                    onPressed: () => context.pop(),
                    label: 'Cancel',
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: AppElevatedButton(
                    onPressed: () async {
                      //  Clear previous errors
                      setState(() {
                        errorText = null;
                        errorDetailsText = null;
                      });

                      bool hasError = false;

                      //  Validate Reason (REQUIRED)
                      if (selectedReason == null) {
                        setState(() => errorText = 'Please select a reason');
                        hasError = true;
                      }

                      //  Validate Details (REQUIRED)
                      final String reasonDetails = reasonDetailsController.text
                          .trim();
                      if (reasonDetails.isEmpty) {
                        setState(
                          () => errorDetailsText = 'Please provide details',
                        );
                        hasError = true;
                      } else if (reasonDetails.length < 10) {
                        setState(
                          () => errorDetailsText =
                              'Please provide more details (min 10 characters)',
                        );
                        hasError = true;
                      }

                      //  Stop if validation failed
                      if (hasError) {
                        return;
                      }

                      context.pop();

                      //  Submit report with both fields
                      await ref
                          .read(chatProvider(widget.conversationId).notifier)
                          .reportUser(
                            reason:
                                selectedReason!, //  Required: exact enum value
                            details:
                                reasonDetails, //  Required: detailed description
                            conversationId: widget.conversationId,
                          );
                    },
                    label: 'Submit Report',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Custom app bar with user info and menu
  PreferredSizeWidget _buildAppBar(String userName, String? userAvatar) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leadingWidth: 70,
      leading: Row(
        children: <Widget>[
          const SizedBox(width: AppSizes.screenHorizontal),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.title,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
      title: Row(
        children: <Widget>[
          // Profile avatar
          CircleAvatar(
            radius: 20,
            backgroundImage: userAvatar != null
                ? NetworkImage(userAvatar)
                : null,
            backgroundColor: AppColors.grey200,
            child: userAvatar == null
                ? const Icon(Icons.person, color: AppColors.body, size: 24)
                : null,
          ),
          const SizedBox(width: 12),
          // User name
          Text(
            userName,
            style: const TextStyle(
              color: AppColors.title,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColors.title),
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: AppColors.white,
          elevation: 8,
          onSelected: (String value) {
            switch (value) {
              case 'delete':
                _showDeleteChatDialog();
                break;
              case 'report':
                _showReportUserDialog();
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            _buildMenuItem(
              Icons.delete_outline,
              'Delete Chat',
              'delete',
              AppColors.title,
            ),
            const PopupMenuDivider(height: 1),
            _buildMenuItem(
              Icons.report_outlined,
              'Report User',
              'report',
              AppColors.title,
            ),
          ],
        ),
        const SizedBox(width: AppSizes.screenHorizontal),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return PopupMenuItem<String>(
      value: value,
      height: 48,
      child: Row(
        children: <Widget>[
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerContent() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.screenHorizontal),
      itemCount: 8,
      separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
      itemBuilder: (_, _) => const MessageItemShimmer(),
    );
  }

  Widget _buildErrorContent({
    required String error,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.error_outline, size: 48, color: AppColors.red),
          const SizedBox(height: 16),
          Text(
            'Failed to load messages',
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

  Widget _buildMessagesList(ChatState state) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          _onScroll();
        }
        return false;
      },
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppSizes.screenHorizontal),
        itemCount: state.messages.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
        itemBuilder: (BuildContext context, int index) {
          // Load more indicator at top
          if (index == state.messages.length && state.hasMore) {
            return const SizedBox.shrink();
            // return Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 12),
            //   child: Center(
            //     child: state.isLoading
            //         ? const SizedBox(
            //             width: 20,
            //             height: 20,
            //             child: CircularProgressIndicator(strokeWidth: 2),
            //           )
            //         : const Text(
            //             'Load older messages',
            //             style: TextStyle(color: AppColors.body, fontSize: 12),
            //           ),
            //   ),
            // );
          }

          final MessageModel message = state.messages[index];
          final bool isMe = message.senderId == _currentUserId;

          return _MessageBubble(message: message, isMe: isMe);
        },
      ),
    );
  }

  Widget _buildMessageInput(ChatState state) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenHorizontal,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.body.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: AppColors.body),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (state.isSending)
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            IconButton(
              onPressed: () {
                _messageController.text.trim().isNotEmpty
                    ? _sendMessage()
                    : () {};
              },
              icon: const Icon(Icons.send, color: AppColors.primary),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                padding: const EdgeInsets.all(10),
              ),
            ),
        ],
      ),
    );
  }
}

/// Message bubble widget
class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? AppColors.primary : AppColors.grey50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message.content,
              style: TextStyle(
                color: isMe ? AppColors.white : AppColors.title,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message.formattedTime,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.body.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

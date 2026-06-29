import 'dart:async';

import 'package:drop_n_fresh/features/notification/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/notifications_provider.dart';
import '../state/notification_state.dart';
import 'notification_item.dart';

class NotificationList extends ConsumerStatefulWidget {
  final NotificationState state;

  const NotificationList({super.key, required this.state});

  @override
  ConsumerState<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends ConsumerState<NotificationList> {
  final ScrollController _scrollController = ScrollController();
  Timer? _loadMoreTimer;
  bool _isRequestingMore = false; //  Prevent duplicate API calls

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _loadMoreTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (widget.state.isLoading || !widget.state.hasMore || _isRequestingMore) {
      return;
    }

    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200) {
      _loadMoreTimer?.cancel();
      _loadMoreTimer = Timer(const Duration(milliseconds: 300), () {
        if (mounted &&
            !widget.state.isLoading &&
            widget.state.hasMore &&
            !_isRequestingMore) {
          _loadMore();
        }
      });
    }
  }

  Future<void> _loadMore() async {
    // Double-check conditions
    if (_isRequestingMore || widget.state.isLoading || !widget.state.hasMore) {
      return;
    }

    _isRequestingMore = true;

    try {
      await ref.read(notificationProvider.notifier).loadMore();
    } finally {
      _isRequestingMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount:
            widget.state.notifications.length +
            (widget.state.isLoading && widget.state.hasMore ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index < widget.state.notifications.length) {
            final NotificationModel notification =
                widget.state.notifications[index];
            return NotificationItem(
              id: notification.id,
              title: notification.title,
              message: notification.message,
              timeAgo: notification.formattedTime,
              isRead: notification.isRead,
            );
          } else if (widget.state.isLoadingMore && widget.state.hasMore) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            return const SizedBox(height: 16);
          }
        },
      ),
    );
  }
}

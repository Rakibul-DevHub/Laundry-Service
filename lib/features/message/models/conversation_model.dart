// features/messaging/models/conversation_model.dart

import 'package:drop_n_fresh/core/constants/app_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class ConversationModel {
  final String id;
  final String userId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  const ConversationModel({
    required this.id,
    required this.userId,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isOnline,
  });

  factory ConversationModel.fromApiResponse(Map<String, dynamic> json) {
    // ✅ API uses 'participant' not 'otherUser'
    final Map<String, dynamic> participant =
        json['participant'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic>? lastMessageData =
        json['lastMessage'] as Map<String, dynamic>?;

    return ConversationModel(
      id: json['_id'] as String,
      // ✅ You may need to get userId from auth provider instead
      userId: json['userId'] as String? ?? '',
      otherUserId:
          participant['_id'] as String? ?? participant['id'] as String? ?? '',
      otherUserName:
          participant['fullName'] as String? ??
          participant['displayName'] as String? ??
          'Unknown',
      otherUserAvatar: AppConstants.resolveMediaUrl(
        participant['profilePicture'],
      ),
      lastMessage: lastMessageData?['content'] as String? ?? 'No messages yet',
      // ✅ API uses 'sentAt' for last message time
      lastMessageTime: lastMessageData != null
          ? DateTime.parse(lastMessageData['sentAt'] as String)
          : DateTime.parse(
              json['updatedAt'] as String? ?? json['createdAt'] as String,
            ),
      unreadCount: json['unreadCount'] as int? ?? 0,
      // ✅ isOnline is at root level in API response
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }

  String get formattedTime {
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(lastMessageTime);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h';
    }
    if (diff.inDays == 1) {
      return 'Yesterday';
    }
    return '${lastMessageTime.day}/${lastMessageTime.month}/${lastMessageTime.year}';
  }
}

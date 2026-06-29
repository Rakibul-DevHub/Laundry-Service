// features/messaging/models/message_model.dart

import 'package:flutter/foundation.dart';

@immutable
class MessageModel {
  final String id;
  final String conversationId;
  final String senderId; //  Just the ID string
  final String receiverId; //  Add receiverId
  final String content;
  final DateTime createdAt;
  final String? imageUrl;
  final String? status; //  Add status: 'sent' | 'delivered' | 'read'

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId, //  New field
    required this.content,
    required this.createdAt,
    this.imageUrl,
    this.status, //  New field
  });

  factory MessageModel.fromApiResponse(Map<String, dynamic> json) {
    //  senderId and receiverId are objects in API response
    final Map<String, dynamic>? senderData =
        json['senderId'] as Map<String, dynamic>?;
    final Map<String, dynamic>? receiverData =
        json['receiverId'] as Map<String, dynamic>?;

    // Extract ID from nested object (handle both '_id' and 'id')
    final String senderId =
        senderData?['_id'] as String? ?? senderData?['id'] as String? ?? '';
    final String receiverId =
        receiverData?['_id'] as String? ?? receiverData?['id'] as String? ?? '';

    return MessageModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      conversationId: json['conversationId'] as String,
      senderId: senderId,
      receiverId: receiverId, //  Store receiverId
      content: json['content'] as String,
      createdAt: DateTime.parse(
        (json['createdAt'] ?? json['sentAt']) as String,
      ),
      imageUrl: json['imageUrl'] as String?,
      status: json['status'] as String?, //  Store status
    );
  }

  String get formattedTime {
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(createdAt);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    if (diff.inDays == 1) {
      return 'Yesterday';
    }
    return '${createdAt.day}/${createdAt.month} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
  }
}

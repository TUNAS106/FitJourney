import 'message.dart';

class ChatRoom {
  final String id;
  final String userId;
  final String ptId;
  final Message? lastMessage;
  final DateTime lastActivity;
  final int unreadCount;

  ChatRoom({
    required this.id,
    required this.userId,
    required this.ptId,
    this.lastMessage,
    required this.lastActivity,
    this.unreadCount = 0,
  });

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'],
      userId: map['userId'],
      ptId: map['ptId'],
      lastMessage: map['lastMessage'] != null
          ? Message.fromMap(map['lastMessage'])
          : null,
      lastActivity: DateTime.fromMillisecondsSinceEpoch(map['lastActivity']),
      unreadCount: map['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'ptId': ptId,
      'lastMessage': lastMessage?.toMap(),
      'lastActivity': lastActivity.millisecondsSinceEpoch,
      'unreadCount': unreadCount,
    };
  }
}
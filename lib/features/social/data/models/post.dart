import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String username;
  final String? userAvatarUrl;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;
  final List<String> likes;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    this.userAvatarUrl,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    this.likes = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'userAvatarUrl': userAvatarUrl,
      'content': content,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'likes': likes,
    };
  }

  factory Post.fromMap(String id, Map<String, dynamic> map) {
    return Post(
      id: id,
      userId: map['userId'],
      username: map['username'],
      userAvatarUrl: map['userAvatarUrl'],
      content: map['content'],
      imageUrl: map['imageUrl'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(map['likes'] ?? []),
    );
  }
}

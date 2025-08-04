import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String text;
  final String authorId;
  final String authorName;
  final String authorAvatarUrl;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.text,
    required this.authorId,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.timestamp,
  });

  factory Comment.fromMap(Map<String, dynamic> data, String id) {
    return Comment(
      id: id,
      text: data['text'],
      authorId: data['authorId'],
      authorName: data['authorName'] ?? '',
      authorAvatarUrl: data['authorAvatarUrl'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatarUrl': authorAvatarUrl,
      'timestamp': timestamp,
    };
  }
}

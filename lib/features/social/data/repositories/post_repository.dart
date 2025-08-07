import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/comment.dart';
import '../models/post.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> toggleLikePost(String postId, String userId) async {
    final postRef = _firestore.collection('posts').doc(postId);

    final postSnapshot = await postRef.get();
    final likes = List<String>.from(postSnapshot['likes'] ?? []);

    if (likes.contains(userId)) {
      // User đã like → Unlike
      likes.remove(userId);
    } else {
      // User chưa like → Like
      likes.add(userId);
    }

    await postRef.update({'likes': likes});
  }

  Future<List<String>> getLikes(String postId) async {
    final post = await _firestore.collection('posts').doc(postId).get();
    return List<String>.from(post['likes'] ?? []);
  }
  Future<void> addComment({
    required String postId,
    required String text,
    required String userId,
    required String authorName,
    required String authorAvatarUrl,
  }) async {
    final commentRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc();

    await commentRef.set({
      'text': text,
      'authorId': userId,
      'authorName': authorName,
      'authorAvatarUrl': authorAvatarUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Comment>> getComments(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Comment.fromMap(doc.data(), doc.id))
        .toList());
  }
  // Tạo bài viết
  Future<void> createPost(Post post) async {
    await _firestore.collection('posts').add(post.toMap());
  }

  // Stream bài viết
  Stream<List<Post>> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Post.fromMap(doc.id, doc.data())).toList());
  }
}
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../data/models/post.dart';


class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload ảnh
  Future<String?> uploadImage(XFile imageFile) async {
    try {
      final fileName = path.basename(imageFile.path);
      final ref = _storage.ref().child('post_images/$fileName');

      final file = File(imageFile.path); // Chuyển XFile => File
      await ref.putFile(file);           // Dùng putFile thay vì putData

      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('[ERRORrrrr] uploadImage: $e');
      return null;
    }
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
}

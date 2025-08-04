import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/cloudinary_service.dart';
import '../data/models/post.dart';
import '../services/post_services.dart';
import 'package:image_picker/image_picker.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final TextEditingController _contentController = TextEditingController();
  final PostService _postService = PostService();
  XFile? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    //print('Đã chọn ảnhhhhhhhhhhhhhhhhhhhhhhhhhhh: ${picked?.path}');
    if (picked != null) {
      setState(() {
        _selectedImage = picked;
        print('Đã chọn ảnhhhhh: ${_selectedImage!.path}');
      });
    }
  }

  Future<void> _submitPost() async {
    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    String username = 'Unknown';
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      username = doc.data()?['name'] ?? 'Unknown';
    }
    try {
      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await uploadImageToCloudinary(_selectedImage!);
      }

      final user = FirebaseAuth.instance.currentUser;
      final post = Post(
        id: '',
        content: _contentController.text,
        imageUrl: imageUrl ?? '',
        timestamp: DateTime.now(),
        userId: user?.uid ?? '',
        username: username,
        userAvatarUrl: user?.photoURL,
        likes: [],
      );

      await _postService.createPost(post);
      Navigator.pop(context);
    } catch (e) {
      print('[ERROR] submitPost: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo bài viết')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(hintText: 'Bạn đang nghĩ gì?'),
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            if (_selectedImage != null)
              Image.file(File(_selectedImage!.path), height: 250),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Chọn ảnh'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitPost,
              child: _isLoading ? CircularProgressIndicator() : const Text('Đăng'),
            ),
          ],
        ),
      ),
    );
  }
}
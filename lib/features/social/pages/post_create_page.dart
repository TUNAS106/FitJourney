import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/cloudinary_service.dart';
import '../data/models/post.dart';
import '../services/post_services.dart';

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
    if (picked != null) {
      setState(() {
        _selectedImage = picked;
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

  Widget _buildGradientButton({
    required String text,
    required IconData icon,
    required VoidCallback? onPressed,
    List<Color>? colors,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors ?? [Colors.blueAccent, Colors.cyanAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (colors ?? [Colors.blueAccent])[0].withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(2, 6),
            ),
          ],
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Tạo bài viết'),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar + Tên
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null
                      ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                      : null,
                  child: FirebaseAuth.instance.currentUser?.photoURL == null
                      ? const Icon(Icons.person, size: 28, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    FirebaseAuth.instance.currentUser?.displayName ?? 'Người dùng',
                    style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // TextField đẹp hơn
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: '💭 Bạn đang nghĩ gì thế?',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(18),
              ),
              style: const TextStyle(fontSize: 16),
              maxLines: 5,
            ),
            const SizedBox(height: 16),

            // Ảnh preview
            if (_selectedImage != null)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(File(_selectedImage!.path)),
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'post-image',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Image.file(
                        File(_selectedImage!.path),
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            if (_selectedImage != null) const SizedBox(height: 16),

            // Nút chọn ảnh
            _buildGradientButton(
              text: 'Chọn ảnh',
              icon: Icons.image_rounded,
              onPressed: _pickImage,
              colors: [Colors.teal, Colors.lightGreen],
            ),
            const SizedBox(height: 16),

            // Nút đăng
            _buildGradientButton(
              text: _isLoading ? 'Đang đăng...' : 'Đăng bài',
              icon: Icons.send_rounded,
              onPressed: _isLoading ? null : _submitPost,
              colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
            ),
          ],
        ),
      ),
    );
  }
}

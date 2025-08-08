import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/models/post.dart';
import 'package:fitjourney/features/social/pages/post_create_page.dart';
import '../services/post_services.dart';
import '../widgets/post_widget.dart';

class PostFeedScreen extends StatelessWidget {
  final PostService _postService = PostService();

  PostFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // title: const Text(
        //   "Bảng tin",
        //   style: TextStyle(color: Colors.black87),
        // ),
        centerTitle: true,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<List<Post>>(
        stream: _postService.getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có bài viết nào',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final posts = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            itemCount: posts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostWidget(post: post, currentUserId: currentUserId);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostCreateScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Thêm bài viết',
      ),
    );
  }
}

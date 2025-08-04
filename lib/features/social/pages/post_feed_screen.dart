import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitjourney/features/social/pages/post_create_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/post.dart';
import '../data/repositories/post_repository.dart';
import '../services/post_services.dart';
import '../widgets/comment_section.dart';
import '../widgets/post_widget.dart';


class PostFeedScreen extends StatelessWidget {
  final PostService _postService = PostService();

  PostFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bảng tin"),
      ),
      body: StreamBuilder<List<Post>>(
        stream: _postService.getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có bài viết nào'));
          }

          final posts = snapshot.data!;

          final user = FirebaseAuth.instance.currentUser;
          final currentUserId = user?.uid ?? '';

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PostWidget(post: post, currentUserId: currentUserId),
                      const SizedBox(height: 8),
                      CommentSection(
                        postId: post.id,
                        currentUserId: currentUserId,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostCreateScreen()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Thêm bài viết',
      ),
    );
  }
}


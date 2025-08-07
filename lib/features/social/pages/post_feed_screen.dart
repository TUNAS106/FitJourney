import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitjourney/features/social/pages/post_create_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../data/models/post.dart';
import '../services/post_services.dart';
import '../widgets/comment_section.dart';
import '../widgets/post_widget.dart';

class PostFeedScreen extends StatelessWidget {
  final PostService _postService = PostService();

  PostFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Bảng tin", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 2,
      ),
      body: StreamBuilder<List<Post>>(
        stream: _postService.getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Chưa có bài viết nào', style: TextStyle(color: Colors.white70)),
            );
          }

          final posts = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            itemCount: posts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                color: const Color(0xFF1E1E1E),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: post.userAvatarUrl != null
                                ? NetworkImage(post.userAvatarUrl!)
                                : const AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
                            radius: 18,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                timeago.format(post.timestamp),
                                style: const TextStyle(color: Colors.white54, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      PostWidget(post: post, currentUserId: currentUserId),
                      const SizedBox(height: 10),
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
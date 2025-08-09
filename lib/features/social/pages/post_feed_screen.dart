import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models/post.dart';
import 'package:fitjourney/features/social/pages/post_create_page.dart';
import '../services/post_services.dart';
import '../widgets/post_widget.dart';

class PostFeedScreen extends StatelessWidget {
  final PostService _postService = PostService();
  final List<String> healthQuotes = const [
    "An apple a day keeps the doctor away.",
    "Take care of your body. It’s the only place you have to live.",
    "Your health is an investment, not an expense.",
    "Drink water, stay hydrated, stay healthy.",
    "Exercise not only changes your body, it changes your mind and mood."
  ];

  PostFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid ?? '';
    final username = currentUser?.displayName ?? 'User';
    final randomQuote = healthQuotes[Random().nextInt(healthQuotes.length)];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // bỏ shadow
        toolbarHeight: 0, // xóa hẳn vùng trắng phía trên
      ),
      body: Stack(
        children: [
          // --- BACKGROUND ICONS MỜ ---
          Positioned.fill(
            child: Opacity(
              opacity: 0.1, // độ mờ
              child: Image.asset(
                'assets/iconback.png', // ảnh pattern icon gym
                fit: BoxFit.cover,
              ),
            ),
          ),

          // --- NỘI DUNG LISTVIEW ---
          StreamBuilder<List<Post>>(
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
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 8),
                itemCount: posts.length + 1,
                separatorBuilder: (context, index) =>
                const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildHeader(
                      FirebaseAuth.instance.currentUser?.displayName ?? 'User',
                      healthQuotes[Random().nextInt(healthQuotes.length)],
                    );
                  }
                  final post = posts[index - 1];
                  return PostWidget(
                    post: post,
                    currentUserId: FirebaseAuth.instance.currentUser?.uid ?? '',
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostCreateScreen()),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "What's on your mind?",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String username, String quote) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid ?? '';
    final username = currentUser?.displayName ?? 'User';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null
                ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                : const AssetImage(
                'assets/avatar_placeholder.png') as ImageProvider,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello ${currentUser?.displayName ?? 'there'} 👋",
                  style: GoogleFonts.lobster(
                    fontSize: 22,
                    color: Colors.deepPurple,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  quote,
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

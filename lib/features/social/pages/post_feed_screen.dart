import 'dart:math';
import 'dart:ui'; // cần để dùng ImageFilter.blur
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
          // --- NỀN BLUR ---
          Positioned.fill(
            child: Container(
              color: Colors.deepPurple.shade100.withOpacity(0.25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(color: Colors.transparent),
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
                return Center(
                  child: Text(
                    'Chưa có bài viết nào',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              final posts = snapshot.data!;

              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                itemCount: posts.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildHeader(
                      context,
                      username,
                      randomQuote,
                    );
                  }
                  final post = posts[index - 1];
                  return PostWidget(
                    post: post,
                    currentUserId: currentUserId,
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

  Widget _buildHeader(BuildContext context, String username, String quote) {
    final currentUser = FirebaseAuth.instance.currentUser;

    final List<IconData> gymIcons = [
      Icons.fitness_center,         // Tạ
      Icons.local_drink,            // Uống nước
      Icons.directions_run,         // Chạy bộ
      Icons.self_improvement,       // Yoga
      Icons.sports_basketball,      // Bóng rổ
      Icons.sports_gymnastics,      // Thể dục dụng cụ
      Icons.sports_martial_arts,    // Võ thuật
      Icons.sports_handball,        // Bóng ném
      Icons.sports_soccer,          // Bóng đá
      Icons.sports_tennis,          // Quần vợt
      Icons.sports_volleyball,      // Bóng chuyền
      Icons.sports_baseball,        // Bóng chày
    ];

    final List<String> funFacts = [
      "Lifting weights: Hafthor Bjornsson (The Mountain) lifted 1,113 pounds in 2025, breaking the world’s strongest man record!",
      "Drinking water: Your body can survive weeks without food, but only days without water. Stay hydrated to perform like Michael Phelps!",
      "Running: Usain Bolt holds the fastest recorded sprint at 27.8 mph, making him the fastest human ever!",
      "Yoga: Tao Porchon-Lynch taught yoga until age 101, showing flexibility is key to longevity.",
      "Basketball: Mario Mandžukić was the first player to score and an own goal in a World Cup final, an unusual basketball twist!",
      "Gymnastics: Simone Biles can twist her body in the air so fast it looks like a spinning top, dominating world championships.",
      "Martial arts: Bruce Lee’s famous one-inch punch delivers power that astonished even professional fighters.",
      "Handball: Speedy throws up to 60 mph are common among top players like Nikola Karabatić.",
      "Soccer: Nawaf Al Abed scored the fastest goal in history after just 2.4 seconds in a Saudi league match!",
      "Tennis: Sam Groth holds the fastest recorded serve at 163.7 mph, faster than many cars on the highway!",
      "Volleyball: Matey Kaziyski’s spike speed reached 89 mph, making him one of the sport’s fastest players.",
      "Baseball: Aroldis Chapman pitched the fastest MLB fastball ever recorded at 105.1 mph!",
    ];


    return StatefulBuilder(
      builder: (context, setState) {
        int? selectedIndex;

        void showFunFact(int index) {
          setState(() {
            selectedIndex = index;
          });
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (ctx) => GestureDetector(
              onTap: () => Navigator.of(ctx).pop(),
              child: Material(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.shade200.withOpacity(0.6),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          funFacts[index],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                          ),
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text("Close"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade50, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.shade100.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: gymIcons.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => showFunFact(index),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.deepPurple.shade100.withOpacity(0.35),
                        child: Icon(
                          gymIcons[index],
                          size: 28,
                          color: Colors.deepPurple.shade700,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: currentUser?.photoURL != null
                        ? NetworkImage(currentUser!.photoURL!)
                        : const AssetImage('assets/avatar_placeholder.png')
                    as ImageProvider,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello ${currentUser?.displayName ?? username} 👋",
                          style: GoogleFonts.lobster(
                            fontSize: 24,
                            color: Colors.deepPurple.shade800,
                            letterSpacing: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          quote,
                          style: const TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

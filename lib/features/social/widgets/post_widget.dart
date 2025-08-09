import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../data/models/post.dart';
import '../data/repositories/post_repository.dart';
import '../widgets/comment_section.dart';

String _formatTimestamp(DateTime time) {
  final now = DateTime.now();
  final difference = now.difference(time);

  if (difference.inMinutes < 1) return 'Vừa xong';
  if (difference.inMinutes < 60) return '${difference.inMinutes} phút trước';
  if (difference.inHours < 24) return '${difference.inHours} giờ trước';
  return DateFormat('dd/MM/yyyy').format(time);
}

class PostWidget extends StatefulWidget {
  final Post post;
  final String currentUserId;

  const PostWidget({super.key, required this.post, required this.currentUserId});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late bool isLiked;
  late int likeCount;
  bool isVip = false;
  bool showComments = false;

  @override
  void initState() {
    super.initState();
    final likesList = widget.post.likes ?? [];
    isLiked = likesList.contains(widget.currentUserId);
    likeCount = likesList.length;
    _fetchUserVipStatus();
  }

  Future<void> _fetchUserVipStatus() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.post.userId)
        .get();
    final data = doc.data();
    if (data != null && mounted) {
      setState(() {
        isVip = data['isVip'] ?? false;
      });
    }
  }

  void _onLikePressed() async {
    await PostRepository().toggleLikePost(widget.post.id, widget.currentUserId);
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  void _onCommentPressed() {
    setState(() {
      showComments = !showComments;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Gradient vàng đậm cho VIP
    // Gradient vàng đậm cho VIP badge
    final vipBadgeGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFE082),
        Color(0xFFFFC107),
        Color(0xFFFFA726),
        Color(0xFFFF7043),
      ],
    );

    final vipPostGradient = const LinearGradient(
      colors: [
        Color(0xFFFFEB80), // vàng đậm đã nhạt 50%
        Color(0xFFFFF2B3), // vàng chính nhạt hơn
        Color(0xFFFFF9E6), // vàng cực nhạt gần trắng
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final normalPostGradient = const LinearGradient(
      colors: [
        Colors.white,
        Colors.white,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );


    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.post.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final likesList = List<String>.from(data['likes'] ?? []);
          isLiked = likesList.contains(widget.currentUserId);
          likeCount = likesList.length;
        }

        return Container(
          decoration: BoxDecoration(
            gradient: isVip ? vipPostGradient : normalPostGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// --- USER INFO ---
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: widget.post.userAvatarUrl != null
                          ? NetworkImage(widget.post.userAvatarUrl!)
                          : const AssetImage(
                          'assets/images/default_avatar.png') as ImageProvider,
                      radius: 22,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.post.username,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            if (isVip) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                    gradient: vipBadgeGradient,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.4),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                ),
                                child: const Text(
                                  'VIP',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                        Text(
                          timeago.format(widget.post.timestamp),
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                /// --- POST CONTENT ---
                if (widget.post.content != null &&
                    widget.post.content!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      widget.post.content!,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15.5,
                        height: 1.4,
                      ),
                    ),
                  ),

                /// --- POST IMAGE ---
                if (widget.post.imageUrl != null &&
                    widget.post.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.post.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 260,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const SizedBox(
                          height: 260,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 10),

                /// --- LIKE + COMMENT BUTTONS ---
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 26,
                      ),
                      onPressed: _onLikePressed,
                    ),
                    Text(
                      '$likeCount',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 14),

                    /// --- COMMENT ICON + COUNT ---
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.post.id)
                          .collection('comments')
                          .snapshots(),
                      builder: (context, snapshot) {
                        int commentCount = 0;
                        if (snapshot.hasData) {
                          commentCount = snapshot.data!.docs.length;
                        }
                        return Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.comment_outlined,
                                size: 24,
                                color: Colors.grey,
                              ),
                              onPressed: _onCommentPressed,
                            ),
                            Text(
                              '$commentCount',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                /// --- COMMENT SECTION ---
                if (showComments)
                  CommentSection(
                    postId: widget.post.id,
                    currentUserId: widget.currentUserId,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

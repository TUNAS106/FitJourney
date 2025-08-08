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
  bool showComments = false; // 👈 Ẩn/hiện comment section

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.likes.contains(widget.currentUserId);
    likeCount = widget.post.likes.length;
    _fetchUserVipStatus();
  }

  Future<void> _fetchUserVipStatus() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(widget.post.userId).get();
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
    return Card(
      color: isVip ? const Color(0xFFFFF8DC) : const Color(0xFFF5F5F5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- USER INFO ---
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: widget.post.userAvatarUrl != null
                      ? NetworkImage(widget.post.userAvatarUrl!)
                      : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                  radius: 18,
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
                          ),
                        ),
                        if (isVip) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFFF9DB),
                                  Color(0xFFFFE97F),
                                  Color(0xFFFFC107),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber.withOpacity(0.4),
                                  blurRadius: 4,
                                  offset: const Offset(1, 2),
                                ),
                              ],
                            ),
                            child: const Text(
                              'VIP',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                shadows: [
                                  Shadow(
                                    blurRadius: 2,
                                    color: Colors.white,
                                    offset: Offset(0.5, 0.5),
                                  ),
                                ],
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
            if (widget.post.content != null && widget.post.content!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Text(
                  widget.post.content!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),


            /// --- POST IMAGE ---
            if (widget.post.imageUrl != null && widget.post.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  widget.post.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 280,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),

            const SizedBox(height: 8),

            /// --- LIKE + COMMENT BUTTONS ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// --- LIKE BUTTON ---
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey,
                          size: 28,
                        ),
                        onPressed: _onLikePressed,
                      ),
                      Text(
                        '$likeCount',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  /// --- COMMENT BUTTON ---
                  IconButton(
                    icon: const Icon(Icons.comment, size: 26, color: Colors.grey),
                    onPressed: _onCommentPressed,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

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
  }
}

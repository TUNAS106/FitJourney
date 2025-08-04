import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/models/post.dart';
import '../data/repositories/post_repository.dart';

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

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.likes.contains(widget.currentUserId);
    likeCount = widget.post.likes.length;
  }

  void _onLikePressed() async {
    await PostRepository().toggleLikePost(widget.post.id, widget.currentUserId);
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: Avatar + Username
        // Inside the build method of _PostWidgetState
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: widget.post.userAvatarUrl != null
                    ? NetworkImage(widget.post.userAvatarUrl!)
                    : null,
                radius: 28,
                child: widget.post.userAvatarUrl == null
                    ? const Icon(Icons.person, size: 32)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                widget.post.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),

        // Post image
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

        // Like & count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.grey,
                  size: 32,
                ),
                onPressed: _onLikePressed,
              ),
              Text(
                '$likeCount lượt thích',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),

        // Content
        if (widget.post.content != null && widget.post.content!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Text(
              widget.post.content!,
              style: const TextStyle(fontSize: 18),
            ),
          ),

        // Timestamp
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          child: Text(
            _formatTimestamp(widget.post.timestamp),
            style: const TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ),
      ],
    );
  }
}
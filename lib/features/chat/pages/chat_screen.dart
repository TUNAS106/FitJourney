import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import '../data/models/message.dart';
import '../../auth/data/models/user.dart' as app;
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../services/chat_services.dart';
import 'package:fitjourney/features/chat/pages/ui_kit.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final app.User receiverUser;

  const ChatScreen({
    Key? key,
    required this.chatRoomId,
    required this.receiverUser,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatService _chatService;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // NEW: UI states (chỉ giao diện)
  bool _showJumpToBottom = false;
  double _wallpaperOpacity = 0.88; // 0.70 -> mờ ít, 0.95 -> mờ nhiều

  @override
  void initState() {
    super.initState();
    _chatService = ChatService(context.read<AuthBloc>());
    _chatService.markMessagesAsRead(widget.chatRoomId);

    _scrollController.addListener(() {
      final show = _scrollController.hasClients && _scrollController.offset > 300;
      if (show != _showJumpToBottom) setState(() => _showJumpToBottom = show);
    });
  }

  void _cycleWallpaperOpacity() { // NEW
    setState(() {
      // các nấc opacity đẹp mắt
      const steps = [0.78, 0.84, 0.88, 0.92];
      final i = steps.indexWhere((v) => (v - _wallpaperOpacity).abs() < 0.02);
      _wallpaperOpacity = steps[(i + 1) % steps.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(decoration: G.gradientAppbar()),
          foregroundColor: Colors.white,
          titleSpacing: 0,
          shape: const RoundedRectangleBorder( // NEW: bo đáy app bar
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          title: Row(
            children: [
              const SizedBox(width: 6),
              Stack( // NEW: avatar + chấm online
                children: [
                  G.avatar(widget.receiverUser.avatarUrl, size: 40),
                  Positioned(
                    right: 0, bottom: 0,
                    child: Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.receiverUser.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  if (widget.receiverUser.isPT)
                    const Text('Huấn luyện viên',
                        style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ],
          ),
          actions: [
            IconButton( // NEW: đổi độ mờ hình nền
              icon: const Icon(Icons.color_lens_outlined, size: 24),
              tooltip: 'Đổi độ mờ hình nền',
              onPressed: _cycleWallpaperOpacity,
            ),
            IconButton( // NEW: video call UI
              icon: const Icon(Icons.videocam_outlined, size: 26),
              tooltip: 'Gọi video',
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gọi video – sắp ra mắt')),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.call_outlined, size: 26),
              tooltip: 'Gọi thoại',
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gọi – sắp ra mắt')),
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 24),
              onSelected: (v) => ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('$v – sắp ra mắt'))),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'Tìm trong cuộc trò chuyện', child: Text('Tìm trong cuộc trò chuyện')),
                PopupMenuItem(value: 'Tắt thông báo', child: Text('Tắt thông báo')),
                PopupMenuItem(value: 'Đổi hình nền', child: Text('Đổi hình nền')),
                PopupMenuItem(value: 'Báo cáo', child: Text('Báo cáo')),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Nền
          Positioned.fill(child: Image.asset('assets/nenchat.jpg', fit: BoxFit.cover)),
          Positioned.fill(child: Container(color: Colors.white.withOpacity(_wallpaperOpacity))),

          Column(
            children: [
              Expanded(
                child: StreamBuilder<List<Message>>(
                  stream: _chatService.getMessages(widget.chatRoomId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Lỗi: ${snapshot.error}'));
                    }
                    final messages = snapshot.data ?? [];
                    if (messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.chat_bubble_outline, size: 72, color: AppColors.textSubtle),
                            SizedBox(height: 12),
                            Text('Bắt đầu cuộc trò chuyện',
                                style: TextStyle(color: AppColors.textSubtle, fontSize: 18)),
                          ],
                        ),
                      );
                    }

                    // NEW: RefreshIndicator chỉ để hiệu ứng (không đổi logic)
                    return RefreshIndicator(
                      onRefresh: () async => Future.delayed(const Duration(milliseconds: 500)),
                      child: ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final m = messages[index];

                          // Chip ngày
                          bool showDateDivider = false;
                          if (index == messages.length - 1) {
                            showDateDivider = true;
                          } else {
                            final prev = messages[index + 1];
                            final a = m.timestamp, b = prev.timestamp;
                            showDateDivider = a.year != b.year || a.month != b.month || a.day != b.day;
                          }

                          return BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              if (state is! Authenticated) return const SizedBox.shrink();
                              final isMe = m.senderId == state.user.id;

                              // NEW: bubble kính mờ cho bên đối phương
                              Widget bubble = Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.76,
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: isMe
                                      ? const LinearGradient(
                                    colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                      : null,
                                  color: isMe ? null : Colors.white.withOpacity(0.85),
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(18),
                                    topRight: const Radius.circular(18),
                                    bottomLeft: Radius.circular(isMe ? 18 : 6),
                                    bottomRight: Radius.circular(isMe ? 6 : 18),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      m.content,
                                      style: TextStyle(
                                        color: isMe ? Colors.white : AppColors.textStrong,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _formatTime(m.timestamp),
                                          style: TextStyle(
                                            color: isMe ? Colors.white70 : AppColors.textSubtle,
                                            fontSize: 13,
                                          ),
                                        ),
                                        if (isMe && m.isRead) ...[
                                          const SizedBox(width: 4),
                                          Icon(Icons.done_all,
                                              size: 16,
                                              color: isMe ? Colors.white70 : AppColors.textSubtle),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              );

                              if (!isMe) {
                                bubble = ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                                  child: BackdropFilter( // làm mờ nền phía sau bubble
                                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                    child: bubble,
                                  ),
                                );
                              }

                              final row = Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                  children: [
                                    if (!isMe) ...[
                                      G.avatar(widget.receiverUser.avatarUrl, size: 28),
                                      const SizedBox(width: 8),
                                    ],
                                    GestureDetector(
                                      onLongPress: () { // NEW: menu nhanh (UI)
                                        showModalBottomSheet(
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                          ),
                                          builder: (_) => SafeArea(
                                            child: Wrap(children: const [
                                              ListTile(leading: Icon(Icons.copy), title: Text('Sao chép')),
                                              ListTile(leading: Icon(Icons.reply), title: Text('Trả lời')),
                                              ListTile(leading: Icon(Icons.forward), title: Text('Chuyển tiếp')),
                                              Divider(height: 0),
                                              ListTile(leading: Icon(Icons.delete_outline), title: Text('Xoá')),
                                            ]),
                                          ),
                                        );
                                      },
                                      child: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 150),
                                        switchInCurve: Curves.easeOut,
                                        child: bubble,
                                      ),
                                    ),
                                    if (isMe) ...[
                                      const SizedBox(width: 8),
                                      G.avatar((state).user.avatarUrl, size: 28),
                                    ],
                                  ],
                                ),
                              );

                              return Column(
                                children: [
                                  if (showDateDivider)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(999),
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFFE0E7FF), Color(0xFFF1F5FF)],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            )
                                          ],
                                        ),
                                        child: Text(
                                          '${m.timestamp.day}/${m.timestamp.month}/${m.timestamp.year}',
                                          style: const TextStyle(fontSize: 13, color: Colors.black54),
                                        ),
                                      ),
                                    ),
                                  row,
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              // Input bar
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.photo_outlined),
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Chọn ảnh – sắp ra mắt'))),
                      ),
                      IconButton(
                        icon: const Icon(Icons.mic_none),
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Ghi âm – sắp ra mắt'))),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          style: const TextStyle(fontSize: 18),
                          decoration: G
                              .pillInput('Nhập tin nhắn...')
                              .copyWith(hintStyle: const TextStyle(fontSize: 16, color: Colors.black38)),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkResponse(
                        onTap: _sendMessage,
                        radius: 28,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [AppColors.blueTop, AppColors.blueMid],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(Icons.send, color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (_showJumpToBottom) // NEW
            Positioned(
              right: 16,
              bottom: 96,
              child: FloatingActionButton.small(
                heroTag: 'jumpToBottom',
                backgroundColor: Colors.blueAccent,
                child: const Icon(Icons.arrow_downward, color: Colors.white),
                onPressed: () {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  // ===== GIỮ NGUYÊN LOGIC GỬI TIN =====
  void _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    _messageController.clear();

    try {
      await _chatService.sendMessage(
        widget.chatRoomId,
        widget.receiverUser.id,
        content,
      );
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi gửi tin nhắn: $e')),
      );
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inDays > 0) return '${dateTime.day}/${dateTime.month}';
    if (difference.inHours > 0) return '${difference.inHours}h';
    if (difference.inMinutes > 0) return '${difference.inMinutes}p';
    return 'Vừa xong';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
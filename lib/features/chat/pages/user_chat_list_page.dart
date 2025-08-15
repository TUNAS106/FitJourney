
import 'package:fitjourney/features/chat/pages/pt_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../AI_features/Ai_chat_screen.dart';
import '../../auth/bloc/auth_state.dart';
import '../data/models/chat_room.dart';
import '../../auth/data/models/user.dart' as app;
import '../../auth/bloc/auth_bloc.dart';
import '../services/chat_services.dart';
import 'chat_screen.dart';
import 'dart:ui' as ui;
import 'package:fitjourney/features/chat/pages/ui_kit.dart';


class UserChatListScreen extends StatelessWidget {
  const UserChatListScreen({super.key});

  String _fmt(DateTime dt) {
    final now = DateTime.now();
    final d = now.difference(dt);
    if (d.inDays >= 1) return '${dt.day}/${dt.month}';
    if (d.inHours >= 1) return '${d.inHours}h';
    if (d.inMinutes >= 1) return '${d.inMinutes}p';
    return 'vừa xong';
  }

  @override
  Widget build(BuildContext context) {
    final chatService = ChatService(context.read<AuthBloc>());

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: null, // tránh trùng AppBar với HomePage

      body: Stack(
        children: [
          // === ẢNH NỀN TOÀN MÀN ===
          Positioned.fill(
            child: Image.asset('assets/nenchat.jpg', fit: BoxFit.cover),
          ),

          // === LỚP PHỦ ĐỘ MỜ để nội dung nổi rõ (UI only) ===
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.86)),
          ),

          // === VIGNETTE nhẹ ở cuối để list/FAB nổi rõ (UI only) ===
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.white.withOpacity(0.88)],
                    stops: const [0.55, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // ==== blobs nền nhẹ cho sinh động (UI only) ====
          Positioned(
            top: -60,
            left: -40,
            child: Container(
              width: 160, height: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Color(0x1142A5F5),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: -30,
            child: Container(
              width: 120, height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Color(0x1026C6DA),
              ),
            ),
          ),

          // ==== Nội dung chính ====
          Column(
            children: [
              // ===== Header “Tin nhắn của tôi” + nút + =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                    begin: Alignment.centerLeft, end: Alignment.centerRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.08),
                      blurRadius: 10, offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Tin nhắn của tôi',
                        style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18,
                        ),
                      ),
                    ),
                    // Nút + có pulse nhẹ (UI only)
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.96, end: 1.0),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeInOut,
                      builder: (_, v, child) => Transform.scale(scale: v, child: child),
                      onEnd: () => Future.delayed(
                        const Duration(milliseconds: 300),
                            () => (context as Element).markNeedsBuild(),
                      ),
                      child: Material(
                        color: Colors.white.withOpacity(.18),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            Navigator.push(
                              context, MaterialPageRoute(builder: (_) => PTListScreen()),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.add, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ===== Danh sách chat (giữ nguyên logic) =====
              Expanded(
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    return StreamBuilder<List<ChatRoom>>(
                      stream: chatService.getUserChatRooms(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Lỗi: ${snapshot.error}'));
                        }

                        final rooms = snapshot.data ?? [];

                        if (rooms.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                  decoration: G.softCard(20),
                                  child: const Text('Chưa có cuộc trò chuyện nào',
                                      style: TextStyle(color: AppColors.textSubtle)),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.blueTop,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context, MaterialPageRoute(builder: (_) => PTListScreen()),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Nhắn tin với PT'),
                                ),
                              ],
                            ),
                          );
                        }

                        // Thông báo nhỏ số cuộc trò chuyện chưa đọc
                        final unreadRooms = rooms.where((e) => e.unreadCount > 0).length;
                        final headerNotice = unreadRooms > 0
                            ? Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECF3FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Bạn có $unreadRooms cuộc trò chuyện chưa đọc',
                              style: const TextStyle(
                                color: AppColors.textStrong, fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                            : const SizedBox.shrink();

                        return Column(
                          children: [
                            headerNotice,
                            Expanded(
                              child: ListView.separated(
                                padding: const EdgeInsets.fromLTRB(16, 14, 16, 96),
                                itemCount: rooms.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 16),
                                itemBuilder: (_, i) {
                                  final r = rooms[i];
                                  return FutureBuilder<app.User?>(
                                    future: chatService.getUserById(r.ptId),
                                    builder: (_, s) {
                                      if (!s.hasData) {
                                        return Container(
                                          decoration: G.softCard(),
                                          padding: const EdgeInsets.all(16),
                                          child: const Text('Đang tải...'),
                                        );
                                      }
                                      final pt = s.data!;
                                      final hasUnread = r.unreadCount > 0;

                                      return InkWell(
                                        borderRadius: BorderRadius.circular(16),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ChatScreen(
                                                chatRoomId: r.id, receiverUser: pt,
                                              ),
                                            ),
                                          );
                                        },
                                        onLongPress: () {
                                          // Bottom sheet UI-only
                                          showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                            ),
                                            builder: (_) => const SafeArea(
                                              child: Wrap(
                                                children: [
                                                  ListTile(
                                                    leading: Icon(Icons.push_pin_outlined),
                                                    title: Text('Ghim trò chuyện'),
                                                  ),
                                                  ListTile(
                                                    leading: Icon(Icons.notifications_off_outlined),
                                                    title: Text('Tạm ẩn thông báo'),
                                                  ),
                                                  Divider(height: 0),
                                                  ListTile(
                                                    leading: Icon(Icons.delete_outline),
                                                    title: Text('Xoá khỏi danh sách'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        // === Glassmorphism card (UI only) ===
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: BackdropFilter(
                                            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                            child: Container(
                                              decoration: G.softCard().copyWith(
                                                color: Colors.white.withOpacity(0.65),
                                              ),
                                              padding: const EdgeInsets.all(16),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  // Avatar + aura + Hero (UI only)
                                                  Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Container(
                                                        width: 64, height: 64,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          gradient: hasUnread
                                                              ? const LinearGradient(
                                                            colors: [Color(0xFF7DD3FC), Color(0xFF60A5FA)],
                                                          )
                                                              : const LinearGradient(
                                                            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                                                          ),
                                                          boxShadow: [
                                                            if (hasUnread)
                                                              BoxShadow(
                                                                color: const Color(0xFF60A5FA).withOpacity(.35),
                                                                blurRadius: 14, offset: const Offset(0, 6),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                      Hero(
                                                        tag: 'ptAvatar_${pt.id}',
                                                        child: G.avatar(pt.avatarUrl, size: 56),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 14),

                                                  // Tên + preview
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          pt.name,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.w800,
                                                            fontSize: 18,
                                                            color: AppColors.textStrong,
                                                            height: 1.1,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Text(
                                                          r.lastMessage?.content ?? 'Chưa có tin nhắn',
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                            color: AppColors.textSubtle,
                                                            fontSize: 18,
                                                            height: 1.1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  const SizedBox(width: 10),

                                                  // Cột phải: thời gian (chip) + badge
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      if (r.lastMessage != null)
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 8, vertical: 4),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(999),
                                                            gradient: const LinearGradient(
                                                              colors: [Color(0xFF90CAF9), Color(0xFF42A5F5)],
                                                            ),
                                                          ),
                                                          child: Text(
                                                            _fmt(r.lastMessage!.timestamp),
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      if (hasUnread) const SizedBox(height: 8),
                                                      if (hasUnread)
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 10, vertical: 6),
                                                          decoration: BoxDecoration(
                                                            color: Colors.redAccent,
                                                            borderRadius: BorderRadius.circular(999),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.redAccent.withOpacity(.25),
                                                                blurRadius: 10, offset: const Offset(0, 4),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Text(
                                                            '${r.unreadCount}',
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),

      // ===== Gemini FAB (giữ nguyên logic, pulse nhẹ) =====
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.blueTop, AppColors.blueMid],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 10, offset: const Offset(0, 6)),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.smart_toy, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  "Tôi là Gemini \n Hỏi tôi bất kỳ điều gì về luyện tập!",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.96, end: 1.0),
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            builder: (context, v, child) => Transform.scale(scale: v, child: child),
            onEnd: () => Future.delayed(
              const Duration(milliseconds: 350),
                  () => (context as Element).markNeedsBuild(),
            ),
            child: FloatingActionButton(
              backgroundColor: AppColors.accent,
              elevation: 6,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => GeminiChatScreen()));
              },
              child: const Icon(Icons.question_answer, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
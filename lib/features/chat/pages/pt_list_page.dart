// screens/pt_list_screen.dart
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../auth/data/models/user.dart' as app;
import '../../auth/bloc/auth_bloc.dart';
import '../services/chat_services.dart';
import 'chat_screen.dart';


class PTListScreen extends StatelessWidget {
  const PTListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatService = ChatService(context.read<AuthBloc>());

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      // AppBar gradient – chỉ làm đẹp
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF4DD0E1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          foregroundColor: Colors.white,
          title: const Text('Chọn Huấn luyện viên',
              style: TextStyle(fontWeight: FontWeight.w800)),
          centerTitle: true,
        ),
      ),

      body: Stack(
        children: [
          // Nền ảnh nhẹ – chỉ trang trí
          Positioned.fill(
            child: Image.asset('assets/nenchat.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(.90)),
          ),

          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              return StreamBuilder<List<app.User>>(
                stream: chatService.getPTList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  }

                  final pts = snapshot.data ?? [];
                  if (pts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.fitness_center, size: 72, color: Colors.black26),
                          SizedBox(height: 12),
                          Text('Chưa có huấn luyện viên nào',
                              style: TextStyle(color: Colors.black45)),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // Badge tổng số PT – chỉ hiển thị
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Có ${pts.length} huấn luyện viên',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0D47A1)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                          itemCount: pts.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final pt = pts[i];

                            return InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onLongPress: () {
                                // Bottom sheet UI-only (không đổi logic)
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (_) => SafeArea(
                                    child: Wrap(
                                      children: const [
                                        ListTile(
                                          leading: Icon(Icons.push_pin_outlined),
                                          title: Text('Ghim huấn luyện viên'),
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
                              onTap: () async {
                                // GIỮ NGUYÊN LOGIC
                                try {
                                  final chatRoomId =
                                  await chatService.createOrGetChatRoom(pt.id);
                                  // GIỮ NGUYÊN ĐIỀU HƯỚNG
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                        chatRoomId: chatRoomId,
                                        receiverUser: pt,
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Lỗi: $e')),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  // viền gradient mảnh
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF64B5F6), Color(0xFFB2EBF2)],
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: BackdropFilter(
                                    filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(.92),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(.05),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          // Avatar với Hero + viền gradient + dot
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                width: 58,
                                                height: 58,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xFFBBDEFB),
                                                      Color(0xFFE3F2FD)
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                ),
                                              ),
                                              Hero(
                                                tag: 'ptAvatar_${pt.id}', // khớp với ChatScreen nếu đã bọc Hero
                                                child: CircleAvatar(
                                                  radius: 24,
                                                  backgroundColor: Colors.grey[300],
                                                  backgroundImage: pt.avatarUrl.isNotEmpty
                                                      ? NetworkImage(pt.avatarUrl)
                                                      : null,
                                                  child: pt.avatarUrl.isEmpty
                                                      ? const Icon(Icons.person,
                                                      color: Colors.white70)
                                                      : null,
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                bottom: 0,
                                                child: Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    color: Colors.greenAccent,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.white, width: 2),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 12),

                                          // Tên + mô tả
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children:  [
                                                // tên
                                                _PTName(pt.name),
                                                SizedBox(height: 4),
                                                Text(
                                                  'Huấn luyện viên chuyên nghiệp',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(width: 10),

                                          // Actions: call (UI) + chat (nhún)
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _SoftCircleIcon(
                                                icon: Icons.call_outlined,
                                                onTap: () => ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                  content: Text('Gọi – sắp ra mắt'),
                                                )),
                                              ),
                                              const SizedBox(width: 8),
                                              TweenAnimationBuilder<double>(
                                                tween: Tween(begin: .96, end: 1),
                                                duration:
                                                const Duration(seconds: 1),
                                                curve: Curves.easeInOut,
                                                builder: (_, v, child) =>
                                                    Transform.scale(
                                                        scale: v, child: child),
                                                onEnd: () =>
                                                    (context as Element)
                                                        .markNeedsBuild(),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                    const LinearGradient(
                                                      colors: [
                                                        Color(0xFF2196F3),
                                                        Color(0xFF42A5F5)
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                      Alignment.bottomRight,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color:
                                                        const Color(0xFF2196F3)
                                                            .withOpacity(.25),
                                                        blurRadius: 10,
                                                        offset:
                                                        const Offset(0, 4),
                                                      ),
                                                    ],
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        12),
                                                  ),
                                                  child: const Padding(
                                                    padding:
                                                    EdgeInsets.all(8.0),
                                                    child: Icon(
                                                      Icons.chat_bubble_rounded,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
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
                              ),
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
        ],
      ),
    );
  }
}

class _PTName extends StatelessWidget {
  final String name;
  const _PTName(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      name.isNotEmpty ? name : 'Huấn luyện viên',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF102027),
      ),
    );
  }
}

/// Nút tròn mềm (call, v.v.) – chỉ UI
class _SoftCircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SoftCircleIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Icon(icon, color: const Color(0xFF1565C0), size: 20),
        ),
      ),
    );
  }
}
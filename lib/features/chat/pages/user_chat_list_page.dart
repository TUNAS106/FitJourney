
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


class UserChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tin nhắn của tôi'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add_comment),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PTListScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final chatService = ChatService(context.read<AuthBloc>());

          return StreamBuilder<List<ChatRoom>>(
            stream: chatService.getUserChatRooms(), // Cho User
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              }

              final chatRooms = snapshot.data ?? [];

              if (chatRooms.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Chưa có cuộc trò chuyện nào',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PTListScreen()),
                          );
                        },
                        icon: Icon(Icons.add),
                        label: Text('Nhắn tin với PT'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: chatRooms.length,
                itemBuilder: (context, index) {
                  final chatRoom = chatRooms[index];
                  return FutureBuilder<app.User?>(
                    future: chatService.getUserById(chatRoom.ptId), // Lấy thông tin PT
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) {
                        return ListTile(
                          leading: CircleAvatar(backgroundColor: Colors.grey[300]),
                          title: Text('Đang tải...'),
                        );
                      }

                      final pt = userSnapshot.data!;
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(pt.avatarUrl),
                            backgroundColor: Colors.grey[300],
                          ),
                          title: Text(
                            pt.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            chatRoom.lastMessage?.content ?? 'Chưa có tin nhắn',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: chatRoom.unreadCount > 0
                              ? Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${chatRoom.unreadCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                              : null,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  chatRoomId: chatRoom.id,
                                  receiverUser: pt,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thẻ text
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.indigo[900], // nền xanh đậm
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Tôi là gemini,\nRất vui để hỗ trợ quá trình tập luyện cho bạn,\nHãy nháy vào đây để đặt câu hỏi",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 4), // khoảng cách giữa text và nút
          // Nút AI tròn
          FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GeminiChatScreen()),
              );
            },
            child: Icon(Icons.smart_toy, size: 26, color: Colors.white),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
// screens/pt_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/bloc/auth_state.dart';
import '../../auth/data/models/user.dart' as app;
import '../../auth/bloc/auth_bloc.dart';
import '../services/chat_services.dart';
import 'chat_screen.dart';


class PTListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn Huấn luyện viên'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final chatService = ChatService(context.read<AuthBloc>());

          return StreamBuilder<List<app.User>>(
            stream: chatService.getPTList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Lỗi: ${snapshot.error}'),
                );
              }

              final ptList = snapshot.data ?? [];

              if (ptList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Chưa có huấn luyện viên nào',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: ptList.length,
                itemBuilder: (context, index) {
                  final pt = ptList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(pt.avatarUrl),
                        backgroundColor: Colors.grey[300],
                      ),
                      title: Text(
                        pt.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Huấn luyện viên chuyên nghiệp'),
                      trailing: Icon(Icons.chat, color: Colors.blue[600]),
                      onTap: () async {
                        try {
                          final chatRoomId = await chatService.createOrGetChatRoom(pt.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
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
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
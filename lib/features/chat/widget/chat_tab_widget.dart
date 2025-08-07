// widgets/chat_tab_widget.dart - Widget để tích hợp vào TabBar
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../pages/chat_list_page.dart';
import '../pages/user_chat_list_page.dart';


class ChatTabWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          // Kiểm tra nếu user là PT thì hiển thị ChatListScreen
          // Nếu là user thường thì hiển thị UserChatListScreen
          if (state.user.isPT) {
            return ChatListScreen(); // Cho PT xem tất cả tin nhắn từ users
          } else {
            return UserChatListScreen(); // Cho user xem tin nhắn với PT
          }
        }

        return Center(
          child: Text(
            'Vui lòng đăng nhập để sử dụng tính năng chat',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      },
    );
  }
}
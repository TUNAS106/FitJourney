import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'my_app.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();//đảm bảo Flutter đã sẵn sàng trước khi khởi tạo Firebase
  await Firebase.initializeApp();// khởi tạo Firebase
  runApp(
    BlocProvider(
      create: (_) => AuthBloc()..add(AppStarted()),
      child: const MyApp(),
    ),
  );
}

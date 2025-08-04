import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/pages/login_page.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_state.dart';
import 'home/pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitJourney',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
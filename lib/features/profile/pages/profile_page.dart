import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../auth/pages/login_page.dart';
import '../../auth/pages/edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitJourney - Profile'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(LoggedOut());
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final state = context.read<AuthBloc>().state;
              if (state is Authenticated) {
                final user = state.user;
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(
                      name: user.name,
                      email: user.email,
                      gender: user.gender,
                      age: user.age,
                    ),
                  ),
                );
                if (updated == true) {
                  // Reload user info after editing
                  await context.read<AuthBloc>().reloadCurrentUser();
                }
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            final user = state.user;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: user.avatarUrl.isNotEmpty
                          ? NetworkImage(user.avatarUrl)
                          : null,
                      child: user.avatarUrl.isEmpty
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _profileInfoRow(Icons.person, 'Gender', user.gender),
                            const SizedBox(height: 12),
                            _profileInfoRow(Icons.cake, 'Age', user.age.toString()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('No user data'));
          }
        },
      ),
    );
  }

  Widget _profileInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Text(value),
      ],
    );
  }
}
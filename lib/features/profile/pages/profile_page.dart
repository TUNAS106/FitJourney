import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../auth/pages/edit_profile_page.dart';
import '../../auth/pages/login_page.dart';
import '../../auth/pages/upgrade_vip_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitJourney - Profile', style: TextStyle(fontSize: 25)),
        actions: [
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
                  await context.read<AuthBloc>().reloadCurrentUser();
                }
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Authenticated) {
            final user = state.user;
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF5722), Color(0xFFFF8A50)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: user.avatarUrl.isNotEmpty
                              ? NetworkImage(user.avatarUrl)
                              : null,
                          child: user.avatarUrl.isEmpty
                              ? const Icon(Icons.person, size: 30)
                              : null,
                          backgroundColor: Colors.grey.shade300,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.email,
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.white70,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (user.isVip)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF9C27B0),
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  'VIP',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Account Information Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey.shade50],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Account Information',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _profileInfoRow(Icons.person, 'Full Name',
                                  user.name, Icons.edit, () {
                                    Navigator.push(
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
                                  }),
                              const SizedBox(height: 12),
                              _profileInfoRow(Icons.phone, 'Phone',
                                  '+1 (555) 123-45', Icons.edit, () {}),
                              const SizedBox(height: 12),
                              _profileInfoRow(Icons.email, 'Email', user.email,
                                  Icons.check, () {}),
                              const SizedBox(height: 12),
                              _profileInfoRow(Icons.location_pin, 'Location',
                                  'New York, NY', Icons.edit, () {}),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Role Management Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey.shade50],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.isVip ? 'VIP Package' : 'Basic Package',
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Current Role',
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            user.isVip
                                                ? Icons.star
                                                : Icons.person,
                                            size: 16,
                                            color: user.isVip
                                                ? const Color(0xFF9C27B0)
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            user.isVip ? 'VIP' : 'User',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: user.isVip
                                                  ? Colors.purple.shade700
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      if (user.isVip && user.vipExpiry != null) ...[
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today, size: 16, color: Colors.purple),
                                            const SizedBox(width: 4),
                                            // --- Updated code here ---
                                            Builder(
                                              builder: (context) {
                                                DateTime? expiryDate;
                                                if (user.vipExpiry is DateTime) {
                                                  expiryDate = user.vipExpiry;
                                                } else if (user.vipExpiry is String) {
                                                  expiryDate = DateTime.tryParse(user.vipExpiry as String);
                                                }
                                                int daysLeft = expiryDate != null
                                                    ? expiryDate.difference(DateTime.now()).inDays
                                                    : 0;
                                                String formattedDate = expiryDate != null
                                                    ? '${expiryDate.toLocal().toString().split(' ')[0]}'
                                                    : 'N/A';
                                                return Text(
                                                  'Expires in $daysLeft days ($formattedDate)',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.purple,
                                                  ),
                                                );
                                              },
                                            ),
                                            // --- End updated code ---
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                              if (!user.isVip) ...[
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.star, color: Color(0xFF9C27B0)),
                                    label: const Text('Access VIP Feature', style: TextStyle(fontSize: 19)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const UpgradeVipPage()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.purple,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                      ),
                                      elevation: 2,
                                      padding: const EdgeInsets.symmetric(vertical: 16), // makes button taller
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Change Password & Sign Out
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Card(
                          elevation: 4,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          color: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.grey.shade50],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.logout,
                                  color: Colors.red, size: 24),
                              title: const Text(
                                'Sign Out',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                context.read<AuthBloc>().add(LoggedOut());
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => const LoginPage()),
                                );
                              },
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(16)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No user data', style: TextStyle(fontSize: 16)));
          }
        },
      ),
    );
  }

  Widget _profileInfoRow(IconData icon, String label, String value,
      IconData actionIcon, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blueAccent, size: 20),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 17)),
                Text(value,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 15, letterSpacing: 0.2)),
              ],
            ),
          ],
        ),
        IconButton(
          icon: Icon(actionIcon, size: 20),
          onPressed: onTap,
          color: actionIcon == Icons.check ? Colors.green : Colors.blue,
          splashRadius: 20,
        ),
      ],
    );
  }
}
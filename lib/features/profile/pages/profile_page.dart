import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Achievement/pages/Achievement_pages.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../auth/pages/edit_profile_page.dart';
import '../../auth/pages/login_page.dart';
import '../../auth/pages/upgrade_vip_page.dart';
import '../../auth/pages/change_password_page.dart';
import 'dart:ui'; // Cần import để dùng ImageFilter

final vipBadgeGradient = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFFFE082),
    Color(0xFFFFC107),
    Color(0xFFFFA726),
    Color(0xFFFF7043),
  ],
);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> {
  final String backgroundImageUrl = 'assets/design/gym1.jpg';
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AuthBloc>().reloadCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
      // 1. Background Image
      Image.asset(
      backgroundImageUrl,
      fit: BoxFit.cover,
    ),
    // 2. Blur + màu phủ
    BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
    child: Container(
    color: Colors.black.withOpacity(0.05),
    ),
    ),
      Scaffold(
        backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 4,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
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
                      phoneNumber: user.phoneNumber,
                      bio: user.bio,
                      location: user.location,
                    ),
                  ),
                );
                if (updated == true) {
                  await context.read<AuthBloc>().reloadCurrentUser();
                  setState(() {});
                }
              }
            },
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text(
              'Edit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ],
      ),


      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Authenticated) {
            final user = state.user;
            final isVip = user.isVip ?? false;
            final isPT = user.isPT ?? false;
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          // Color(0xFF4A90E2), // xanh dương hơi đậm
                          // Color(0xFF357ABD), xanh dương đậm hơn một chút
                          Colors.black, // hoặc Color(0xFF000000)
                          Colors.grey, // xám nhạt
                        ],
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
                              Row(
                                children: [
                                  const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${user.challenge - 1}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.white70,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        if (isVip)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: vipBadgeGradient,  // Thay color bằng gradient
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadowColor: Colors.blueGrey.shade100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.blueGrey.shade50],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Account Information',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              SizedBox(height: 24),
                              ...[
                                _profileInfoRow(Icons.person, 'Full Name', user.name),
                                _profileInfoRow(Icons.phone, 'Phone',
                                    user.phoneNumber?.isNotEmpty == true
                                        ? user.phoneNumber!
                                        : 'Not updated'),
                                _profileInfoRow(Icons.info, 'Bio',
                                    user.bio?.isNotEmpty == true ? user.bio! : 'Not updated'),
                                _profileInfoRow(Icons.email, 'Email', user.email),
                                _profileInfoRow(Icons.location_pin, 'Location',
                                    user.location?.isNotEmpty == true
                                        ? user.location!
                                        : 'Not updated'),
                              ], // bỏ divider cuối cùng
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Role Management Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey.shade100],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isVip
                                    ? 'VIP Package'
                                    : isPT
                                    ? 'PT Package'
                                    : 'Basic Package',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                decoration: BoxDecoration(
                                  gradient: isVip
                                      ? LinearGradient(colors: [Colors.yellow.shade100, Colors.amber.shade200])
                                      : isPT
                                      ? LinearGradient(colors: [Colors.orange.shade100, Colors.deepOrange.shade200])
                                      : LinearGradient(colors: [Colors.grey.shade200, Colors.grey.shade300]),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    if (isVip)
                                      BoxShadow(
                                        color: Colors.amber.withOpacity(0.6),
                                        blurRadius: 12,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 3),
                                      )
                                    else if (isPT)
                                      BoxShadow(
                                        color: Colors.deepOrange.withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 3),
                                      )
                                    else
                                      BoxShadow(
                                        color: Colors.grey.shade400.withOpacity(0.4),
                                        blurRadius: 8,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 2),
                                      ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: isVip
                                            ? [
                                          BoxShadow(
                                            color: Colors.amber.withOpacity(0.8),
                                            blurRadius: 12,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                            : null,
                                      ),
                                      child: Icon(
                                        isVip
                                            ? Icons.star
                                            : isPT
                                            ? Icons.fitness_center
                                            : Icons.person,
                                        size: 28,
                                        color: isVip
                                            ? Colors.amber.shade700
                                            : isPT
                                            ? Colors.deepOrange
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      isVip
                                          ? 'VIP'
                                          : isPT
                                          ? 'PT'
                                          : 'User',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: isVip
                                            ? Colors.amber.shade800
                                            : isPT
                                            ? Colors.deepOrange.shade700
                                            : Colors.grey.shade600,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              if (isVip && user.vipExpiry != null) ...[
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 18, color: Colors.red),
                                    const SizedBox(width: 8),
                                    Builder(
                                      builder: (context) {
                                        DateTime? expiryDate;
                                        if (user.vipExpiry is DateTime) {
                                          expiryDate = user.vipExpiry;
                                        } else if (user.vipExpiry is String) {
                                          expiryDate = DateTime.tryParse(user.vipExpiry as String);
                                        }
                                        final daysLeft = expiryDate != null
                                            ? expiryDate.difference(DateTime.now()).inDays
                                            : 0;
                                        final formattedDate = expiryDate != null
                                            ? '${expiryDate.toLocal().toString().split(' ')[0]}'
                                            : 'N/A';
                                        return Text(
                                          'Expires in $daysLeft days ($formattedDate)',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                              if (!isVip && !isPT) ...[
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity, // rộng full nếu muốn
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF9C27B0), Color(0xFFE040FB)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.star),
                                      label: const Text(
                                        'Access VIP Feature',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const UpgradeVipPage()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent, // để lộ gradient của DecoratedBox
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        foregroundColor: Colors.white,
                                        elevation: 5,
                                      ).copyWith(
                                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                              (states) {
                                            if (states.contains(MaterialState.pressed)) {
                                              return Colors.deepPurple.shade300.withOpacity(0.5);
                                            }
                                            return null; // để giữ transparent gradient khi không nhấn
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.fitness_center),
                                  label: const Text('Upgrade to PT', style: TextStyle(fontSize: 20)),
                                  onPressed: () async {
                                    await context.read<AuthBloc>().upgradeToPT();
                                    await context.read<AuthBloc>().reloadCurrentUser();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: Colors.deepOrange,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 5,
                                    shadowColor: Colors.deepOrangeAccent.withOpacity(0.6),
                                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Achievement Button Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.emoji_events, color: Colors.amber),
                        label: const Text('Achievements', style: TextStyle(fontSize: 19, color: Colors.red)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AchievementPage(
                                  userId: user.id,
                                onProgressUpdated: () async {
                                  await context.read<AuthBloc>().reloadCurrentUser();
                                  setState(() {});
                                },
                              ), // Đảm bảo bạn đã tạo AchievementPage
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.amber,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(vertical: 16),
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

                        // Nút Change Password
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
                              leading: const Icon(Icons.lock, color: Colors.blue, size: 24),
                              title: const Text(
                                'Change Password',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                // Điều hướng tới trang đổi mật khẩu
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                                );
                              },
                              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Nút Sign Out
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
                              leading: const Icon(Icons.logout, color: Colors.red, size: 24),
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
                                  MaterialPageRoute(builder: (_) => const LoginPage()),
                                );
                              },
                              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Center(
                child: Text('No user data', style: TextStyle(fontSize: 16)));
          }
        },
      ),
    ),
    ]
    );
  }
  Widget _profileInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Colors.blueAccent, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.blueGrey.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.blueGrey.shade600,
                    fontSize: 14,
                    letterSpacing: 0.3,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileInfoRowMultiline(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Colors.blueAccent, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.blueGrey.shade900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.blueGrey.shade600,
                    fontSize: 14,
                    letterSpacing: 0.3,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
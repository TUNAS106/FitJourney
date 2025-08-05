import 'package:flutter/material.dart';
import '../widget/choose_vip_package.dart';

class UpgradeVipPage extends StatelessWidget {
  const UpgradeVipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade700.withOpacity(0.7),
                    Colors.blue.shade400.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    const Text(
                      'Welcome, VIP Member!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Enjoy your exclusive benefits',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 200, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPerkCard(
              icon: Icons.play_circle_outline,
              title: 'Premium Training Videos',
              subtitle: 'Access exclusive workout content from top trainers',
              status: 'Unlimited',
              statusColor: Colors.green,
            ),
            _buildPerkCard(
              icon: Icons.chat,
              title: 'Chat with Personal Trainers',
              subtitle: 'Get personalized advice from certified professionals',
              status: '24/7 Available',
              statusColor: Colors.blue,
            ),
            _buildPerkCard(
              icon: Icons.smart_toy,
              title: 'Unlimited AI Assistance',
              subtitle: 'AI-powered fitness guidance and meal planning',
              status: 'Unlimited',
              statusColor: Colors.purple,
            ),
            _buildPerkCard(
              icon: Icons.star,
              title: 'Priority Support',
              subtitle: 'Get faster response times for all your queries',
              status: 'VIP Only',
              statusColor: Colors.orange,
            ),
            const SizedBox(height: 24),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF9C27B0), // tím
                      Color(0xFF673AB7), // tím đậm hơn
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text(
                    'Next Step: Choose VIP Package',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0, // elevation đã dùng ở BoxShadow bên ngoài
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const ChooseVipPackageSheet(),
                    );
                  },
                ),
              ),
            )
            ,
          ],
        ),
      ),
    );
  }

  Widget _buildPerkCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.grey.shade100,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getIconBackgroundColor(icon),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Color _getIconBackgroundColor(IconData icon) {
    if (icon == Icons.play_circle_outline) return Colors.red;
    if (icon == Icons.chat) return Colors.blue;
    if (icon == Icons.smart_toy) return Colors.purple;
    if (icon == Icons.star) return Colors.orange;
    return Colors.grey;
  }
}


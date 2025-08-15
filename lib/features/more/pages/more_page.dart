import 'dart:ui';
import 'package:flutter/material.dart';
import '../../profile/pages/profile_page.dart';
import '../../progress_tracking/pages/Body_Progress_Chart.dart';
import '../../progress_tracking/pages/body_metrics_form.dart';

class MoreScreen extends StatefulWidget {
  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final GlobalKey<BodyProgressChartState> _chartKey = GlobalKey();

  void _openForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BodyMetricsFormPage(
          onSubmitted: () {
            _chartKey.currentState?.refresh();
          },
          onProgressUpdated: () {
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    List<Color>? colors,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      color: Colors.white.withOpacity(0.85), // nền trong suốt nhẹ
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: colors ?? [Colors.blue, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/backMore.webp',
            fit: BoxFit.cover,
          ),
          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),
          // Main content
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildMenuItem(
                icon: Icons.person,
                title: 'Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProfilePage()),
                  );
                },
                colors: [Colors.purple, Colors.purpleAccent],
              ),
              _buildMenuItem(
                icon: Icons.more_horiz,
                title: 'More Screen',
                onTap: () {},
                colors: [Colors.teal, Colors.greenAccent],
              ),
              _buildMenuItem(
                icon: Icons.add,
                title: 'Add Body Metrics',
                onTap: _openForm,
                colors: [Colors.orange, Colors.deepOrangeAccent],
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 3,
                color: Colors.white.withOpacity(0.85),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BodyProgressChart(key: _chartKey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BodyMetricsFormPage extends StatelessWidget {
  final VoidCallback? onSubmitted;
  final VoidCallback onProgressUpdated;
  const BodyMetricsFormPage({Key? key, this.onSubmitted, required this.onProgressUpdated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onProgressUpdated();
        return true;
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/backMore.webp',
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: Colors.black.withOpacity(0.25)),
            ),
            Column(
              children: [
                AppBar(
                  title: const Text('Add Body Metrics'),
                  centerTitle: true,
                  backgroundColor: Colors.white.withOpacity(0.85),
                  elevation: 0,
                  foregroundColor: Colors.black87,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 3,
                      color: Colors.white.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: BodyMetricsForm(onSubmitted: onSubmitted),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

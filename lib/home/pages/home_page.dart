import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitjourney/features/social/pages/post_feed_screen.dart';
import 'package:flutter/material.dart';
import '../../features/AI_features/Ai_chat_screen.dart';
import '../../features/chat/widget/chat_tab_widget.dart';
import '../../features/more/pages/more_page.dart';
import '../../features/notebook/pages/notebook_page.dart';
import '../../features/progress_tracking/controller/body_metrics_controller.dart';
import '../../features/training_modes/page/home_pagetraining.dart';



class HomePage extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  int _currentIndex = 0;
  final BodyMetricsController _metricsController = BodyMetricsController(); // Thêm dòng này

  @override
  void initState() {
    super.initState();
    _checkBmiReminder();
  }
  Future<void> _checkBmiReminder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _metricsController.checkUserBmiReminder(user.uid, context);
    }
  }
  final List<Widget> _screens = [
    HomePageTraining(),
    PostFeedScreen(),
    ChatTabWidget(),
    NotebookScreen(),
    MoreScreen(),


  ];

  final List<String> _titles = [
    'Kế hoạch tập',
    'Feed',
    'Chat',
    'Sổ tay',
    'Thêm',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.redAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Tập',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Sổ tay',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Thêm',
          ),
        ],
      ),
    );
  }
}
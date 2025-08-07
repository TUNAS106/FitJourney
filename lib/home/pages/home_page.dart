import 'package:fitjourney/features/progress_tracking/pages/Body_Progress_page.dart';
import 'package:fitjourney/features/progress_tracking/pages/body_metrics_form.dart';
import 'package:fitjourney/features/social/pages/post_create_page.dart';
import 'package:fitjourney/features/social/pages/post_feed_screen.dart';
import 'package:flutter/material.dart';
//import '../../training/bloc/training_bloc.dart';
//import '../../training/bloc/training_event.dart';
import '../../features/chat/pages/chat_page.dart';
import '../../features/more/pages/more_page.dart';
import '../../features/notebook/pages/notebook_page.dart';
import '../../features/social/pages/feed_screen.dart';
import '../../features/training_modes/page/home_pagetraining.dart';
//import '../../training/pages/training_plan_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomePageTraining(),
    //FeedScreen(),
    //PostCreateScreen(),
    PostFeedScreen(),
    //BodyMetricsForm(),
    //BodyProgressScreen(),
    ChatScreen(),
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
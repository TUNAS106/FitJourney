import 'package:flutter/material.dart';
import '../../profile/pages/profile_page.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profile'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfilePage()),
            );
          },
        ),
        // Add more options here if needed
        ListTile(
          leading: Icon(Icons.more_horiz),
          title: Text('More Screen'),
        ),
      ],
    );
  }
}
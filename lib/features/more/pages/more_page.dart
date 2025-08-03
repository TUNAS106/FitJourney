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
            Navigator.pop(context);
            _chartKey.currentState?.refresh();
          },
        ),
      ),
    );
  }

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
        ListTile(
          leading: Icon(Icons.more_horiz),
          title: Text('More Screen'),
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Add Body Metrics'),
          onTap: _openForm,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BodyProgressChart(key: _chartKey),
        ),
      ],
    );
  }
}

class BodyMetricsFormPage extends StatelessWidget {
  final VoidCallback? onSubmitted;
  const BodyMetricsFormPage({Key? key, this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Body Metrics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BodyMetricsForm(onSubmitted: onSubmitted),
      ),
    );
  }
}
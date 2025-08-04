// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../data/models/body_metric.dart';
// import '../controller/body_metrics_controller.dart';
// import 'Body_Progress_Chart.dart';
//
// class BodyProgressScreen extends StatelessWidget {
//   final BodyMetricsController _controller = BodyMetricsController();
//
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       return Center(child: Text("User not logged in"));
//     }
//     final userId = user.uid;
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Weight Progress')),
//       body: FutureBuilder<List<BodyMetrics>>(
//         future: _controller.fetchBodyMetrics(userId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting)
//             return Center(child: CircularProgressIndicator());
//           if (!snapshot.hasData || snapshot.data!.isEmpty)
//             return Center(child: Text("No data"));
//
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: BodyProgressChart(entries: snapshot.data!),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/body_metric.dart';


class BodyMetricsController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void submitMetrics({
    required BuildContext context,
    required double weight,
    required double height,
    required int age,
  }) async {
    try {
      final bmi = _calculateBMI(weight, height);
      final metrics = BodyMetrics(
        weight: weight,
        height: height,
        age: age,
        bmi: bmi,
        timestamp: DateTime.now(),
      );

      final user = _auth.currentUser;
      if (user == null) {
        _showErrorDialog(context, "Bạn chưa đăng nhập.");
        return;
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('body_metrics')
          .add(metrics.toMap());

      _showBMIDialog(context, bmi);
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  double _calculateBMI(double weight, double heightCm) {
    final heightM = heightCm / 100;
    return weight / (heightM * heightM);
  }

  void _showBMIDialog(BuildContext context, double bmi) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("BMI Result"),
        content: Text("Your BMI is ${bmi.toStringAsFixed(2)}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Lỗi"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Đóng"),
          ),
        ],
      ),
    );
  }
  Future<List<BodyMetrics>> fetchBodyMetrics(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('body_metrics')
        .orderBy('timestamp')
        .get();

    final metrics = snapshot.docs
        .map((doc) => BodyMetrics.fromFirestore(doc.data()))
        .toList();

    return metrics;
  }
}

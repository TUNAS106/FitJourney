import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/plan_models.dart';
class FirebaseUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách activePlans từ document user
  Future<List<WorkoutPlanProgress>> fetchUserProgress(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (!doc.exists) return [];

      final data = doc.data()!;
      final activePlans = data['activePlans'] as List<dynamic>? ?? [];

      return activePlans.map((item) => WorkoutPlanProgress(
        planId: item['planId'] ?? 0,
        currentDay: item['currentDay'] ?? 1,
        currentExercise: item['currentExercise'] ?? 0,
      )).toList();
    } catch (e) {
      print('Error fetching user progress: $e');
      rethrow;
    }
  }

  // Thêm/cập nhật activePlans
  Future<void> addUserProgress(String userId, WorkoutPlanProgress progress) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);

      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(userRef);

        // Lấy danh sách activePlans hiện tại hoặc tạo mới
        final currentPlans = doc.exists
            ? (doc.data()?['activePlans'] as List<dynamic>? ?? [])
            : [];

        // Kiểm tra nếu plan đã tồn tại
        final index = currentPlans.indexWhere(
                (p) => p['planId'] == progress.planId);

        // Tạo bản ghi mới
        final newPlan = {
          'planId': progress.planId,
          'currentDay': progress.currentDay,
          'currentExercise': progress.currentExercise,
        };

        // Cập nhật hoặc thêm mới
        if (index >= 0) {
          currentPlans[index] = newPlan;
        } else {
          currentPlans.add(newPlan);
        }

        // Cập nhật Firestore
        transaction.update(userRef, {
          'activePlans': currentPlans,
          'id': userId, // Đảm bảo có trường id
        });
      });
    } catch (e) {
      print('Error updating user progress: $e');
      rethrow;
    }
  }
  Future<void> removeUserProgress(String userId, int planId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);

      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(userRef);
        final currentPlans = doc.exists
            ? (doc.data()?['activePlans'] as List<dynamic>? ?? [])
            : [];

        // Xóa phần tử có planId tương ứng
        currentPlans.removeWhere((plan) => plan['planId'] == planId);

        transaction.update(userRef, {'activePlans': currentPlans});
      });
    } catch (e) {
      print('Error removing user progress: $e');
      rethrow;
    }
  }
  Future<void> updateUserProgress(String userId, WorkoutPlanProgress progress) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);

      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(userRef);
        final currentPlans = doc.exists
            ? (doc.data()?['activePlans'] as List<dynamic>? ?? [])
            : [];

        final index = currentPlans.indexWhere((p) => p['planId'] == progress.planId);

        if (index >= 0) {
          currentPlans[index] = {
            'planId': progress.planId,
            'currentDay': progress.currentDay,
            'currentExercise': progress.currentExercise,
          };
        }

        transaction.update(userRef, {'activePlans': currentPlans});
      });
    } catch (e) {
      print('Error updating workout process: $e');
      rethrow;
    }
  }

  Future isVip(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        return data?['isVip'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error checking VIP status: $e');
      return false;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout_plan_model.dart';


class WorkoutPlanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<WorkoutPlanModel>> fetchWorkoutPlans() async {
    final snapshot = await _firestore.collection('workout_plans').get();
    //print(snapshot.docs.map((doc) => doc.data()));
    return snapshot.docs.map((doc) => WorkoutPlanModel.fromFirestore(doc)).toList();
  }
}

import 'package:sqflite/sqflite.dart';
import '../models/plan_models.dart';
import 'db_helper.dart';

class WorkoutPlanRepository {
  final WorkoutDBHelper _dbHelper = WorkoutDBHelper();


  // Lấy toàn bộ kế hoạch tập luyện
  Future<List<WorkoutPlan>> getAllPlans() async {
    final db = await _dbHelper.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM workout_plan'));
    //print(count == 0 ? 'No data in workout_plan' : 'Data exists: $count rows');


    final List<Map<String, dynamic>> maps = await db.query('workout_plan');
    //print('Plans: $maps');
    return List.generate(maps.length, (i) {
      return WorkoutPlan.fromMap(maps[i]);
    });
  }

  // Lấy danh sách ngày tập của 1 kế hoạch cụ thể
  Future<List<WorkoutDay>> getDaysForPlan(int planId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workout_day',
      where: 'plan_id = ?',
      whereArgs: [planId],
    );

    return List.generate(maps.length, (i) {
      return WorkoutDay.fromMap(maps[i]);
    });
  }

  // Lấy danh sách bài tập của 1 ngày cụ thể
  Future<List<Exercise>> getExercisesForDay(int dayId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercise',
      where: 'day_id = ?',
      whereArgs: [dayId],
    );

    return List.generate(maps.length, (i) {
      return Exercise.fromMap(maps[i]);
    });
  }
  Future<int> getDayCountForPlan(int planId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM workout_day WHERE plan_id = ?',
      [planId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }


}

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fitjourney/features/notebook/data/exercises_data/exercises_model.dart';

class ExerciseDB {
  ExerciseDB._();
  static final ExerciseDB instance = ExerciseDB._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "ExerciseDB.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Exercise(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        duration INTEGER,
        category TEXT,
        difficulty TEXT,
        equipment TEXT,
        muscles TEXT,
        caloriesBurned TEXT,
        imageUrl TEXT
        sets INTEGER,
        timePerSet INTEGER
      )
    ''');
  }

  // CRUD
  Future<int> insertExercise(Exercise e) async {
    final db = await database;
    return await db.insert('Exercise', e.toMap());
  }

  Future<List<Exercise>> getAllExercises() async {
    final db = await database;
    final res = await db.query('Exercise');
    return res.map((e) => Exercise.fromMap(e)).toList();
  }

  Future<int> updateExercise(Exercise e) async {
    final db = await database;
    return await db.update('Exercise', e.toMap(), where: 'id = ?', whereArgs: [e.id]);
  }

  Future<int> deleteExercise(int id) async {
    final db = await database;
    return await db.delete('Exercise', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}

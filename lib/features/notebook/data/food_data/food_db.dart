import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'food_model.dart';


class FoodDB {
  FoodDB._();
  static final FoodDB instance = FoodDB._();


  static Database? _database;


  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }


  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "FoodDB.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }


  Future _onCreate(Database db, int version) async {
    await db.execute('''
     CREATE TABLE Food (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       name TEXT,
       description TEXT,
       calories REAL,
       protein REAL,
       fat REAL,
       carbs REAL,
       imageUrl TEXT,
       category TEXT,
       nutritionInfo TEXT,
       servingSize TEXT
     )
   ''');
  }


  // CRUD
  Future<int> insertFood(Food food) async {
    final db = await database;
    return await db.insert('Food', food.toMap());
  }


  Future<List<Food>> getAllFoods() async {
    final db = await database;
    final res = await db.query('Food');
    return res.map((e) => Food.fromMap(e)).toList();
  }


  Future<int> updateFood(Food food) async {
    final db = await database;
    return await db.update('Food', food.toMap(), where: 'id = ?', whereArgs: [food.id]);
  }


  Future<int> deleteFood(int id) async {
    final db = await database;
    return await db.delete('Food', where: 'id = ?', whereArgs: [id]);
  }
}

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'whey_model.dart';

class WheyDB {
  WheyDB._();
  static final WheyDB instance = WheyDB._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "WheyDB.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Whey(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        flavor TEXT,
        weight REAL,
        protein REAL,
        price REAL,
        note TEXT
      )
    ''');
  }

  // CRUD
  Future<int> insertWhey(Whey w) async {
    final db = await database;
    return await db.insert('Whey', w.toMap());
  }

  Future<List<Whey>> getAllWhey() async {
    final db = await database;
    final res = await db.query('Whey');
    return res.map((e) => Whey.fromMap(e)).toList();
  }

  Future<int> updateWhey(Whey w) async {
    final db = await database;
    return await db.update('Whey', w.toMap(), where: 'id = ?', whereArgs: [w.id]);
  }

  Future<int> deleteWhey(int id) async {
    final db = await database;
    return await db.delete('Whey', where: 'id = ?', whereArgs: [id]);
  }
}

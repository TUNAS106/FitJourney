import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'encyclopedia_model.dart';

class EncyclopediaDB {
  EncyclopediaDB._();
  static final EncyclopediaDB instance = EncyclopediaDB._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "EncyclopediaDB.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Encyclopedia (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        category TEXT,
        content TEXT,
        tags TEXT,
        imageUrl TEXT
      )
    ''');
  }

  Future<int> insertEntry(Encyclopedia entry) async {
    final db = await database;
    return await db.insert('Encyclopedia', entry.toMap());
  }

  Future<List<Encyclopedia>> getAllEntries() async {
    final db = await database;
    final res = await db.query('Encyclopedia');
    return res.map((e) => Encyclopedia.fromMap(e)).toList();
  }

  Future<int> updateEntry(Encyclopedia entry) async {
    final db = await database;
    return await db.update('Encyclopedia', entry.toMap(), where: 'id = ?', whereArgs: [entry.id]);
  }

  Future<int> deleteEntry(int id) async {
    final db = await database;
    return await db.delete('Encyclopedia', where: 'id = ?', whereArgs: [id]);
  }
}
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'pharmacy_model.dart';


class PharmacyDB {
  PharmacyDB._();
  static final PharmacyDB instance = PharmacyDB._();


  static Database? _database;


  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }


  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "PharmacyDB.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }


  Future _onCreate(Database db, int version) async {
    await db.execute('''
     CREATE TABLE Pharmacy(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       name TEXT,
       type TEXT,
       quantity INTEGER,
       price REAL,
       usage TEXT,
       note TEXT,
       brand TEXT,
       origin TEXT,
       ingredient TEXT,
       effect TEXT,
       sideEffects TEXT,
       storage TEXT,
       expiryDate TEXT,
       imageUrl TEXT
     )
   ''');
  }


  // --- CRUD ---
  Future<int> insertPharmacy(Pharmacy p) async {
    final db = await database;
    return await db.insert('Pharmacy', p.toMap());
  }


  Future<List<Pharmacy>> getAllPharmacy() async {
    final db = await database;
    final res = await db.query('Pharmacy');
    return res.map((e) => Pharmacy.fromMap(e)).toList();
  }


  Future<int> updatePharmacy(Pharmacy p) async {
    final db = await database;
    return await db.update('Pharmacy', p.toMap(), where: 'id = ?', whereArgs: [p.id]);
  }


  Future<int> deletePharmacy(int id) async {
    final db = await database;
    return await db.delete('Pharmacy', where: 'id = ?', whereArgs: [id]);
  }
}

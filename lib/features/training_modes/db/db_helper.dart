import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutDBHelper {
  static final WorkoutDBHelper _instance = WorkoutDBHelper._internal();
  static Database? _database;

  factory WorkoutDBHelper() {
    return _instance;
  }

  WorkoutDBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fitjourney.db');

    //await deleteDatabase(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workout_plan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        gender TEXT,
        location TEXT,
        type TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE workout_day (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plan_id INTEGER,
        day INTEGER,
        FOREIGN KEY (plan_id) REFERENCES workout_plan(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE exercise (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        day_id INTEGER,
        name TEXT,
        sets INTEGER,
        reps INTEGER,
        duration INTEGER,
        videoUrl TEXT,
        description TEXT,
        note TEXT,
        step TEXT,
        imageUrl TEXT,
        FOREIGN KEY (day_id) REFERENCES workout_day(id)
      );
    ''');
    insertSampleData();
  }
  Future<void> insertSampleData() async {
    final db = await database;
    // Thêm kế hoạch tập luyện
    await db.insert('workout_plan', {
      'title': 'Tăng cơ tại nhà cho nam',
      'description': 'Chương trình tập luyện tại nhà giúp nam giới phát triển cơ bắp.',
      'gender': 'male',
      'location': 'home',
      'type': 'muscle_gain',
    });

    await db.insert('workout_plan', {
      'title': 'Giảm mỡ tại phòng gym cho nam',
      'description': 'Bài tập đốt mỡ toàn thân cho nam giới tại phòng gym.',
      'gender': 'male',
      'location': 'gym',
      'type': 'fat_loss',
    });

    await db.insert('workout_plan', {
      'title': 'Đốt mỡ tại nhà cho nữ',
      'description': 'Bài tập đơn giản giúp nữ giới giảm cân hiệu quả tại nhà.',
      'gender': 'female',
      'location': 'home',
      'type': 'fat_loss',
    });

    await db.insert('workout_plan', {
      'title': 'Săn chắc cơ thể tại phòng gym cho nữ',
      'description': 'Chương trình tập gym giúp nữ giới săn chắc vóc dáng và khỏe mạnh.',
      'gender': 'female',
      'location': 'gym',
      'type': 'tone_up',
    });

    // Thêm các ngày tập cho kế hoạch này
    await db.insert('workout_day', {
      'plan_id': 1,
      'day': 1,
    });
    await db.insert('workout_day', {
      'plan_id': 1,
      'day': 2,
    });
    await db.insert('workout_day', {
      'plan_id': 1,
      'day': 3,
    });
    await db.insert('workout_day', {
      'plan_id': 1,
      'day': 4,
    });
    await db.insert('workout_day', {
      'plan_id': 1,
      'day': 5,
    });
    await db.insert('workout_day', {
      'plan_id': 1,
      'day': 6,
    });
    await db.insert('workout_day', {
      'plan_id': 1,
      'day': 7,
    });
    await db.insert('workout_day', {
      'plan_id': 1,
      'day': 8,
    });
    await db.insert('workout_day', {
      'plan_id': 1,
      'day': 9,
    });
    await db.insert('workout_day', {
      'plan_id': 1,
      'day': 10,
    });
    await db.insert('workout_day', {
      'plan_id': 1,
      'day': 11,
    });
    await db.insert('workout_day', {
      'plan_id': 1,
      'day': 12,
    });
    await db.insert('workout_day', {
      'plan_id': 1,
      'day': 13,
    });
    await db.insert('workout_day', {
      'plan_id': 1,
      'day': 14,
    });
    await db.insert('workout_day', {
      'plan_id': 1,
      'day': 15,
    });



    await db.insert('workout_day', {
      'plan_id': 2,
      'day': 1,
    });
    await db.insert('workout_day', {
      'plan_id': 2,
      'day': 2,
    });
    await db.insert('workout_day', {
      'plan_id': 2,
      'day': 3,
    });
    await db.insert('workout_day', {
      'plan_id': 2,
      'day': 4,
    });
    await db.insert('workout_day', {
      'plan_id': 2,
      'day': 5,
    });
    await db.insert('workout_day', {
      'plan_id': 2,
      'day': 6,
    });
    await db.insert('workout_day', {
      'plan_id': 2,
      'day': 7,
    });
    await db.insert('workout_day', {
      'plan_id': 2,
      'day': 8,
    });
    await db.insert('workout_day', {
      'plan_id': 2,
      'day': 9,
    });
    await db.insert('workout_day', {
      'plan_id': 2,
      'day': 10,
    });
    await db.insert('workout_day', {
      'plan_id': 2,
      'day': 11,
    });
    await db.insert('workout_day', {
      'plan_id': 2,
      'day': 12,
    });
    await db.insert('workout_day', {
      'plan_id': 2,
      'day': 13,
    });
    await db.insert('workout_day', {
      'plan_id': 2,
      'day': 14,
    });
    await db.insert('workout_day', {
      'plan_id': 2,
      'day': 15,
    });


    await db.insert('workout_day', {
      'plan_id': 3,
      'day': 1,
    });
    await db.insert('workout_day', {
      'plan_id': 3,
      'day': 2,
    });
    await db.insert('workout_day', {
      'plan_id': 3,
      'day': 3,
    });
    await db.insert('workout_day', {
      'plan_id': 3,
      'day': 4,
    });
    await db.insert('workout_day', {
      'plan_id': 3,
      'day': 5,
    });
    await db.insert('workout_day', {
      'plan_id': 3,
      'day': 6,
    });
    await db.insert('workout_day', {
      'plan_id': 3,
      'day': 7,
    });
    await db.insert('workout_day', {
      'plan_id': 3,
      'day': 8,
    });
    await db.insert('workout_day', {
      'plan_id': 3,
      'day': 9,
    });
    await db.insert('workout_day', {
      'plan_id': 3,
      'day': 10,
    });
    await db.insert('workout_day', {
      'plan_id': 3,
      'day': 11,
    });
    await db.insert('workout_day', {
      'plan_id': 3,
      'day': 12,
    });
    await db.insert('workout_day', {
      'plan_id': 3,
      'day': 13,
    });
    await db.insert('workout_day', {
      'plan_id': 3,
      'day': 14,
    });
    await db.insert('workout_day', {
      'plan_id': 3,
      'day': 15,
    });


    await db.insert('workout_day', {
      'plan_id': 4,
      'day': 1,
    });
    await db.insert('workout_day', {
      'plan_id': 4,
      'day': 2,
    });
    await db.insert('workout_day', {
      'plan_id': 4,
      'day': 3,
    });
    await db.insert('workout_day', {
      'plan_id': 4,
      'day': 4,
    });
    await db.insert('workout_day', {
      'plan_id': 4,
      'day': 5,
    });
    await db.insert('workout_day', {
      'plan_id': 4,
      'day': 6,
    });
    await db.insert('workout_day', {
      'plan_id': 4,
      'day': 7,
    });
    await db.insert('workout_day', {
      'plan_id': 4,
      'day': 8,
    });
    await db.insert('workout_day', {
      'plan_id': 4,
      'day': 9,
    });
    await db.insert('workout_day', {
      'plan_id': 4,
      'day': 10,
    });
    await db.insert('workout_day', {
      'plan_id': 4,
      'day': 11,
    });
    await db.insert('workout_day', {
      'plan_id': 4,
      'day': 12,
    });
    await db.insert('workout_day', {
      'plan_id': 4,
      'day': 13,
    });
    await db.insert('workout_day', {
      'plan_id': 4,
      'day': 14,
    });
    await db.insert('workout_day', {
      'plan_id': 4,
      'day': 15,
    });


    await db.insert('exercise', {
      'day_id': 1,
      'name': 'Diamond Push-up',
      'sets': 3,
      'reps': 15,
      'duration': 15,
      'videoUrl': 'assets/training/videos/Squat.mp4',
      'description': 'Chống đẩy kim cương là một biến thể của chống đẩy cơ bản, tập trung nhiều hơn vào cơ ngực trong, cơ tam đầu (triceps) và một phần vai trước. Động tác này đòi hỏi sự ổn định cao từ cơ bụng, lưng dưới, và đùi sau, đồng thời giúp phát triển sức mạnh thân trên toàn diện.',
      'note': 'Giữ cơ thể thẳng trong suốt bài tập, không võng lưng hoặc đẩy mông lên cao.Nếu quá khó, bạn có thể chống gối xuống đất để giảm độ nặng.Không hạ ngực quá sâu gây áp lực lên khớp vai.Kiểm soát chuyển động, không để cơ thể rơi tự do.',
      'step': 'Vào tư thế chuẩn bị|Hạ người xuống|Dùng lực đẩy mạnh từ tay và ngực, đưa thân người trở về vị trí ban đầu|Thở ra khi bạn đẩy người lên.',
      'imageUrl': "assets/training/images/phototo.jpg",
    });
    await db.insert('exercise', {
      'day_id': 1,
      'name': 'Push Ups11',
      'sets': 3,
      'reps': 15,
      'duration': 15,
      'videoUrl': 'assets/training/videos/Squat.mp4',
      'description': '11Do standard pushups Do standard pushups  Do standard pushups  Do standard pushups  Do standard pushups  Do standard pushups  Do standard pushups  Do standard pushups  Do standard pushups ',
      'note': '11Avoid arching your back  Do standard pushups  Do standard pushups Do standard pushups',
      'step': '11Get down  Do standard pushups|Lower body  Do standard pushups  |Push up  Do standard pushups',
      'imageUrl': "assets/training/images/phototo.jpg",
    });
    await db.insert('exercise', {
      'day_id': 1,
      'name': 'Push Ups22',
      'sets': 3,
      'reps': 15,
      'duration': 15,
      'videoUrl': 'assets/training/videos/Squat.mp4',
      'description': '22Do standard pushups Do standard pushups  Do standard pushups  Do standard pushups  Do standard pushups  Do standard pushups  Do standard pushups  Do standard pushups  Do standard pushups ',
      'note': '22Avoid arching your back  Do standard pushups  Do standard pushups Do standard pushups',
      'step': '22Get down  Do standard pushups|Lower body  Do standard pushups  |Push up  Do standard pushups',
      'imageUrl': "assets/training/images/phototo.jpg",
    });
    await db.insert('exercise', {
      'day_id': 1,
      'name': 'Push Ups33',
      'sets': 3,
      'reps': 15,
      'duration': 15,
      'videoUrl': 'assets/training/videos/Squat.mp4',
      'description': '33Do standard pushups Do standard pushups  Do standard pushups  Do standard pushups  Do standard pushups  Do standard pushups  Do standard pushups  Do standard pushups  Do standard pushups ',
      'note': '33Avoid arching your back  Do standard pushups  Do standard pushups Do standard pushups',
      'step': '33Get down  Do standard pushups|Lower body  Do standard pushups  |Push up  Do standard pushups',
      'imageUrl': "assets/training/images/phototo.jpg",
    });

    await db.insert('exercise', {
      'day_id': 2,
      'name': 'Squats',
      'sets': 3,
      'reps': 20,
      'duration': 0,
      'videoUrl': 'http://example.com/squats',
      'description': 'Do bodyweight squats',
      'note': 'Keep knees aligned',
      'step': 'Stand tall|Lower hips|Rise back',
      'imageUrl': 'http://example.com/squats.jpg',
    });
    await db.insert('exercise', {
      'day_id': 3,
      'name': 'Squats',
      'sets': 3,
      'reps': 20,
      'duration': 0,
      'videoUrl': 'http://example.com/squats',
      'description': 'Do bodyweight squats',
      'note': 'Keep knees aligned',
      'step': 'Stand tall|Lower hips|Rise back',
      'imageUrl': 'http://example.com/squats.jpg',
    });
    await db.insert('exercise', {
      'day_id': 4,
      'name': 'Squats',
      'sets': 3,
      'reps': 20,
      'duration': 0,
      'videoUrl': 'http://example.com/squats',
      'description': 'Do bodyweight squats',
      'note': 'Keep knees aligned',
      'step': 'Stand tall|Lower hips|Rise back',
      'imageUrl': 'http://example.com/squats.jpg',
    });

    await db.insert('exercise', {
      'day_id': 5,
      'name': 'Squats',
      'sets': 3,
      'reps': 20,
      'duration': 0,
      'videoUrl': 'http://example.com/squats',
      'description': 'Do bodyweight squats',
      'note': 'Keep knees aligned',
      'step': 'Stand tall|Lower hips|Rise back',
      'imageUrl': 'http://example.com/squats.jpg',
    });    await db.insert('exercise', {
      'day_id': 6,
      'name': 'Squats',
      'sets': 3,
      'reps': 20,
      'duration': 0,
      'videoUrl': 'http://example.com/squats',
      'description': 'Do bodyweight squats',
      'note': 'Keep knees aligned',
      'step': 'Stand tall|Lower hips|Rise back',
      'imageUrl': 'http://example.com/squats.jpg',
    });

  }
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('exercise');
    await db.delete('workout_day');
    await db.delete('workout_plan');
  }
  Future<void> printAllPlans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('workout_plan');

    for (var map in maps) {
      print('Plan: ${map['title']}, Description: ${map['description']}');
    }
  }
  Future<void> printAllWorkoutDays() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('workout_day');

    for (var map in maps) {
      print('Day: ${map['day']}, Plan ID: ${map['plan_id']}');
    }
  }
  Future<void> printAllExercises() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('exercise');
    for (var map in maps) {
      print(
          'Exercise: ${map['name']}, Sets: ${map['sets']}, Reps: ${map['reps']}');
    }
  }

}

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
        videoVip TEXT,
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
    // Thêm các ngày tập
    for (int i = 1; i <= 15; i++) {
      await db.insert('workout_day', {
        'plan_id': 1,
        'day': i,
      });
    }

    // Thêm các ngày tập
    for (int i = 1; i <= 15; i++) {
      await db.insert('workout_day', {
        'plan_id': 2,
        'day': i,
      });
    }
    for (int i = 1; i <= 15; i++) {
      await db.insert('workout_day', {
        'plan_id': 3,
        'day': i,
      });
    }

    // Thêm các ngày tập
    for (int i = 1; i <= 15; i++) {
      await db.insert('workout_day', {
        'plan_id': 4,
        'day': i,
      });
    }

    for(int i = 0; i <= 3; i++ ){

      await db.insert('exercise', {
        'day_id': 15*i+ 1,
        'name': 'Dãn cơ',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Danco.mp4',
        'videoVip': 'assets/training/videos/Dancovip.mp4',
        'description': 'Dãn cơ là động tác giãn cơ vai đơn giản, thực hiện bằng cách kéo cánh tay ngang qua ngực để kéo giãn cơ vai sau và cơ xung quanh khớp vai, giúp tăng độ linh hoạt và giảm căng cứng.',
        'note': 'Không nâng vai lên khi kéo giãn. Kéo nhẹ nhàng, tránh giật mạnh để không gây chấn thương. Duy trì hơi thở ổn định trong suốt thời gian giữ tư thế.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, hai chân rộng bằng vai, thả lỏng vai và lưng.|Giãn cơ: Đưa một tay ngang qua ngực, tay còn lại giữ và kéo nhẹ cánh tay đó sát vào ngực để cảm nhận căng ở vai. |  Giữ tư thế: Giữ vị trí kéo giãn 15–30 giây, thở đều, sau đó đổi bên.',
        'imageUrl': "assets/training/images/Danco.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 1,
        'name': 'Diamond Push-up',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Hitdat.mp4',
        'videoVip': 'assets/training/videos/Ngucvip.mp4',
        'description': 'Chống đẩy kim cương là một biến thể của chống đẩy cơ bản, tập trung nhiều hơn vào cơ ngực trong, cơ tam đầu (triceps) và một phần vai trước. Động tác này đòi hỏi sự ổn định cao từ cơ bụng, lưng dưới, và đùi sau, đồng thời giúp phát triển sức mạnh thân trên toàn diện.',
        'note': 'Giữ cơ thể thẳng trong suốt bài tập, không võng lưng hoặc đẩy mông lên cao.Nếu quá khó, bạn có thể chống gối xuống đất để giảm độ nặng.Không hạ ngực quá sâu gây áp lực lên khớp vai.Kiểm soát chuyển động, không để cơ thể rơi tự do.',
        'step': 'Vào tư thế chuẩn bị|Hạ người xuống|Dùng lực đẩy mạnh từ tay và ngực, đưa thân người trở về vị trí ban đầu|Thở ra khi bạn đẩy người lên.',
        'imageUrl': "assets/training/images/Nguc.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 1,
        'name': 'Incline Dumbbell Press',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Nguc1.mp4',
        'videoVip': 'assets/training/videos/Ngucvip.mp4',
        'description': 'Incline Dumbbell Press là bài tập đẩy ngực trên với tạ đơn, giúp phát triển nhóm cơ ngực trên, cơ vai trước và cơ tay sau. So với dùng thanh đòn, tạ đơn cho biên độ chuyển động rộng hơn, tăng khả năng co giãn cơ và cải thiện sự cân đối giữa hai bên cơ thể. Bài tập này phù hợp cho người muốn xây dựng sức mạnh phần thân trên và cải thiện hình dáng ngực.',
        'note': 'Giữ lưng áp sát ghế, không vung tạ, chọn mức tạ phù hợp để kiểm soát tốt cả khi đẩy và hạ, tránh cong lưng hoặc gồng cổ quá mức.',
        'step': 'Tư thế chuẩn bị: Điều chỉnh ghế nghiêng 30–45°, mỗi tay cầm 1 quả tạ đơn, ngả lưng áp sát ghế, tạ ở ngang ngực, lòng bàn tay hướng ra trước.| Hạ tạ: Hít sâu, từ từ hạ tạ xuống cho đến khi khuỷu tay thấp hơn ngực một chút, giữ góc khuỷu tay ổn định và chuyển động có kiểm soát.|Đẩy tạ: Thở ra, đẩy tạ thẳng lên cho đến khi gần chạm nhau, không khóa khớp khuỷu, siết cơ ngực ở đỉnh động tác.',
        'imageUrl': "assets/training/images/Nguc.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 1,
        'name': 'Barbell Bench Press',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Nguc2.mp4',
        'videoVip': 'assets/training/videos/Ngucvip.mp4',
        'description': 'Barbell Bench Press là bài tập đẩy tạ đòn trên ghế phẳng nhằm phát triển sức mạnh và kích thước cơ ngực, đồng thời tác động đến cơ vai trước và cơ tay sau, là một trong những bài tập sức mạnh cơ bản và phổ biến nhất trong tập luyện thể hình.',
        'note': ' Không cong lưng dưới quá mức, không để thanh tạ bật nảy trên ngực, giữ cổ tay thẳng và chắc chắn, kiểm soát tốc độ tạ cả khi đẩy và hạ để tránh chấn thương vai và cổ tay.',
        'step': 'Tư thế chuẩn bị: Nằm ngửa trên ghế phẳng, hai chân đặt vững trên sàn, mắt ở vị trí ngay dưới thanh đòn, tay nắm thanh tạ rộng hơn vai một chút, giữ bả vai ép chặt và lưng áp sát ghế.|Hít sâu, từ từ hạ thanh tạ xuống chạm nhẹ phần giữa ngực, khuỷu tay tạo góc khoảng 45 độ so với thân người, giữ kiểm soát toàn bộ chuyển động.|Đẩy tạ: Thở ra và đẩy thanh tạ thẳng lên cho đến khi tay gần duỗi hết nhưng không khóa khớp, giữ cơ ngực siết chặt ở đỉnh động tác.',
        'imageUrl': "assets/training/images/Nguc.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 1,
        'name': 'Dumbbell Floor Press',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Ngucduoi.mp4',
        'videoVip': 'assets/training/videos/Ngucvip.mp4',
        'description': 'Dumbbell Floor Press là bài đẩy tạ đơn trên sàn giúp phát triển cơ ngực, cơ tay sau và cơ vai trước, đồng thời giảm áp lực lên vai so với bench press, phù hợp cho người tập tại nhà hoặc phục hồi chấn thương vai.',
        'note': 'Giữ cổ tay thẳng, không để tạ rơi tự do, kiểm soát tốc độ cả khi đẩy và hạ, không ưỡn lưng quá mức, chọn mức tạ phù hợp để tránh chấn thương vai.',
        'step': 'Tư thế chuẩn bị: Nằm ngửa trên sàn, gối co, bàn chân đặt vững, mỗi tay cầm một tạ đơn, cánh tay vuông góc với thân, tạ ở ngang ngực, lòng bàn tay hướng ra trước.|Hạ tạ: Hít sâu, từ từ hạ tạ xuống cho đến khi khuỷu tay chạm nhẹ sàn, giữ góc khuỷu tay khoảng 45° so với thân.|Đẩy tạ: Thở ra, đẩy tạ thẳng lên cho đến khi tay gần duỗi hết nhưng không khóa khớp, siết cơ ngực ở đỉnh động tác.',
        'imageUrl': "assets/training/images/Nguc.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 1,
        'name': 'Seated Chest Fly',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Epnguc.mp4',
        'videoVip': 'assets/training/videos/Ngucvip.mp4',
        'description': 'Seated Chest Fly trên máy là bài tập cô lập ngực giữa cực hiệu quả, giúp phát triển chiều rộng và độ nét cơ ngực, đồng thời giảm áp lực lên vai nhờ chuyển động dẫn hướng.',
        'note': 'Không duỗi thẳng khuỷu, không ngả người về trước sau, không dùng lực quán tính, giữ chậm – siết mạnh khi hai tay gần chạm.',
        'step': ' Tư thế chuẩn bị: Ngồi tựa lưng chắc chắn, điều chỉnh tay cầm ngang ngực, hai tay nắm chắc tay đòn, khuỷu hơi cong.| Ép tay vào giữa: Thở ra, dùng lực cơ ngực kéo hai tay lại gần nhau trước ngực, giữ khuỷu tay cố định.| Trở về vị trí ban đầu: Hít vào, từ từ mở tay về vị trí ban đầu, cảm nhận cơ ngực giãn nhẹ.',
        'imageUrl': "assets/training/images/Nguc.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 1,
        'name': 'Rope Overhead Triceps Extension',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Taysau1.mp4',
        'videoVip': 'assets/training/videos/Taysauvip.mp4',
        'description': 'Rope Overhead Triceps Extension là bài tập tay sau sử dụng dây cáp, thực hiện ở tư thế đứng và kéo dây từ phía trên đầu ra trước, giúp phát triển cơ tam đầu tay sau và tăng sức mạnh cánh tay.',
        'note': ': Giữ cổ tay thẳng, không để tạ rơi tự do, kiểm soát tốc độ cả khi đẩy và hạ, không ưỡn lưng quá mức, chọn mức tạ phù hợp để tránh chấn thương vai.',
        'step': 'Tư thế chuẩn bị: Gắn dây rope vào ròng rọc cao, đứng quay lưng về máy, hai tay nắm hai đầu dây, bước một chân lên trước để giữ thăng bằng, tay gập ở góc 90° trước trán, cùi chỏ hướng về trước.| Duỗi tay: Thở ra, dùng lực cơ tay sau đẩy dây về phía trước và xuống dưới cho đến khi tay duỗi thẳng, cảm nhận sự co của cơ tam đầu.|Quay lại vị trí ban đầu: Hít vào, từ từ gập tay lại, đưa dây trở về vị trí ban đầu, kiểm soát toàn bộ chuyển động.',
        'imageUrl': "assets/training/images/Tay.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 1,
        'name': 'One-Arm Dumbbell Overhead Triceps Extension',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Taysau2.mp4',
        'videoVip': 'assets/training/videos/Taysauvip.mp4',
        'description': 'One-Arm Dumbbell Overhead Triceps Extension là bài tập tay sau sử dụng tạ đơn, thực hiện một tay, giúp cô lập và phát triển cơ tam đầu, đồng thời cải thiện sức mạnh và độ linh hoạt của khớp vai.',
        'note': 'Không vung tạ hoặc dùng lực quán tính.Giữ lưng thẳng, core siết chặt để tránh nghiêng người.Chọn mức tạ vừa phải để đảm bảo form chuẩn và tránh chấn thương vai hoặc khuỷu tay.',
        'step': 'Tư thế chuẩn bị: Đứng thẳng, chân rộng bằng vai, một tay cầm tạ đưa lên cao, cùi chỏ hướng lên, tay còn lại chống hông hoặc giữ cùi chỏ.|  Hạ tạ: Hít vào, gập cùi chỏ hạ tạ xuống sau đầu, giữ cánh tay trên cố định.| Duỗi tay: Thở ra, duỗi thẳng tay đưa tạ về vị trí ban đầu và lặp lại.',
        'imageUrl': "assets/training/images/Tay.png",
      });


      //Day2
      await db.insert('exercise', {
        'day_id': 15*i+ 2,
        'name': 'Dãn cơ',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Danco.mp4',
        'videoVip': 'assets/training/videos/Dancovip.mp4',
        'description': 'Dãn cơ là động tác giãn cơ vai đơn giản, thực hiện bằng cách kéo cánh tay ngang qua ngực để kéo giãn cơ vai sau và cơ xung quanh khớp vai, giúp tăng độ linh hoạt và giảm căng cứng.',
        'note': 'Không nâng vai lên khi kéo giãn. Kéo nhẹ nhàng, tránh giật mạnh để không gây chấn thương. Duy trì hơi thở ổn định trong suốt thời gian giữ tư thế.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, hai chân rộng bằng vai, thả lỏng vai và lưng.|Giãn cơ: Đưa một tay ngang qua ngực, tay còn lại giữ và kéo nhẹ cánh tay đó sát vào ngực để cảm nhận căng ở vai. |  Giữ tư thế: Giữ vị trí kéo giãn 15–30 giây, thở đều, sau đó đổi bên.',
        'imageUrl': "assets/training/images/Danco.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 2,
        'name': 'Dumbbell Side Lateral Raise Behind Back',
        'sets': 3,
        'reps': 20,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Vaitruoc.mp4',
        'videoVip': 'assets/training/videos/Vaivip.mp4',
        'description': 'Dumbbell Side Lateral Raise Behind Back là biến thể của bài nâng tạ ngang tay, thực hiện với tạ đơn ở phía sau cơ thể, giúp tác động sâu vào cơ vai giữa và vai sau, đồng thời cải thiện độ linh hoạt khớp vai.',
        'note': 'Không đung đưa người, giữ lưng thẳng, chọn mức tạ vừa sức để duy trì kỹ thuật chuẩn.',
        'step': 'Tư thế chuẩn bị: Đứng thẳng, chân rộng bằng vai, một tay cầm tạ đơn đặt ở phía sau hông, lòng bàn tay hướng vào trong.| Nâng tạ: Hít vào, từ từ nâng tay sang ngang đến ngang vai, giữ thẳng cánh tay.|Hạ tạ: Thở ra, hạ tạ trở về vị trí ban đầu một cách kiểm soát, lặp lại rồi đổi tay.',
        'imageUrl': "assets/training/images/Vai.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 2,
        'name': 'Incline Bench Reverse Fly',
        'sets': 3,
        'reps': 20,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Vaitruoc1.mp4',
        'videoVip': 'assets/training/videos/Vaivip.mp4',
        'description': 'Incline Bench Reverse Fly là bài tập vai sau và lưng trên, thực hiện khi nằm sấp trên ghế dốc với tạ đơn, giúp phát triển cơ vai sau, cơ xô và cơ thang, đồng thời cải thiện tư thế và sức mạnh phần lưng trên.',
        'note': 'Giữ lưng và cổ thẳng, không nhún vai quá mức, tránh dùng lực quán tính, chọn mức tạ vừa sức để duy trì kỹ thuật.',
        'step': ' Tư thế chuẩn bị: Nằm sấp trên ghế dốc, ngực áp sát ghế, hai tay cầm tạ đơn duỗi thẳng xuống, lòng bàn tay hướng vào nhau.|Nâng tạ: Hít vào, nâng hai tay sang ngang đến ngang vai, khuỷu tay hơi cong, siết cơ vai sau.|Hạ tạ: Thở ra, hạ tạ chậm và có kiểm soát về vị trí ban đầu, lặp lại.',
        'imageUrl': "assets/training/images/Vai.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 2,
        'name': 'Incline Bench Dumbbell Shrug',
        'sets': 3,
        'reps': 20,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Cauvai.mp4',
        'videoVip': 'assets/training/videos/Vaivip.mp4',
        'description': 'Incline Bench Dumbbell Shrug là bài tập cô lập cơ cầu vai, giúp phát triển phần cơ trap trên hiệu quả mà không gây căng lưng dưới như các bài shrug đứng thông thường.',
        'note': 'Giữ lưng và cổ thẳng, không nhún vai quá mức, tránh dùng lực quán tính, chọn mức tạ vừa sức để duy trì kỹ thuật.',
        'step': '  Tư thế chuẩn bị: Nằm úp người lên ghế nghiêng (incline), hai tay giữ tạ thả lỏng hướng thẳng xuống đất, vai không gồng.| Nâng vai: Thở ra, gồng cơ cầu vai và kéo vai lên hướng về tai, giữ khuỷu tay thẳng, không co tay.| Trở về vị trí ban đầu: Hít vào, từ từ hạ vai xuống vị trí ban đầu, cảm nhận cơ giãn.',
        'imageUrl': "assets/training/images/Vai.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 2,
        'name': 'Machine Shoulder Press',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Vaitren.mp4',
        'videoVip': 'assets/training/videos/Vaivip.mp4',
        'description': 'Machine Shoulder Press là bài đẩy vai sử dụng máy, giúp tập trung phát triển cơ vai trước và vai giữa, đồng thời hỗ trợ ổn định khớp vai nhờ chuyển động dẫn hướng cố định.',
        'note': 'Giữ lưng áp sát ghế, không nhún vai quá mức, tránh dùng quán tính, điều chỉnh ghế sao cho tay cầm ngang vai khi bắt đầu.',
        'step': ' Tư thế chuẩn bị: Ngồi trên ghế máy, lưng tựa thẳng, hai tay nắm tay cầm ở ngang vai, lòng bàn tay hướng về phía trước.|Đẩy tạ: Hít vào, đẩy tay cầm lên cao đến khi tay gần duỗi thẳng, không khóa khớp.|Hạ tạ: Thở ra, hạ tay cầm chậm về vị trí ban đầu, kiểm soát toàn bộ chuyển động.',
        'imageUrl': "assets/training/images/Vai.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 2,
        'name': 'Cable One Arm Reverse Curl',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Taytruoc1.mp4',
        'videoVip': 'assets/training/videos/Taytruocvip.mp4',
        'description': 'Cable One Arm Reverse Curl là bài cuốn tạ ngược một tay với cáp, tập trung vào cơ cẳng tay và cơ tay trước, giúp tăng sức mạnh và độ săn chắc cẳng tay.',
        'note': 'Không vung tay, giữ lưng thẳng, thực hiện chậm và kiểm soát để tối đa tác động lên cơ cẳng tay.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, quay mặt về phía máy kéo cáp, tay cầm thanh hoặc tay cầm đơn ở vị trí thấp, lòng bàn tay hướng xuống, khuỷu tay sát thân người.| Cuốn tạ: Hít vào, cuốn tay lên phía trước đến khi cẳng tay vuông góc với sàn, giữ cổ tay thẳng.|Hạ tạ: Thở ra, từ từ hạ tay trở về vị trí ban đầu, kiểm soát toàn bộ chuyển động.',
        'imageUrl': "assets/training/images/Tay.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 2,
        'name': 'Incline Bench Kettlebell Curl',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Taytruoc2.mp4',
        'videoVip': 'assets/training/videos/Taytruocvip.mp4',
        'description': 'Cable One Arm Reverse Curl là bài cuốn tạ ngược một tay với cáp, tập trung vào cơ cẳng tay và cơ tay trước, giúp tăng sức mạnh và độ săn chắc cẳng tay.',
        'note': 'Giữ lưng và ngực áp sát ghế để cô lập cơ tay trước. Không vung tạ hoặc sử dụng lực quán tính. Chọn mức tạ phù hợp để duy trì kỹ thuật chuẩn suốt bài tập.',
        'step': ' Tư thế chuẩn bị: Điều chỉnh ghế nghiêng khoảng 45°, đứng hoặc quỳ phía sau ghế, tỳ ngực vào phần tựa, một tay cầm tạ ấm với lòng bàn tay hướng ra trước, tay duỗi thẳng xuống.| Cuốn tạ: Hít vào, gập khuỷu tay để nâng tạ lên gần vai, giữ cố định phần cánh tay trên, chỉ di chuyển cẳng tay.| Hạ tạ: Thở ra, từ từ hạ tạ trở lại vị trí ban đầu, kiểm soát tốc độ để tránh mất form.',
        'imageUrl': "assets/training/images/Tay.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 2,
        'name': 'Incline Bench Kettlebell Curl',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Cangtay.mp4',
        'videoVip': 'assets/training/videos/Taytruocvip.mp4',
        'description': 'Concentration Curl là một trong những bài tập cô lập cơ tay trước (biceps) hiệu quả nhất. Với tư thế ngồi và cánh tay được cố định trên đùi, bài tập giúp loại bỏ sự hỗ trợ từ các nhóm cơ khác, từ đó tập trung hoàn toàn vào việc kích hoạt cơ nhị đầu. Đây là bài tập lý tưởng để tạo độ nét và sự phân tách rõ ràng ở bắp tay, đồng thời giúp cải thiện sự kết nối tâm trí–cơ bắp trong quá trình luyện tập.',
        'note': ' Giữ thân người cố định, không nhấc khuỷu tay khỏi đùi, tránh đung đưa vai hay lưng; tập trung siết cơ bắp tay suốt quá trình thực hiện.',
        'step': ' Tư thế chuẩn bị: Ngồi trên ghế phẳng, chân dang rộng, tay cầm tạ đơn, tỳ khuỷu tay lên mặt trong của đùi cùng bên, tay còn lại đặt trên đùi còn lại để giữ thăng bằng.|  Gập tay: Thở ra, cuốn tạ lên từ từ bằng lực cơ tay trước, không vung tạ hoặc dùng quán tính.| Trở về vị trí ban đầu: Hít vào, từ từ hạ tạ xuống đến khi tay gần duỗi thẳng (không thả rơi tạ), giữ cơ luôn căng.',
        'imageUrl': "assets/training/images/Tay.png",
      });
      //Day3

      await db.insert('exercise', {
        'day_id': 15*i+ 3,
        'name': 'Dãn cơ',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Danco.mp4',
        'videoVip': 'assets/training/videos/Dancovip.mp4',
        'description': 'Dãn cơ là động tác giãn cơ vai đơn giản, thực hiện bằng cách kéo cánh tay ngang qua ngực để kéo giãn cơ vai sau và cơ xung quanh khớp vai, giúp tăng độ linh hoạt và giảm căng cứng.',
        'note': 'Không nâng vai lên khi kéo giãn. Kéo nhẹ nhàng, tránh giật mạnh để không gây chấn thương. Duy trì hơi thở ổn định trong suốt thời gian giữ tư thế.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, hai chân rộng bằng vai, thả lỏng vai và lưng.|Giãn cơ: Đưa một tay ngang qua ngực, tay còn lại giữ và kéo nhẹ cánh tay đó sát vào ngực để cảm nhận căng ở vai. |  Giữ tư thế: Giữ vị trí kéo giãn 15–30 giây, thở đều, sau đó đổi bên.',
        'imageUrl': "assets/training/images/Danco.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 3,
        'name': 'Lat & Upper Back Stretch on SkiErg',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Lat1.mp4',
        'videoVip': 'assets/training/videos/Lungvip.mp4',
        'description': 'Lat & Upper Back Stretch on SkiErg là động tác giãn cơ lưng và vai được thực hiện với máy SkiErg, giúp kéo giãn cơ xô (Latissimus dorsi), cơ lưng giữa và cơ vai sau, cải thiện độ linh hoạt phần thân trên.',
        'note': 'Giữ lưng thẳng, không cong lưng quá mức. Không khóa khớp khuỷu tay, thả lỏng vai để tăng hiệu quả kéo giãn. Có thể thực hiện động tác này với thanh cố định hoặc dây kháng lực nếu không có máy SkiErg.',
        'step': ' Tư thế chuẩn bị: Đứng đối diện máy SkiErg, hai chân rộng bằng vai, tay nắm chặt tay cầm, hơi gập gối.| Giãn cơ: Đẩy hông ra sau, gập người về trước, giữ cánh tay thẳng và cảm nhận sự kéo giãn ở lưng và vai.| Giữ tư thế: Giữ vị trí này 20–30 giây, thở sâu và đều, sau đó từ từ trở lại vị trí ban đầu.',
        'imageUrl': "assets/training/images/Lung.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 3,
        'name': ' Straight-Arm Cable Pulldown',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Lat2.mp4',
        'videoVip': 'assets/training/videos/Lungvip.mp4',
        'description': 'Straight-Arm Cable Pulldown là bài kéo xô với tay duỗi thẳng, sử dụng dây cáp, giúp cô lập và phát triển cơ xô (latissimus dorsi) hiệu quả, đặc biệt là phần cơ lưng rộng dưới, đồng thời hỗ trợ cải thiện khả năng kiểm soát chuyển động tay trong các bài tập kéo khác như pull-up, lat pulldown.',
        'note': 'Giữ tay luôn duỗi thẳng, tránh dùng quán tính hay gập khuỷu tay; siết cơ bụng và giữ lưng thẳng trong suốt chuyển động để cô lập tốt cơ lưng.',
        'step': 'Tư thế chuẩn bị: Đứng hơi cúi người, tay nắm thanh cáp cao, tay duỗi thẳng, lưng giữ thẳng. |Kéo thanh cáp: Kéo thanh cáp xuống gần đùi theo vòng cung, siết cơ xô, tay vẫn duỗi thẳng. | Trả về vị trí ban đầu:Đưa cáp trở lại chậm rãi, kiểm soát lực, giữ căng liên tục lên cơ lưng.',
        'imageUrl': "assets/training/images/Lung.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 3,
        'name': 'Kettlebell Bent-Over Row',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Lungduoi.mp4',
        'videoVip': 'assets/training/videos/Lungvip.mp4',
        'description': 'Kettlebell Bent-Over Row là bài tập kéo tạ chuông khi người cúi về phía trước, giúp phát triển sức mạnh và độ dày cho cơ lưng giữa, đồng thời cải thiện tư thế và khả năng giữ thăng bằng của thân trên. Bài tập này phù hợp để cô lập cơ lưng với mức tạ vừa phải, hỗ trợ tốt cho các bài tập kéo lớn như deadlift hoặc pull-up.',
        'note': 'Giữ lưng luôn thẳng, không cong lưng hay ngửa đầu quá mức; tránh dùng đà hông để kéo tạ; tập trung vào cơ lưng thay vì tay; kiểm soát chuyển động để đạt hiệu quả tối đa và tránh chấn thương.',
        'step': ' Đứng hai chân rộng bằng vai, mỗi tay cầm một quả tạ chuông, cúi người về phía trước đến khi thân trên gần song song sàn, lưng giữ thẳng, mắt nhìn xuống sàn, tay duỗi thẳng tự nhiên.| Hít vào, kéo hai tay cầm tạ lên phía eo bằng cách siết cơ lưng và gập khuỷu tay về sau. Giữ khuỷu tay gần thân người khi kéo.|Thở ra, từ từ hạ tạ trở lại vị trí ban đầu, giữ lưng thẳng và kiểm soát toàn bộ chuyển động. ',
        'imageUrl': "assets/training/images/Lung.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 3,
        'name': 'Dumbbell One-Arm Row',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Trap1.mp4',
        'videoVip': 'assets/training/videos/Lungvip.mp4',
        'description': 'Dumbbell One-Arm Row là bài tập kéo tạ đơn bằng một tay, thường thực hiện với ghế hoặc tư thế chống đùi như hình. Bài tập giúp tăng cường cơ lưng giữa và lưng xô, hỗ trợ cải thiện độ dày lưng, phát triển cơ đối xứng và tăng khả năng kiểm soát thân trên.',
        'note': 'Giữ lưng luôn thẳng, không cong lưng hay ngửa đầu quá mức; tránh dùng đà hông để kéo tạ; tập trung vào cơ lưng thay vì tay; kiểm soát chuyển động để đạt hiệu quả tối đa và tránh chấn thương.',
        'step': ' Đứng hai chân rộng, một tay tựa lên đùi hoặc ghế, tay còn lại cầm tạ đơn, thân người cúi về phía trước, lưng thẳng, mắt nhìn xuống và tay cầm tạ duỗi thẳng dưới vai.| Hít vào, kéo tạ lên ngang eo bằng cách gập khuỷu tay về sau, giữ khuỷu tay sát thân và siết chặt cơ lưng ở điểm cao nhất.|Thở ra, từ từ hạ tạ xuống vị trí ban đầu, kiểm soát chuyển động để giữ căng thẳng lên cơ mục tiêu.  ',
        'imageUrl': "assets/training/images/Lung.png",
      });

      //Day4

      await db.insert('exercise', {
        'day_id': 15*i+ 4,
        'name': 'Dãn cơ',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Danco.mp4',
        'videoVip': 'assets/training/videos/Dancovip.mp4',
        'description': 'Dãn cơ là động tác giãn cơ vai đơn giản, thực hiện bằng cách kéo cánh tay ngang qua ngực để kéo giãn cơ vai sau và cơ xung quanh khớp vai, giúp tăng độ linh hoạt và giảm căng cứng.',
        'note': 'Không nâng vai lên khi kéo giãn. Kéo nhẹ nhàng, tránh giật mạnh để không gây chấn thương. Duy trì hơi thở ổn định trong suốt thời gian giữ tư thế.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, hai chân rộng bằng vai, thả lỏng vai và lưng.|Giãn cơ: Đưa một tay ngang qua ngực, tay còn lại giữ và kéo nhẹ cánh tay đó sát vào ngực để cảm nhận căng ở vai. |  Giữ tư thế: Giữ vị trí kéo giãn 15–30 giây, thở đều, sau đó đổi bên.',
        'imageUrl': "assets/training/images/Danco.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 4,
        'name': 'Cable Crunch',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Gapbung1.mp4',
        'videoVip': 'assets/training/videos/Bungvip.mp4',
        'description': 'Cable Crunch là bài tập bụng sử dụng máy kéo cáp, tập trung vào cơ bụng giữa và bụng dưới. Nhờ chuyển động gập thân có kiểm soát dưới lực cản của dây cáp, bài tập giúp siết cơ bụng sâu và hiệu quả hơn các động tác gập bụng thông thường.',
        'note': 'Không dùng tay để kéo dây, chuyển động phải do cơ bụng điều khiển. Giữ hông cố định, tránh nhấc hông hoặc đẩy người ra sau. Gập người có kiểm soát, không dùng quán tính, siết bụng ở điểm cuối chuyển động.',
        'step': ' Gắn dây thừng vào ròng rọc cao. Quỳ xuống trước máy, hai tay nắm hai đầu dây, đặt gần hai bên đầu (sát tai), lưng giữ thẳng tự nhiên, đầu hơi cúi.| Thở ra, siết cơ bụng, gập người về phía trước bằng cách cuộn phần thân trên xuống dưới, kéo dây theo chuyển động tự nhiên. Giữ hông cố định, chỉ chuyển động ở thân trên.| Hít vào, từ từ nâng thân trên trở về tư thế ban đầu nhưng không để cơ bụng mất căng.',
        'imageUrl': "assets/training/images/Bung.png",
      });



      await db.insert('exercise', {
        'day_id': 15*i+ 4,
        'name': 'Standing Dumbbell Side Bend',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Gapnguoi1.mp4',
        'videoVip': 'assets/training/videos/Bungvip.mp4',
        'description': 'Standing Dumbbell Side Bend là bài tập tác động trực tiếp đến cơ liên sườn – nhóm cơ hai bên bụng. Với tạ đơn hoặc đĩa tạ nâng qua đầu, bài tập giúp tăng sức mạnh cơ bụng bên, cải thiện độ linh hoạt cột sống và tạo đường cong eo rõ nét.',
        'note': 'Không nghiêng ra sau hay đẩy hông sang bên. Luôn giữ bụng căng và lưng thẳng trong suốt bài tập. Thực hiện chậm và có kiểm soát để tránh chấn thương cột sống.',
        'step': ' Đứng thẳng, hai chân rộng bằng vai. Hai tay giữ tạ đơn bằng cả hai tay, nâng cao qua đầu, khuỷu tay duỗi nhẹ. Giữ thân người ổn định, siết nhẹ cơ bụng.|Thở ra, nghiêng thân trên sang một bên (ví dụ: bên trái), cảm nhận cơ liên sườn bên đối diện bị kéo giãn. Hông và chân giữ nguyên, không nghiêng hoặc xoay. |Hít vào, từ từ đưa thân trên trở về vị trí trung lập. Sau đó lặp lại với bên còn lại. ',
        'imageUrl': "assets/training/images/Bung.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 4,
        'name': 'Crunch',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Gapnguoi2.mp4',
        'videoVip': 'assets/training/videos/Bungvip.mp4',
        'description': 'Crunch là bài tập bụng cơ bản, hiệu quả cao, thường dùng để kích hoạt và phát triển cơ bụng thẳng. Hình minh họa cho thấy tư thế chuẩn, giúp tối ưu hiệu quả và giảm nguy cơ chấn thương cổ/lưng.',
        'note': 'Không kéo cổ, không dùng đà, lưng dưới luôn chạm sàn, cằm không ép ngực.',
        'step': ' Tư thế chuẩn bị: Nằm ngửa, co gối, bàn chân đặt sàn, tay đặt sau đầu không kéo cổ.| Gập bụng: Thở ra, nâng vai khỏi sàn, siết bụng, không nhấc lưng dưới.| Trở lại vị trí ban đầu: Hít vào, từ từ hạ vai, giữ mắt nhìn lên, cổ thẳng.',
        'imageUrl': "assets/training/images/Bung.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 4,
        'name': 'Side Bend',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Coliensuon2.mp4',
        'videoVip': 'assets/training/videos/Bungvip.mp4',
        'description': 'Side Bend là bài tập hiệu quả giúp siết chặt và phát triển cơ liên sườn, cải thiện vóc dáng eo và thân trên cân đối.',
        'note': 'Không xoay thân khi nghiêng, giữ lưng thẳng, không dùng đà, chuyển động chậm và kiểm soát, tránh nghiêng quá sâu gây căng lưng.',
        'step': '  Tư thế chuẩn bị: Đứng thẳng, 1 tay cầm tạ buông dọc thân, tay kia đặt nhẹ sau đầu hoặc hông.| Nghiêng người: Thở ra, nghiêng thân sang bên cầm tạ, cảm nhận cơ liên sườn co lại.| Trở lại: Hít vào, từ từ kéo người thẳng lại, siết bụng, lặp lại đủ số reps rồi đổi bên.',
        'imageUrl': "assets/training/images/Bung.png",
      });

      //Day5
      await db.insert('exercise', {
        'day_id': 15*i+ 5,
        'name': 'Dãn cơ',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Danco.mp4',
        'videoVip': 'assets/training/videos/Dancovip.mp4',
        'description': 'Dãn cơ là động tác giãn cơ vai đơn giản, thực hiện bằng cách kéo cánh tay ngang qua ngực để kéo giãn cơ vai sau và cơ xung quanh khớp vai, giúp tăng độ linh hoạt và giảm căng cứng.',
        'note': 'Không nâng vai lên khi kéo giãn. Kéo nhẹ nhàng, tránh giật mạnh để không gây chấn thương. Duy trì hơi thở ổn định trong suốt thời gian giữ tư thế.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, hai chân rộng bằng vai, thả lỏng vai và lưng.|Giãn cơ: Đưa một tay ngang qua ngực, tay còn lại giữ và kéo nhẹ cánh tay đó sát vào ngực để cảm nhận căng ở vai. |  Giữ tư thế: Giữ vị trí kéo giãn 15–30 giây, thở đều, sau đó đổi bên.',
        'imageUrl': "assets/training/images/Danco.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 5,
        'name': 'Treadmill Running',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Chaybo.mp4',
        'videoVip': 'assets/training/videos/Chanvip.mp4',
        'description': 'Chạy bộ trên máy chạy (Treadmill Running) là bài tập cardio giúp nâng cao sức bền tim mạch, đốt cháy calo và cải thiện sức khỏe tổng thể. Bài tập này kích hoạt nhiều nhóm cơ cùng lúc, bao gồm cơ chân (đùi trước, đùi sau, bắp chân), cơ mông, cơ core (bụng, lưng dưới) và một phần cơ tay khi đánh tay. Chạy trên máy còn cho phép điều chỉnh tốc độ, độ dốc để phù hợp với mục tiêu luyện tập, giảm áp lực lên khớp so với chạy ngoài trời trên mặt đường cứng.',
        'note': 'Giữ tư thế chuẩn, không ngửa hoặc cúi người quá mức và luôn giữ lưng thẳng; thở đều và sâu để duy trì sức bền; nếu mới tập hãy bắt đầu với tốc độ thấp trước khi tăng tốc; không nhìn xuống chân để tránh mất thăng bằng; mang giày chạy bộ có độ đàn hồi và hỗ trợ tốt; luôn kẹp khóa an toàn của máy chạy vào quần áo để máy tự dừng nếu bị ngã.',
        'step': ' Chuẩn bị: Đứng thẳng trên hai bên thành máy chạy (không đặt chân lên băng tải khi máy đang chạy), bật máy và chọn tốc độ khởi động chậm (2–4 km/h), bước chân lên băng tải khi đã sẵn sàng.| Chạy: Giữ dáng người thẳng, mắt nhìn về phía trước, đánh tay tự nhiên theo nhịp chân (góc khuỷu tay khoảng 90°), bước chân nhẹ tiếp đất bằng phần giữa bàn chân hoặc gót rồi lăn ra mũi chân, tăng dần tốc độ và/hoặc độ dốc nếu muốn tăng độ khó.| Kết thúc: Giảm dần tốc độ về mức đi bộ để hồi phục (cool-down) trong 3–5 phút, dừng máy hoàn toàn trước khi bước xuống.',
        'imageUrl': "assets/training/images/Chan.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 5,
        'name': 'Cable Kickback',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Codui1.mp4',
        'videoVip': 'assets/training/videos/Chanvip.mp4',
        'description': 'Cable Kickback là bài tập cô lập cơ mông (gluteus maximus) và một phần cơ đùi sau (hamstrings) bằng cách dùng máy cáp để tạo lực cản trong chuyển động đá chân ra sau. Bài tập này giúp làm săn chắc, nâng mông, cải thiện sức mạnh hông và hỗ trợ các bài tập sức mạnh khác như squat hay deadlift. Nhờ lực căng liên tục từ dây cáp, cơ mông được kích hoạt đều trong cả pha kéo và hạ chân.',
        'note': 'Giữ thân người cố định, không cong lưng quá mức; tập trung siết cơ mông ở đỉnh chuyển động; không đá chân quá cao gây mất kiểm soát; chọn mức tạ vừa phải để đảm bảo đúng kỹ thuật; thở ra khi đá chân và hít vào khi hạ chân; luôn giữ căng cơ liên tục trong suốt bài tập để đạt hiệu quả tối đa.',
        'step': 'Chuẩn bị: Gắn dây đeo cổ chân vào ròng rọc thấp của máy cáp, đeo vào mắt cá chân của chân tập, hai tay nắm chắc tay cầm hoặc khung máy để giữ thăng bằng, thân người hơi nghiêng về phía trước, chân trụ hơi khuỵu gối.|Đá chân ra sau: Thở ra và đá chân đeo cáp ra sau, tập trung siết cơ mông, không vung người hoặc dùng quán tính, giữ đầu gối hơi gập nhẹ trong suốt chuyển động.|  Trở về vị trí ban đầu: Hít vào và từ từ đưa chân trở lại vị trí ban đầu, giữ lực kiểm soát để cơ vẫn căng, sau đó lặp lại đủ số lần và đổi chân.',
        'imageUrl': "assets/training/images/Chan.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 5,
        'name': 'Leg Extension',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Codui2.mp4',
        'videoVip': 'assets/training/videos/Chanvip.mp4',
        'description': 'Leg Extension là bài tập cô lập cơ tứ đầu đùi (quadriceps) sử dụng máy, giúp tăng sức mạnh và độ nét cho đùi trước. Đây là một trong những bài tập hiệu quả nhất để phát triển cơ tứ đầu vì nó tập trung hoàn toàn vào nhóm cơ này mà hầu như không có sự hỗ trợ từ các nhóm cơ khác. Bài tập phù hợp để cải thiện sức mạnh phần thân dưới, hỗ trợ hiệu suất cho các động tác squat, lunges hoặc chạy.',
        'note': 'Điều chỉnh ghế và thanh đệm phù hợp với chiều dài chân để tránh chấn thương; không dùng quán tính để nâng tạ; không duỗi chân quá nhanh hoặc khóa gối ở đỉnh; tập trung cảm nhận cơ đùi trước làm việc; chọn mức tạ phù hợp để duy trì kỹ thuật đúng; thở ra khi duỗi chân và hít vào khi hạ xuống.',
        'step': ' Chuẩn bị: Ngồi vào máy Leg Extension, điều chỉnh ghế và thanh đệm sao cho đầu gối ngang với trục xoay của máy, đặt chân dưới thanh đệm sao cho phần cổ chân tiếp xúc, hai tay nắm tay cầm của máy để giữ ổn định.|Bước 2 – Duỗi chân: Thở ra và dùng cơ đùi trước đẩy thanh đệm lên cho đến khi chân gần duỗi thẳng hoàn toàn nhưng không khóa khớp gối, tập trung siết cơ tứ đầu ở đỉnh chuyển động.|Hạ chân: Hít vào và từ từ hạ thanh đệm xuống về vị trí ban đầu, giữ kiểm soát lực để cơ vẫn căng trong suốt quá trình.',
        'imageUrl': "assets/training/images/Chan.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 5,
        'name': 'Dumbbell Hip Thrust',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Dayhong.mp4',
        'videoVip': 'assets/training/videos/Chanvip.mp4',
        'description': 'Dumbbell Hip Thrust là bài tập tác động mạnh vào cơ mông (gluteus maximus) và một phần cơ đùi sau (hamstrings), đồng thời kích hoạt cơ core để giữ ổn định thân người. Đây là bài tập hiệu quả để phát triển sức mạnh và kích thước mông, cải thiện khả năng bùng nổ và hỗ trợ các động tác như squat, deadlift hoặc chạy nước rút. Việc sử dụng tạ đơn đặt trên hông giúp tăng thêm lực cản, từ đó tối ưu kích hoạt cơ.',
        'note': 'Giữ lưng thẳng và cổ ở vị trí trung lập, không ngửa đầu quá mức; không đẩy hông quá cao gây cong lưng; tập trung siết cơ mông ở đỉnh chuyển động; chọn tạ phù hợp để duy trì kỹ thuật chuẩn; thở ra khi nâng hông và hít vào khi hạ xuống; đặt gót chân chắc trên sàn để tối ưu lực từ cơ mông và đùi sau.',
        'step': 'Chuẩn bị: Ngồi trên sàn, lưng tựa vào mép ghế, đặt một tạ đơn ngang hông và giữ chắc bằng hai tay, gập gối và đặt bàn chân phẳng trên sàn, rộng bằng vai.| Nâng hông: Thở ra, đẩy gót chân xuống sàn và nâng hông lên cho đến khi thân người và đùi tạo thành một đường thẳng, siết chặt cơ mông ở đỉnh chuyển động.|Hạ hông: Hít vào, từ từ hạ hông xuống gần sát sàn nhưng không để chạm hẳn, giữ căng cơ liên tục rồi lặp lại động tác.',
        'imageUrl': "assets/training/images/Chan.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 5,
        'name': 'Elliptical Trainer',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Xedap.mp4',
        'videoVip': 'assets/training/videos/Chanvip.mp4',
        'description': 'Elliptical Trainer là bài tập cardio toàn thân sử dụng máy elip, mô phỏng chuyển động đi bộ hoặc chạy nhưng giảm tối đa tác động lên khớp. Bài tập này kích hoạt cả nhóm cơ thân dưới (đùi trước, đùi sau, mông, bắp chân) và thân trên (ngực, vai, tay) khi kết hợp tay cầm di chuyển. Nó giúp tăng sức bền tim mạch, đốt mỡ và cải thiện khả năng vận động nhịp nhàng.',
        'note': 'Giữ trọng tâm cơ thể đều hai chân, tránh dồn lực quá nhiều lên mũi hoặc gót; không nắm tay cầm quá chặt gây căng cơ vai; hít thở đều đặn theo nhịp; khởi động trước và giãn cơ sau khi tập; nếu mới bắt đầu, tập khoảng 10–15 phút rồi tăng dần thời gian và cường độ.',
        'step': 'Chuẩn bị: Đứng lên máy elip, đặt chân lên bàn đạp, tay nắm chắc tay cầm di chuyển hoặc cố định tùy mục tiêu tập.|Bắt đầu chuyển động: Đẩy một chân về phía trước đồng thời kéo tay đối diện về phía sau, mô phỏng động tác chạy nhưng mượt mà và liên tục.|Điều chỉnh: Duy trì tư thế thẳng lưng, mắt nhìn thẳng, vai thả lỏng; điều chỉnh tốc độ và lực cản (resistance) theo mục tiêu (đốt mỡ → nhẹ, nhanh; tăng sức mạnh → nặng, chậm).',
        'imageUrl': "assets/training/images/Chan.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 6,
        'name': 'Dãn cơ',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Danco.mp4',
        'videoVip': 'assets/training/videos/Dancovip.mp4',
        'description': 'Dãn cơ là động tác giãn cơ vai đơn giản, thực hiện bằng cách kéo cánh tay ngang qua ngực để kéo giãn cơ vai sau và cơ xung quanh khớp vai, giúp tăng độ linh hoạt và giảm căng cứng.',
        'note': 'Không nâng vai lên khi kéo giãn. Kéo nhẹ nhàng, tránh giật mạnh để không gây chấn thương. Duy trì hơi thở ổn định trong suốt thời gian giữ tư thế.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, hai chân rộng bằng vai, thả lỏng vai và lưng.|Giãn cơ: Đưa một tay ngang qua ngực, tay còn lại giữ và kéo nhẹ cánh tay đó sát vào ngực để cảm nhận căng ở vai. |  Giữ tư thế: Giữ vị trí kéo giãn 15–30 giây, thở đều, sau đó đổi bên.',
        'imageUrl': "assets/training/images/Danco.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 6,
        'name': 'Diamond Push-up',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Hitdat.mp4',
        'videoVip': 'assets/training/videos/Ngucvip.mp4',
        'description': 'Chống đẩy kim cương là một biến thể của chống đẩy cơ bản, tập trung nhiều hơn vào cơ ngực trong, cơ tam đầu (triceps) và một phần vai trước. Động tác này đòi hỏi sự ổn định cao từ cơ bụng, lưng dưới, và đùi sau, đồng thời giúp phát triển sức mạnh thân trên toàn diện.',
        'note': 'Giữ cơ thể thẳng trong suốt bài tập, không võng lưng hoặc đẩy mông lên cao.Nếu quá khó, bạn có thể chống gối xuống đất để giảm độ nặng.Không hạ ngực quá sâu gây áp lực lên khớp vai.Kiểm soát chuyển động, không để cơ thể rơi tự do.',
        'step': 'Vào tư thế chuẩn bị|Hạ người xuống|Dùng lực đẩy mạnh từ tay và ngực, đưa thân người trở về vị trí ban đầu|Thở ra khi bạn đẩy người lên.',
        'imageUrl': "assets/training/images/Nguc.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 6,
        'name': 'Incline Dumbbell Press',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Nguc1.mp4',
        'videoVip': 'assets/training/videos/Ngucvip.mp4',
        'description': 'Incline Dumbbell Press là bài tập đẩy ngực trên với tạ đơn, giúp phát triển nhóm cơ ngực trên, cơ vai trước và cơ tay sau. So với dùng thanh đòn, tạ đơn cho biên độ chuyển động rộng hơn, tăng khả năng co giãn cơ và cải thiện sự cân đối giữa hai bên cơ thể. Bài tập này phù hợp cho người muốn xây dựng sức mạnh phần thân trên và cải thiện hình dáng ngực.',
        'note': 'Giữ lưng áp sát ghế, không vung tạ, chọn mức tạ phù hợp để kiểm soát tốt cả khi đẩy và hạ, tránh cong lưng hoặc gồng cổ quá mức.',
        'step': 'Tư thế chuẩn bị: Điều chỉnh ghế nghiêng 30–45°, mỗi tay cầm 1 quả tạ đơn, ngả lưng áp sát ghế, tạ ở ngang ngực, lòng bàn tay hướng ra trước.| Hạ tạ: Hít sâu, từ từ hạ tạ xuống cho đến khi khuỷu tay thấp hơn ngực một chút, giữ góc khuỷu tay ổn định và chuyển động có kiểm soát.|Đẩy tạ: Thở ra, đẩy tạ thẳng lên cho đến khi gần chạm nhau, không khóa khớp khuỷu, siết cơ ngực ở đỉnh động tác.',
        'imageUrl': "assets/training/images/Nguc.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 6,
        'name': 'Barbell Bench Press',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Nguc2.mp4',
        'videoVip': 'assets/training/videos/Ngucvip.mp4',
        'description': 'Barbell Bench Press là bài tập đẩy tạ đòn trên ghế phẳng nhằm phát triển sức mạnh và kích thước cơ ngực, đồng thời tác động đến cơ vai trước và cơ tay sau, là một trong những bài tập sức mạnh cơ bản và phổ biến nhất trong tập luyện thể hình.',
        'note': ' Không cong lưng dưới quá mức, không để thanh tạ bật nảy trên ngực, giữ cổ tay thẳng và chắc chắn, kiểm soát tốc độ tạ cả khi đẩy và hạ để tránh chấn thương vai và cổ tay.',
        'step': 'Tư thế chuẩn bị: Nằm ngửa trên ghế phẳng, hai chân đặt vững trên sàn, mắt ở vị trí ngay dưới thanh đòn, tay nắm thanh tạ rộng hơn vai một chút, giữ bả vai ép chặt và lưng áp sát ghế.|Hít sâu, từ từ hạ thanh tạ xuống chạm nhẹ phần giữa ngực, khuỷu tay tạo góc khoảng 45 độ so với thân người, giữ kiểm soát toàn bộ chuyển động.|Đẩy tạ: Thở ra và đẩy thanh tạ thẳng lên cho đến khi tay gần duỗi hết nhưng không khóa khớp, giữ cơ ngực siết chặt ở đỉnh động tác.',
        'imageUrl': "assets/training/images/Nguc.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 6,
        'name': 'Dumbbell Floor Press',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Ngucduoi.mp4',
        'videoVip': 'assets/training/videos/Ngucvip.mp4',
        'description': 'Dumbbell Floor Press là bài đẩy tạ đơn trên sàn giúp phát triển cơ ngực, cơ tay sau và cơ vai trước, đồng thời giảm áp lực lên vai so với bench press, phù hợp cho người tập tại nhà hoặc phục hồi chấn thương vai.',
        'note': 'Giữ cổ tay thẳng, không để tạ rơi tự do, kiểm soát tốc độ cả khi đẩy và hạ, không ưỡn lưng quá mức, chọn mức tạ phù hợp để tránh chấn thương vai.',
        'step': 'Tư thế chuẩn bị: Nằm ngửa trên sàn, gối co, bàn chân đặt vững, mỗi tay cầm một tạ đơn, cánh tay vuông góc với thân, tạ ở ngang ngực, lòng bàn tay hướng ra trước.|Hạ tạ: Hít sâu, từ từ hạ tạ xuống cho đến khi khuỷu tay chạm nhẹ sàn, giữ góc khuỷu tay khoảng 45° so với thân.|Đẩy tạ: Thở ra, đẩy tạ thẳng lên cho đến khi tay gần duỗi hết nhưng không khóa khớp, siết cơ ngực ở đỉnh động tác.',
        'imageUrl': "assets/training/images/Nguc.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 6,
        'name': 'Seated Chest Fly',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Epnguc.mp4',
        'videoVip': 'assets/training/videos/Ngucvip.mp4',
        'description': 'Seated Chest Fly trên máy là bài tập cô lập ngực giữa cực hiệu quả, giúp phát triển chiều rộng và độ nét cơ ngực, đồng thời giảm áp lực lên vai nhờ chuyển động dẫn hướng.',
        'note': 'Không duỗi thẳng khuỷu, không ngả người về trước sau, không dùng lực quán tính, giữ chậm – siết mạnh khi hai tay gần chạm.',
        'step': ' Tư thế chuẩn bị: Ngồi tựa lưng chắc chắn, điều chỉnh tay cầm ngang ngực, hai tay nắm chắc tay đòn, khuỷu hơi cong.| Ép tay vào giữa: Thở ra, dùng lực cơ ngực kéo hai tay lại gần nhau trước ngực, giữ khuỷu tay cố định.| Trở về vị trí ban đầu: Hít vào, từ từ mở tay về vị trí ban đầu, cảm nhận cơ ngực giãn nhẹ.',
        'imageUrl': "assets/training/images/Nguc.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 6,
        'name': 'Rope Overhead Triceps Extension',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Taysau1.mp4',
        'videoVip': 'assets/training/videos/Taysauvip.mp4',
        'description': 'Rope Overhead Triceps Extension là bài tập tay sau sử dụng dây cáp, thực hiện ở tư thế đứng và kéo dây từ phía trên đầu ra trước, giúp phát triển cơ tam đầu tay sau và tăng sức mạnh cánh tay.',
        'note': ': Giữ cổ tay thẳng, không để tạ rơi tự do, kiểm soát tốc độ cả khi đẩy và hạ, không ưỡn lưng quá mức, chọn mức tạ phù hợp để tránh chấn thương vai.',
        'step': 'Tư thế chuẩn bị: Gắn dây rope vào ròng rọc cao, đứng quay lưng về máy, hai tay nắm hai đầu dây, bước một chân lên trước để giữ thăng bằng, tay gập ở góc 90° trước trán, cùi chỏ hướng về trước.| Duỗi tay: Thở ra, dùng lực cơ tay sau đẩy dây về phía trước và xuống dưới cho đến khi tay duỗi thẳng, cảm nhận sự co của cơ tam đầu.|Quay lại vị trí ban đầu: Hít vào, từ từ gập tay lại, đưa dây trở về vị trí ban đầu, kiểm soát toàn bộ chuyển động.',
        'imageUrl': "assets/training/images/Tay.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 6,
        'name': 'One-Arm Dumbbell Overhead Triceps Extension',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Taysau2.mp4',
        'videoVip': 'assets/training/videos/Taysauvip.mp4',
        'description': 'One-Arm Dumbbell Overhead Triceps Extension là bài tập tay sau sử dụng tạ đơn, thực hiện một tay, giúp cô lập và phát triển cơ tam đầu, đồng thời cải thiện sức mạnh và độ linh hoạt của khớp vai.',
        'note': 'Không vung tạ hoặc dùng lực quán tính.Giữ lưng thẳng, core siết chặt để tránh nghiêng người.Chọn mức tạ vừa phải để đảm bảo form chuẩn và tránh chấn thương vai hoặc khuỷu tay.',
        'step': 'Tư thế chuẩn bị: Đứng thẳng, chân rộng bằng vai, một tay cầm tạ đưa lên cao, cùi chỏ hướng lên, tay còn lại chống hông hoặc giữ cùi chỏ.|  Hạ tạ: Hít vào, gập cùi chỏ hạ tạ xuống sau đầu, giữ cánh tay trên cố định.| Duỗi tay: Thở ra, duỗi thẳng tay đưa tạ về vị trí ban đầu và lặp lại.',
        'imageUrl': "assets/training/images/Tay.png",
      });


      //Day2
      await db.insert('exercise', {
        'day_id': 15*i+ 7,
        'name': 'Dãn cơ',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Danco.mp4',
        'videoVip': 'assets/training/videos/Dancovip.mp4',
        'description': 'Dãn cơ là động tác giãn cơ vai đơn giản, thực hiện bằng cách kéo cánh tay ngang qua ngực để kéo giãn cơ vai sau và cơ xung quanh khớp vai, giúp tăng độ linh hoạt và giảm căng cứng.',
        'note': 'Không nâng vai lên khi kéo giãn. Kéo nhẹ nhàng, tránh giật mạnh để không gây chấn thương. Duy trì hơi thở ổn định trong suốt thời gian giữ tư thế.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, hai chân rộng bằng vai, thả lỏng vai và lưng.|Giãn cơ: Đưa một tay ngang qua ngực, tay còn lại giữ và kéo nhẹ cánh tay đó sát vào ngực để cảm nhận căng ở vai. |  Giữ tư thế: Giữ vị trí kéo giãn 15–30 giây, thở đều, sau đó đổi bên.',
        'imageUrl': "assets/training/images/Danco.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 7,
        'name': 'Dumbbell Side Lateral Raise Behind Back',
        'sets': 3,
        'reps': 20,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Vaitruoc.mp4',
        'videoVip': 'assets/training/videos/Vaivip.mp4',
        'description': 'Dumbbell Side Lateral Raise Behind Back là biến thể của bài nâng tạ ngang tay, thực hiện với tạ đơn ở phía sau cơ thể, giúp tác động sâu vào cơ vai giữa và vai sau, đồng thời cải thiện độ linh hoạt khớp vai.',
        'note': 'Không đung đưa người, giữ lưng thẳng, chọn mức tạ vừa sức để duy trì kỹ thuật chuẩn.',
        'step': 'Tư thế chuẩn bị: Đứng thẳng, chân rộng bằng vai, một tay cầm tạ đơn đặt ở phía sau hông, lòng bàn tay hướng vào trong.| Nâng tạ: Hít vào, từ từ nâng tay sang ngang đến ngang vai, giữ thẳng cánh tay.|Hạ tạ: Thở ra, hạ tạ trở về vị trí ban đầu một cách kiểm soát, lặp lại rồi đổi tay.',
        'imageUrl': "assets/training/images/Vai.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 7,
        'name': 'Incline Bench Reverse Fly',
        'sets': 3,
        'reps': 20,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Vaitruoc1.mp4',
        'videoVip': 'assets/training/videos/Vaivip.mp4',
        'description': 'Incline Bench Reverse Fly là bài tập vai sau và lưng trên, thực hiện khi nằm sấp trên ghế dốc với tạ đơn, giúp phát triển cơ vai sau, cơ xô và cơ thang, đồng thời cải thiện tư thế và sức mạnh phần lưng trên.',
        'note': 'Giữ lưng và cổ thẳng, không nhún vai quá mức, tránh dùng lực quán tính, chọn mức tạ vừa sức để duy trì kỹ thuật.',
        'step': ' Tư thế chuẩn bị: Nằm sấp trên ghế dốc, ngực áp sát ghế, hai tay cầm tạ đơn duỗi thẳng xuống, lòng bàn tay hướng vào nhau.|Nâng tạ: Hít vào, nâng hai tay sang ngang đến ngang vai, khuỷu tay hơi cong, siết cơ vai sau.|Hạ tạ: Thở ra, hạ tạ chậm và có kiểm soát về vị trí ban đầu, lặp lại.',
        'imageUrl': "assets/training/images/Vai.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 7,
        'name': 'Incline Bench Dumbbell Shrug',
        'sets': 3,
        'reps': 20,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Cauvai.mp4',
        'videoVip': 'assets/training/videos/Vaivip.mp4',
        'description': 'Incline Bench Dumbbell Shrug là bài tập cô lập cơ cầu vai, giúp phát triển phần cơ trap trên hiệu quả mà không gây căng lưng dưới như các bài shrug đứng thông thường.',
        'note': 'Giữ lưng và cổ thẳng, không nhún vai quá mức, tránh dùng lực quán tính, chọn mức tạ vừa sức để duy trì kỹ thuật.',
        'step': '  Tư thế chuẩn bị: Nằm úp người lên ghế nghiêng (incline), hai tay giữ tạ thả lỏng hướng thẳng xuống đất, vai không gồng.| Nâng vai: Thở ra, gồng cơ cầu vai và kéo vai lên hướng về tai, giữ khuỷu tay thẳng, không co tay.| Trở về vị trí ban đầu: Hít vào, từ từ hạ vai xuống vị trí ban đầu, cảm nhận cơ giãn.',
        'imageUrl': "assets/training/images/Vai.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 7,
        'name': 'Machine Shoulder Press',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Vaitren.mp4',
        'videoVip': 'assets/training/videos/Vaivip.mp4',
        'description': 'Machine Shoulder Press là bài đẩy vai sử dụng máy, giúp tập trung phát triển cơ vai trước và vai giữa, đồng thời hỗ trợ ổn định khớp vai nhờ chuyển động dẫn hướng cố định.',
        'note': 'Giữ lưng áp sát ghế, không nhún vai quá mức, tránh dùng quán tính, điều chỉnh ghế sao cho tay cầm ngang vai khi bắt đầu.',
        'step': ' Tư thế chuẩn bị: Ngồi trên ghế máy, lưng tựa thẳng, hai tay nắm tay cầm ở ngang vai, lòng bàn tay hướng về phía trước.|Đẩy tạ: Hít vào, đẩy tay cầm lên cao đến khi tay gần duỗi thẳng, không khóa khớp.|Hạ tạ: Thở ra, hạ tay cầm chậm về vị trí ban đầu, kiểm soát toàn bộ chuyển động.',
        'imageUrl': "assets/training/images/Vai.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 7,
        'name': 'Cable One Arm Reverse Curl',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Taytruoc1.mp4',
        'videoVip': 'assets/training/videos/Taytruocvip.mp4',
        'description': 'Cable One Arm Reverse Curl là bài cuốn tạ ngược một tay với cáp, tập trung vào cơ cẳng tay và cơ tay trước, giúp tăng sức mạnh và độ săn chắc cẳng tay.',
        'note': 'Không vung tay, giữ lưng thẳng, thực hiện chậm và kiểm soát để tối đa tác động lên cơ cẳng tay.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, quay mặt về phía máy kéo cáp, tay cầm thanh hoặc tay cầm đơn ở vị trí thấp, lòng bàn tay hướng xuống, khuỷu tay sát thân người.| Cuốn tạ: Hít vào, cuốn tay lên phía trước đến khi cẳng tay vuông góc với sàn, giữ cổ tay thẳng.|Hạ tạ: Thở ra, từ từ hạ tay trở về vị trí ban đầu, kiểm soát toàn bộ chuyển động.',
        'imageUrl': "assets/training/images/Tay.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 7,
        'name': 'Incline Bench Kettlebell Curl',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Taytruoc2.mp4',
        'videoVip': 'assets/training/videos/Taytruocvip.mp4',
        'description': 'Cable One Arm Reverse Curl là bài cuốn tạ ngược một tay với cáp, tập trung vào cơ cẳng tay và cơ tay trước, giúp tăng sức mạnh và độ săn chắc cẳng tay.',
        'note': 'Giữ lưng và ngực áp sát ghế để cô lập cơ tay trước. Không vung tạ hoặc sử dụng lực quán tính. Chọn mức tạ phù hợp để duy trì kỹ thuật chuẩn suốt bài tập.',
        'step': ' Tư thế chuẩn bị: Điều chỉnh ghế nghiêng khoảng 45°, đứng hoặc quỳ phía sau ghế, tỳ ngực vào phần tựa, một tay cầm tạ ấm với lòng bàn tay hướng ra trước, tay duỗi thẳng xuống.| Cuốn tạ: Hít vào, gập khuỷu tay để nâng tạ lên gần vai, giữ cố định phần cánh tay trên, chỉ di chuyển cẳng tay.| Hạ tạ: Thở ra, từ từ hạ tạ trở lại vị trí ban đầu, kiểm soát tốc độ để tránh mất form.',
        'imageUrl': "assets/training/images/Tay.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 7,
        'name': 'Incline Bench Kettlebell Curl',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Cangtay.mp4',
        'videoVip': 'assets/training/videos/Taytruocvip.mp4',
        'description': 'Concentration Curl là một trong những bài tập cô lập cơ tay trước (biceps) hiệu quả nhất. Với tư thế ngồi và cánh tay được cố định trên đùi, bài tập giúp loại bỏ sự hỗ trợ từ các nhóm cơ khác, từ đó tập trung hoàn toàn vào việc kích hoạt cơ nhị đầu. Đây là bài tập lý tưởng để tạo độ nét và sự phân tách rõ ràng ở bắp tay, đồng thời giúp cải thiện sự kết nối tâm trí–cơ bắp trong quá trình luyện tập.',
        'note': ' Giữ thân người cố định, không nhấc khuỷu tay khỏi đùi, tránh đung đưa vai hay lưng; tập trung siết cơ bắp tay suốt quá trình thực hiện.',
        'step': ' Tư thế chuẩn bị: Ngồi trên ghế phẳng, chân dang rộng, tay cầm tạ đơn, tỳ khuỷu tay lên mặt trong của đùi cùng bên, tay còn lại đặt trên đùi còn lại để giữ thăng bằng.|  Gập tay: Thở ra, cuốn tạ lên từ từ bằng lực cơ tay trước, không vung tạ hoặc dùng quán tính.| Trở về vị trí ban đầu: Hít vào, từ từ hạ tạ xuống đến khi tay gần duỗi thẳng (không thả rơi tạ), giữ cơ luôn căng.',
        'imageUrl': "assets/training/images/Tay.png",
      });
      //Day3

      await db.insert('exercise', {
        'day_id': 15*i+ 8,
        'name': 'Dãn cơ',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Danco.mp4',
        'videoVip': 'assets/training/videos/Dancovip.mp4',
        'description': 'Dãn cơ là động tác giãn cơ vai đơn giản, thực hiện bằng cách kéo cánh tay ngang qua ngực để kéo giãn cơ vai sau và cơ xung quanh khớp vai, giúp tăng độ linh hoạt và giảm căng cứng.',
        'note': 'Không nâng vai lên khi kéo giãn. Kéo nhẹ nhàng, tránh giật mạnh để không gây chấn thương. Duy trì hơi thở ổn định trong suốt thời gian giữ tư thế.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, hai chân rộng bằng vai, thả lỏng vai và lưng.|Giãn cơ: Đưa một tay ngang qua ngực, tay còn lại giữ và kéo nhẹ cánh tay đó sát vào ngực để cảm nhận căng ở vai. |  Giữ tư thế: Giữ vị trí kéo giãn 15–30 giây, thở đều, sau đó đổi bên.',
        'imageUrl': "assets/training/images/Danco.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 8,
        'name': 'Lat & Upper Back Stretch on SkiErg',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Lat1.mp4',
        'videoVip': 'assets/training/videos/Lungvip.mp4',
        'description': 'Lat & Upper Back Stretch on SkiErg là động tác giãn cơ lưng và vai được thực hiện với máy SkiErg, giúp kéo giãn cơ xô (Latissimus dorsi), cơ lưng giữa và cơ vai sau, cải thiện độ linh hoạt phần thân trên.',
        'note': 'Giữ lưng thẳng, không cong lưng quá mức. Không khóa khớp khuỷu tay, thả lỏng vai để tăng hiệu quả kéo giãn. Có thể thực hiện động tác này với thanh cố định hoặc dây kháng lực nếu không có máy SkiErg.',
        'step': ' Tư thế chuẩn bị: Đứng đối diện máy SkiErg, hai chân rộng bằng vai, tay nắm chặt tay cầm, hơi gập gối.| Giãn cơ: Đẩy hông ra sau, gập người về trước, giữ cánh tay thẳng và cảm nhận sự kéo giãn ở lưng và vai.| Giữ tư thế: Giữ vị trí này 20–30 giây, thở sâu và đều, sau đó từ từ trở lại vị trí ban đầu.',
        'imageUrl': "assets/training/images/Lung.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 8,
        'name': ' Straight-Arm Cable Pulldown',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Lat2.mp4',
        'videoVip': 'assets/training/videos/Lungvip.mp4',
        'description': 'Straight-Arm Cable Pulldown là bài kéo xô với tay duỗi thẳng, sử dụng dây cáp, giúp cô lập và phát triển cơ xô (latissimus dorsi) hiệu quả, đặc biệt là phần cơ lưng rộng dưới, đồng thời hỗ trợ cải thiện khả năng kiểm soát chuyển động tay trong các bài tập kéo khác như pull-up, lat pulldown.',
        'note': 'Giữ tay luôn duỗi thẳng, tránh dùng quán tính hay gập khuỷu tay; siết cơ bụng và giữ lưng thẳng trong suốt chuyển động để cô lập tốt cơ lưng.',
        'step': 'Tư thế chuẩn bị: Đứng hơi cúi người, tay nắm thanh cáp cao, tay duỗi thẳng, lưng giữ thẳng. |Kéo thanh cáp: Kéo thanh cáp xuống gần đùi theo vòng cung, siết cơ xô, tay vẫn duỗi thẳng. | Trả về vị trí ban đầu:Đưa cáp trở lại chậm rãi, kiểm soát lực, giữ căng liên tục lên cơ lưng.',
        'imageUrl': "assets/training/images/Lung.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 8,
        'name': 'Kettlebell Bent-Over Row',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Lungduoi.mp4',
        'videoVip': 'assets/training/videos/Lungvip.mp4',
        'description': 'Kettlebell Bent-Over Row là bài tập kéo tạ chuông khi người cúi về phía trước, giúp phát triển sức mạnh và độ dày cho cơ lưng giữa, đồng thời cải thiện tư thế và khả năng giữ thăng bằng của thân trên. Bài tập này phù hợp để cô lập cơ lưng với mức tạ vừa phải, hỗ trợ tốt cho các bài tập kéo lớn như deadlift hoặc pull-up.',
        'note': 'Giữ lưng luôn thẳng, không cong lưng hay ngửa đầu quá mức; tránh dùng đà hông để kéo tạ; tập trung vào cơ lưng thay vì tay; kiểm soát chuyển động để đạt hiệu quả tối đa và tránh chấn thương.',
        'step': ' Đứng hai chân rộng bằng vai, mỗi tay cầm một quả tạ chuông, cúi người về phía trước đến khi thân trên gần song song sàn, lưng giữ thẳng, mắt nhìn xuống sàn, tay duỗi thẳng tự nhiên.| Hít vào, kéo hai tay cầm tạ lên phía eo bằng cách siết cơ lưng và gập khuỷu tay về sau. Giữ khuỷu tay gần thân người khi kéo.|Thở ra, từ từ hạ tạ trở lại vị trí ban đầu, giữ lưng thẳng và kiểm soát toàn bộ chuyển động. ',
        'imageUrl': "assets/training/images/Lung.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 8,
        'name': 'Dumbbell One-Arm Row',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Trap1.mp4',
        'videoVip': 'assets/training/videos/Lungvip.mp4',
        'description': 'Dumbbell One-Arm Row là bài tập kéo tạ đơn bằng một tay, thường thực hiện với ghế hoặc tư thế chống đùi như hình. Bài tập giúp tăng cường cơ lưng giữa và lưng xô, hỗ trợ cải thiện độ dày lưng, phát triển cơ đối xứng và tăng khả năng kiểm soát thân trên.',
        'note': 'Giữ lưng luôn thẳng, không cong lưng hay ngửa đầu quá mức; tránh dùng đà hông để kéo tạ; tập trung vào cơ lưng thay vì tay; kiểm soát chuyển động để đạt hiệu quả tối đa và tránh chấn thương.',
        'step': ' Đứng hai chân rộng, một tay tựa lên đùi hoặc ghế, tay còn lại cầm tạ đơn, thân người cúi về phía trước, lưng thẳng, mắt nhìn xuống và tay cầm tạ duỗi thẳng dưới vai.| Hít vào, kéo tạ lên ngang eo bằng cách gập khuỷu tay về sau, giữ khuỷu tay sát thân và siết chặt cơ lưng ở điểm cao nhất.|Thở ra, từ từ hạ tạ xuống vị trí ban đầu, kiểm soát chuyển động để giữ căng thẳng lên cơ mục tiêu.  ',
        'imageUrl': "assets/training/images/Lung.png",
      });

      //Day4

      await db.insert('exercise', {
        'day_id': 15*i+ 9,
        'name': 'Dãn cơ',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Danco.mp4',
        'videoVip': 'assets/training/videos/Dancovip.mp4',
        'description': 'Dãn cơ là động tác giãn cơ vai đơn giản, thực hiện bằng cách kéo cánh tay ngang qua ngực để kéo giãn cơ vai sau và cơ xung quanh khớp vai, giúp tăng độ linh hoạt và giảm căng cứng.',
        'note': 'Không nâng vai lên khi kéo giãn. Kéo nhẹ nhàng, tránh giật mạnh để không gây chấn thương. Duy trì hơi thở ổn định trong suốt thời gian giữ tư thế.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, hai chân rộng bằng vai, thả lỏng vai và lưng.|Giãn cơ: Đưa một tay ngang qua ngực, tay còn lại giữ và kéo nhẹ cánh tay đó sát vào ngực để cảm nhận căng ở vai. |  Giữ tư thế: Giữ vị trí kéo giãn 15–30 giây, thở đều, sau đó đổi bên.',
        'imageUrl': "assets/training/images/Danco.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 9,
        'name': 'Cable Crunch',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Gapbung1.mp4',
        'videoVip': 'assets/training/videos/Bungvip.mp4',
        'description': 'Cable Crunch là bài tập bụng sử dụng máy kéo cáp, tập trung vào cơ bụng giữa và bụng dưới. Nhờ chuyển động gập thân có kiểm soát dưới lực cản của dây cáp, bài tập giúp siết cơ bụng sâu và hiệu quả hơn các động tác gập bụng thông thường.',
        'note': 'Không dùng tay để kéo dây, chuyển động phải do cơ bụng điều khiển. Giữ hông cố định, tránh nhấc hông hoặc đẩy người ra sau. Gập người có kiểm soát, không dùng quán tính, siết bụng ở điểm cuối chuyển động.',
        'step': ' Gắn dây thừng vào ròng rọc cao. Quỳ xuống trước máy, hai tay nắm hai đầu dây, đặt gần hai bên đầu (sát tai), lưng giữ thẳng tự nhiên, đầu hơi cúi.| Thở ra, siết cơ bụng, gập người về phía trước bằng cách cuộn phần thân trên xuống dưới, kéo dây theo chuyển động tự nhiên. Giữ hông cố định, chỉ chuyển động ở thân trên.| Hít vào, từ từ nâng thân trên trở về tư thế ban đầu nhưng không để cơ bụng mất căng.',
        'imageUrl': "assets/training/images/Bung.png",
      });



      await db.insert('exercise', {
        'day_id': 15*i+ 9,
        'name': 'Standing Dumbbell Side Bend',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Gapnguoi1.mp4',
        'videoVip': 'assets/training/videos/Bungvip.mp4',
        'description': 'Standing Dumbbell Side Bend là bài tập tác động trực tiếp đến cơ liên sườn – nhóm cơ hai bên bụng. Với tạ đơn hoặc đĩa tạ nâng qua đầu, bài tập giúp tăng sức mạnh cơ bụng bên, cải thiện độ linh hoạt cột sống và tạo đường cong eo rõ nét.',
        'note': 'Không nghiêng ra sau hay đẩy hông sang bên. Luôn giữ bụng căng và lưng thẳng trong suốt bài tập. Thực hiện chậm và có kiểm soát để tránh chấn thương cột sống.',
        'step': ' Đứng thẳng, hai chân rộng bằng vai. Hai tay giữ tạ đơn bằng cả hai tay, nâng cao qua đầu, khuỷu tay duỗi nhẹ. Giữ thân người ổn định, siết nhẹ cơ bụng.|Thở ra, nghiêng thân trên sang một bên (ví dụ: bên trái), cảm nhận cơ liên sườn bên đối diện bị kéo giãn. Hông và chân giữ nguyên, không nghiêng hoặc xoay. |Hít vào, từ từ đưa thân trên trở về vị trí trung lập. Sau đó lặp lại với bên còn lại. ',
        'imageUrl': "assets/training/images/Bung.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 9,
        'name': 'Crunch',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Gapnguoi2.mp4',
        'videoVip': 'assets/training/videos/Bungvip.mp4',
        'description': 'Crunch là bài tập bụng cơ bản, hiệu quả cao, thường dùng để kích hoạt và phát triển cơ bụng thẳng. Hình minh họa cho thấy tư thế chuẩn, giúp tối ưu hiệu quả và giảm nguy cơ chấn thương cổ/lưng.',
        'note': 'Không kéo cổ, không dùng đà, lưng dưới luôn chạm sàn, cằm không ép ngực.',
        'step': ' Tư thế chuẩn bị: Nằm ngửa, co gối, bàn chân đặt sàn, tay đặt sau đầu không kéo cổ.| Gập bụng: Thở ra, nâng vai khỏi sàn, siết bụng, không nhấc lưng dưới.| Trở lại vị trí ban đầu: Hít vào, từ từ hạ vai, giữ mắt nhìn lên, cổ thẳng.',
        'imageUrl': "assets/training/images/Bung.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 9,
        'name': 'Side Bend',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Coliensuon2.mp4',
        'videoVip': 'assets/training/videos/Bungvip.mp4',
        'description': 'Side Bend là bài tập hiệu quả giúp siết chặt và phát triển cơ liên sườn, cải thiện vóc dáng eo và thân trên cân đối.',
        'note': 'Không xoay thân khi nghiêng, giữ lưng thẳng, không dùng đà, chuyển động chậm và kiểm soát, tránh nghiêng quá sâu gây căng lưng.',
        'step': '  Tư thế chuẩn bị: Đứng thẳng, 1 tay cầm tạ buông dọc thân, tay kia đặt nhẹ sau đầu hoặc hông.| Nghiêng người: Thở ra, nghiêng thân sang bên cầm tạ, cảm nhận cơ liên sườn co lại.| Trở lại: Hít vào, từ từ kéo người thẳng lại, siết bụng, lặp lại đủ số reps rồi đổi bên.',
        'imageUrl': "assets/training/images/Bung.png",
      });

      //Day5
      await db.insert('exercise', {
        'day_id': 15*i+ 10,
        'name': 'Dãn cơ',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Danco.mp4',
        'videoVip': 'assets/training/videos/Dancovip.mp4',
        'description': 'Dãn cơ là động tác giãn cơ vai đơn giản, thực hiện bằng cách kéo cánh tay ngang qua ngực để kéo giãn cơ vai sau và cơ xung quanh khớp vai, giúp tăng độ linh hoạt và giảm căng cứng.',
        'note': 'Không nâng vai lên khi kéo giãn. Kéo nhẹ nhàng, tránh giật mạnh để không gây chấn thương. Duy trì hơi thở ổn định trong suốt thời gian giữ tư thế.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, hai chân rộng bằng vai, thả lỏng vai và lưng.|Giãn cơ: Đưa một tay ngang qua ngực, tay còn lại giữ và kéo nhẹ cánh tay đó sát vào ngực để cảm nhận căng ở vai. |  Giữ tư thế: Giữ vị trí kéo giãn 15–30 giây, thở đều, sau đó đổi bên.',
        'imageUrl': "assets/training/images/Danco.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 10,
        'name': 'Treadmill Running',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Chaybo.mp4',
        'videoVip': 'assets/training/videos/Chanvip.mp4',
        'description': 'Chạy bộ trên máy chạy (Treadmill Running) là bài tập cardio giúp nâng cao sức bền tim mạch, đốt cháy calo và cải thiện sức khỏe tổng thể. Bài tập này kích hoạt nhiều nhóm cơ cùng lúc, bao gồm cơ chân (đùi trước, đùi sau, bắp chân), cơ mông, cơ core (bụng, lưng dưới) và một phần cơ tay khi đánh tay. Chạy trên máy còn cho phép điều chỉnh tốc độ, độ dốc để phù hợp với mục tiêu luyện tập, giảm áp lực lên khớp so với chạy ngoài trời trên mặt đường cứng.',
        'note': 'Giữ tư thế chuẩn, không ngửa hoặc cúi người quá mức và luôn giữ lưng thẳng; thở đều và sâu để duy trì sức bền; nếu mới tập hãy bắt đầu với tốc độ thấp trước khi tăng tốc; không nhìn xuống chân để tránh mất thăng bằng; mang giày chạy bộ có độ đàn hồi và hỗ trợ tốt; luôn kẹp khóa an toàn của máy chạy vào quần áo để máy tự dừng nếu bị ngã.',
        'step': ' Chuẩn bị: Đứng thẳng trên hai bên thành máy chạy (không đặt chân lên băng tải khi máy đang chạy), bật máy và chọn tốc độ khởi động chậm (2–4 km/h), bước chân lên băng tải khi đã sẵn sàng.| Chạy: Giữ dáng người thẳng, mắt nhìn về phía trước, đánh tay tự nhiên theo nhịp chân (góc khuỷu tay khoảng 90°), bước chân nhẹ tiếp đất bằng phần giữa bàn chân hoặc gót rồi lăn ra mũi chân, tăng dần tốc độ và/hoặc độ dốc nếu muốn tăng độ khó.| Kết thúc: Giảm dần tốc độ về mức đi bộ để hồi phục (cool-down) trong 3–5 phút, dừng máy hoàn toàn trước khi bước xuống.',
        'imageUrl': "assets/training/images/Chan.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 10,
        'name': 'Cable Kickback',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Codui1.mp4',
        'videoVip': 'assets/training/videos/Chanvip.mp4',
        'description': 'Cable Kickback là bài tập cô lập cơ mông (gluteus maximus) và một phần cơ đùi sau (hamstrings) bằng cách dùng máy cáp để tạo lực cản trong chuyển động đá chân ra sau. Bài tập này giúp làm săn chắc, nâng mông, cải thiện sức mạnh hông và hỗ trợ các bài tập sức mạnh khác như squat hay deadlift. Nhờ lực căng liên tục từ dây cáp, cơ mông được kích hoạt đều trong cả pha kéo và hạ chân.',
        'note': 'Giữ thân người cố định, không cong lưng quá mức; tập trung siết cơ mông ở đỉnh chuyển động; không đá chân quá cao gây mất kiểm soát; chọn mức tạ vừa phải để đảm bảo đúng kỹ thuật; thở ra khi đá chân và hít vào khi hạ chân; luôn giữ căng cơ liên tục trong suốt bài tập để đạt hiệu quả tối đa.',
        'step': 'Chuẩn bị: Gắn dây đeo cổ chân vào ròng rọc thấp của máy cáp, đeo vào mắt cá chân của chân tập, hai tay nắm chắc tay cầm hoặc khung máy để giữ thăng bằng, thân người hơi nghiêng về phía trước, chân trụ hơi khuỵu gối.|Đá chân ra sau: Thở ra và đá chân đeo cáp ra sau, tập trung siết cơ mông, không vung người hoặc dùng quán tính, giữ đầu gối hơi gập nhẹ trong suốt chuyển động.|  Trở về vị trí ban đầu: Hít vào và từ từ đưa chân trở lại vị trí ban đầu, giữ lực kiểm soát để cơ vẫn căng, sau đó lặp lại đủ số lần và đổi chân.',
        'imageUrl': "assets/training/images/Chan.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 10,
        'name': 'Leg Extension',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Codui2.mp4',
        'videoVip': 'assets/training/videos/Chanvip.mp4',
        'description': 'Leg Extension là bài tập cô lập cơ tứ đầu đùi (quadriceps) sử dụng máy, giúp tăng sức mạnh và độ nét cho đùi trước. Đây là một trong những bài tập hiệu quả nhất để phát triển cơ tứ đầu vì nó tập trung hoàn toàn vào nhóm cơ này mà hầu như không có sự hỗ trợ từ các nhóm cơ khác. Bài tập phù hợp để cải thiện sức mạnh phần thân dưới, hỗ trợ hiệu suất cho các động tác squat, lunges hoặc chạy.',
        'note': 'Điều chỉnh ghế và thanh đệm phù hợp với chiều dài chân để tránh chấn thương; không dùng quán tính để nâng tạ; không duỗi chân quá nhanh hoặc khóa gối ở đỉnh; tập trung cảm nhận cơ đùi trước làm việc; chọn mức tạ phù hợp để duy trì kỹ thuật đúng; thở ra khi duỗi chân và hít vào khi hạ xuống.',
        'step': ' Chuẩn bị: Ngồi vào máy Leg Extension, điều chỉnh ghế và thanh đệm sao cho đầu gối ngang với trục xoay của máy, đặt chân dưới thanh đệm sao cho phần cổ chân tiếp xúc, hai tay nắm tay cầm của máy để giữ ổn định.|Bước 2 – Duỗi chân: Thở ra và dùng cơ đùi trước đẩy thanh đệm lên cho đến khi chân gần duỗi thẳng hoàn toàn nhưng không khóa khớp gối, tập trung siết cơ tứ đầu ở đỉnh chuyển động.|Hạ chân: Hít vào và từ từ hạ thanh đệm xuống về vị trí ban đầu, giữ kiểm soát lực để cơ vẫn căng trong suốt quá trình.',
        'imageUrl': "assets/training/images/Chan.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 10,
        'name': 'Dumbbell Hip Thrust',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Dayhong.mp4',
        'videoVip': 'assets/training/videos/Chanvip.mp4',
        'description': 'Dumbbell Hip Thrust là bài tập tác động mạnh vào cơ mông (gluteus maximus) và một phần cơ đùi sau (hamstrings), đồng thời kích hoạt cơ core để giữ ổn định thân người. Đây là bài tập hiệu quả để phát triển sức mạnh và kích thước mông, cải thiện khả năng bùng nổ và hỗ trợ các động tác như squat, deadlift hoặc chạy nước rút. Việc sử dụng tạ đơn đặt trên hông giúp tăng thêm lực cản, từ đó tối ưu kích hoạt cơ.',
        'note': 'Giữ lưng thẳng và cổ ở vị trí trung lập, không ngửa đầu quá mức; không đẩy hông quá cao gây cong lưng; tập trung siết cơ mông ở đỉnh chuyển động; chọn tạ phù hợp để duy trì kỹ thuật chuẩn; thở ra khi nâng hông và hít vào khi hạ xuống; đặt gót chân chắc trên sàn để tối ưu lực từ cơ mông và đùi sau.',
        'step': 'Chuẩn bị: Ngồi trên sàn, lưng tựa vào mép ghế, đặt một tạ đơn ngang hông và giữ chắc bằng hai tay, gập gối và đặt bàn chân phẳng trên sàn, rộng bằng vai.| Nâng hông: Thở ra, đẩy gót chân xuống sàn và nâng hông lên cho đến khi thân người và đùi tạo thành một đường thẳng, siết chặt cơ mông ở đỉnh chuyển động.|Hạ hông: Hít vào, từ từ hạ hông xuống gần sát sàn nhưng không để chạm hẳn, giữ căng cơ liên tục rồi lặp lại động tác.',
        'imageUrl': "assets/training/images/Chan.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 10,
        'name': 'Elliptical Trainer',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Xedap.mp4',
        'videoVip': 'assets/training/videos/Chanvip.mp4',
        'description': 'Elliptical Trainer là bài tập cardio toàn thân sử dụng máy elip, mô phỏng chuyển động đi bộ hoặc chạy nhưng giảm tối đa tác động lên khớp. Bài tập này kích hoạt cả nhóm cơ thân dưới (đùi trước, đùi sau, mông, bắp chân) và thân trên (ngực, vai, tay) khi kết hợp tay cầm di chuyển. Nó giúp tăng sức bền tim mạch, đốt mỡ và cải thiện khả năng vận động nhịp nhàng.',
        'note': 'Giữ trọng tâm cơ thể đều hai chân, tránh dồn lực quá nhiều lên mũi hoặc gót; không nắm tay cầm quá chặt gây căng cơ vai; hít thở đều đặn theo nhịp; khởi động trước và giãn cơ sau khi tập; nếu mới bắt đầu, tập khoảng 10–15 phút rồi tăng dần thời gian và cường độ.',
        'step': 'Chuẩn bị: Đứng lên máy elip, đặt chân lên bàn đạp, tay nắm chắc tay cầm di chuyển hoặc cố định tùy mục tiêu tập.|Bắt đầu chuyển động: Đẩy một chân về phía trước đồng thời kéo tay đối diện về phía sau, mô phỏng động tác chạy nhưng mượt mà và liên tục.|Điều chỉnh: Duy trì tư thế thẳng lưng, mắt nhìn thẳng, vai thả lỏng; điều chỉnh tốc độ và lực cản (resistance) theo mục tiêu (đốt mỡ → nhẹ, nhanh; tăng sức mạnh → nặng, chậm).',
        'imageUrl': "assets/training/images/Chan.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 11,
        'name': 'Dãn cơ',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Danco.mp4',
        'videoVip': 'assets/training/videos/Dancovip.mp4',
        'description': 'Dãn cơ là động tác giãn cơ vai đơn giản, thực hiện bằng cách kéo cánh tay ngang qua ngực để kéo giãn cơ vai sau và cơ xung quanh khớp vai, giúp tăng độ linh hoạt và giảm căng cứng.',
        'note': 'Không nâng vai lên khi kéo giãn. Kéo nhẹ nhàng, tránh giật mạnh để không gây chấn thương. Duy trì hơi thở ổn định trong suốt thời gian giữ tư thế.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, hai chân rộng bằng vai, thả lỏng vai và lưng.|Giãn cơ: Đưa một tay ngang qua ngực, tay còn lại giữ và kéo nhẹ cánh tay đó sát vào ngực để cảm nhận căng ở vai. |  Giữ tư thế: Giữ vị trí kéo giãn 15–30 giây, thở đều, sau đó đổi bên.',
        'imageUrl': "assets/training/images/Danco.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 11,
        'name': 'Diamond Push-up',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Hitdat.mp4',
        'videoVip': 'assets/training/videos/Ngucvip.mp4',
        'description': 'Chống đẩy kim cương là một biến thể của chống đẩy cơ bản, tập trung nhiều hơn vào cơ ngực trong, cơ tam đầu (triceps) và một phần vai trước. Động tác này đòi hỏi sự ổn định cao từ cơ bụng, lưng dưới, và đùi sau, đồng thời giúp phát triển sức mạnh thân trên toàn diện.',
        'note': 'Giữ cơ thể thẳng trong suốt bài tập, không võng lưng hoặc đẩy mông lên cao.Nếu quá khó, bạn có thể chống gối xuống đất để giảm độ nặng.Không hạ ngực quá sâu gây áp lực lên khớp vai.Kiểm soát chuyển động, không để cơ thể rơi tự do.',
        'step': 'Vào tư thế chuẩn bị|Hạ người xuống|Dùng lực đẩy mạnh từ tay và ngực, đưa thân người trở về vị trí ban đầu|Thở ra khi bạn đẩy người lên.',
        'imageUrl': "assets/training/images/Nguc.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 11,
        'name': 'Incline Dumbbell Press',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Nguc1.mp4',
        'videoVip': 'assets/training/videos/Ngucvip.mp4',
        'description': 'Incline Dumbbell Press là bài tập đẩy ngực trên với tạ đơn, giúp phát triển nhóm cơ ngực trên, cơ vai trước và cơ tay sau. So với dùng thanh đòn, tạ đơn cho biên độ chuyển động rộng hơn, tăng khả năng co giãn cơ và cải thiện sự cân đối giữa hai bên cơ thể. Bài tập này phù hợp cho người muốn xây dựng sức mạnh phần thân trên và cải thiện hình dáng ngực.',
        'note': 'Giữ lưng áp sát ghế, không vung tạ, chọn mức tạ phù hợp để kiểm soát tốt cả khi đẩy và hạ, tránh cong lưng hoặc gồng cổ quá mức.',
        'step': 'Tư thế chuẩn bị: Điều chỉnh ghế nghiêng 30–45°, mỗi tay cầm 1 quả tạ đơn, ngả lưng áp sát ghế, tạ ở ngang ngực, lòng bàn tay hướng ra trước.| Hạ tạ: Hít sâu, từ từ hạ tạ xuống cho đến khi khuỷu tay thấp hơn ngực một chút, giữ góc khuỷu tay ổn định và chuyển động có kiểm soát.|Đẩy tạ: Thở ra, đẩy tạ thẳng lên cho đến khi gần chạm nhau, không khóa khớp khuỷu, siết cơ ngực ở đỉnh động tác.',
        'imageUrl': "assets/training/images/Nguc.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 11,
        'name': 'Barbell Bench Press',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Nguc2.mp4',
        'videoVip': 'assets/training/videos/Ngucvip.mp4',
        'description': 'Barbell Bench Press là bài tập đẩy tạ đòn trên ghế phẳng nhằm phát triển sức mạnh và kích thước cơ ngực, đồng thời tác động đến cơ vai trước và cơ tay sau, là một trong những bài tập sức mạnh cơ bản và phổ biến nhất trong tập luyện thể hình.',
        'note': ' Không cong lưng dưới quá mức, không để thanh tạ bật nảy trên ngực, giữ cổ tay thẳng và chắc chắn, kiểm soát tốc độ tạ cả khi đẩy và hạ để tránh chấn thương vai và cổ tay.',
        'step': 'Tư thế chuẩn bị: Nằm ngửa trên ghế phẳng, hai chân đặt vững trên sàn, mắt ở vị trí ngay dưới thanh đòn, tay nắm thanh tạ rộng hơn vai một chút, giữ bả vai ép chặt và lưng áp sát ghế.|Hít sâu, từ từ hạ thanh tạ xuống chạm nhẹ phần giữa ngực, khuỷu tay tạo góc khoảng 45 độ so với thân người, giữ kiểm soát toàn bộ chuyển động.|Đẩy tạ: Thở ra và đẩy thanh tạ thẳng lên cho đến khi tay gần duỗi hết nhưng không khóa khớp, giữ cơ ngực siết chặt ở đỉnh động tác.',
        'imageUrl': "assets/training/images/Nguc.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 11,
        'name': 'Dumbbell Floor Press',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Ngucduoi.mp4',
        'videoVip': 'assets/training/videos/Ngucvip.mp4',
        'description': 'Dumbbell Floor Press là bài đẩy tạ đơn trên sàn giúp phát triển cơ ngực, cơ tay sau và cơ vai trước, đồng thời giảm áp lực lên vai so với bench press, phù hợp cho người tập tại nhà hoặc phục hồi chấn thương vai.',
        'note': 'Giữ cổ tay thẳng, không để tạ rơi tự do, kiểm soát tốc độ cả khi đẩy và hạ, không ưỡn lưng quá mức, chọn mức tạ phù hợp để tránh chấn thương vai.',
        'step': 'Tư thế chuẩn bị: Nằm ngửa trên sàn, gối co, bàn chân đặt vững, mỗi tay cầm một tạ đơn, cánh tay vuông góc với thân, tạ ở ngang ngực, lòng bàn tay hướng ra trước.|Hạ tạ: Hít sâu, từ từ hạ tạ xuống cho đến khi khuỷu tay chạm nhẹ sàn, giữ góc khuỷu tay khoảng 45° so với thân.|Đẩy tạ: Thở ra, đẩy tạ thẳng lên cho đến khi tay gần duỗi hết nhưng không khóa khớp, siết cơ ngực ở đỉnh động tác.',
        'imageUrl': "assets/training/images/Nguc.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 11,
        'name': 'Seated Chest Fly',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Epnguc.mp4',
        'videoVip': 'assets/training/videos/Ngucvip.mp4',
        'description': 'Seated Chest Fly trên máy là bài tập cô lập ngực giữa cực hiệu quả, giúp phát triển chiều rộng và độ nét cơ ngực, đồng thời giảm áp lực lên vai nhờ chuyển động dẫn hướng.',
        'note': 'Không duỗi thẳng khuỷu, không ngả người về trước sau, không dùng lực quán tính, giữ chậm – siết mạnh khi hai tay gần chạm.',
        'step': ' Tư thế chuẩn bị: Ngồi tựa lưng chắc chắn, điều chỉnh tay cầm ngang ngực, hai tay nắm chắc tay đòn, khuỷu hơi cong.| Ép tay vào giữa: Thở ra, dùng lực cơ ngực kéo hai tay lại gần nhau trước ngực, giữ khuỷu tay cố định.| Trở về vị trí ban đầu: Hít vào, từ từ mở tay về vị trí ban đầu, cảm nhận cơ ngực giãn nhẹ.',
        'imageUrl': "assets/training/images/Nguc.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 11,
        'name': 'Rope Overhead Triceps Extension',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Taysau1.mp4',
        'videoVip': 'assets/training/videos/Taysauvip.mp4',
        'description': 'Rope Overhead Triceps Extension là bài tập tay sau sử dụng dây cáp, thực hiện ở tư thế đứng và kéo dây từ phía trên đầu ra trước, giúp phát triển cơ tam đầu tay sau và tăng sức mạnh cánh tay.',
        'note': ': Giữ cổ tay thẳng, không để tạ rơi tự do, kiểm soát tốc độ cả khi đẩy và hạ, không ưỡn lưng quá mức, chọn mức tạ phù hợp để tránh chấn thương vai.',
        'step': 'Tư thế chuẩn bị: Gắn dây rope vào ròng rọc cao, đứng quay lưng về máy, hai tay nắm hai đầu dây, bước một chân lên trước để giữ thăng bằng, tay gập ở góc 90° trước trán, cùi chỏ hướng về trước.| Duỗi tay: Thở ra, dùng lực cơ tay sau đẩy dây về phía trước và xuống dưới cho đến khi tay duỗi thẳng, cảm nhận sự co của cơ tam đầu.|Quay lại vị trí ban đầu: Hít vào, từ từ gập tay lại, đưa dây trở về vị trí ban đầu, kiểm soát toàn bộ chuyển động.',
        'imageUrl': "assets/training/images/Tay.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 11,
        'name': 'One-Arm Dumbbell Overhead Triceps Extension',
        'sets': 3,
        'reps': 15,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Taysau2.mp4',
        'videoVip': 'assets/training/videos/Taysauvip.mp4',
        'description': 'One-Arm Dumbbell Overhead Triceps Extension là bài tập tay sau sử dụng tạ đơn, thực hiện một tay, giúp cô lập và phát triển cơ tam đầu, đồng thời cải thiện sức mạnh và độ linh hoạt của khớp vai.',
        'note': 'Không vung tạ hoặc dùng lực quán tính.Giữ lưng thẳng, core siết chặt để tránh nghiêng người.Chọn mức tạ vừa phải để đảm bảo form chuẩn và tránh chấn thương vai hoặc khuỷu tay.',
        'step': 'Tư thế chuẩn bị: Đứng thẳng, chân rộng bằng vai, một tay cầm tạ đưa lên cao, cùi chỏ hướng lên, tay còn lại chống hông hoặc giữ cùi chỏ.|  Hạ tạ: Hít vào, gập cùi chỏ hạ tạ xuống sau đầu, giữ cánh tay trên cố định.| Duỗi tay: Thở ra, duỗi thẳng tay đưa tạ về vị trí ban đầu và lặp lại.',
        'imageUrl': "assets/training/images/Tay.png",
      });


      //Day2
      await db.insert('exercise', {
        'day_id': 15*i+ 12,
        'name': 'Dãn cơ',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Danco.mp4',
        'videoVip': 'assets/training/videos/Dancovip.mp4',
        'description': 'Dãn cơ là động tác giãn cơ vai đơn giản, thực hiện bằng cách kéo cánh tay ngang qua ngực để kéo giãn cơ vai sau và cơ xung quanh khớp vai, giúp tăng độ linh hoạt và giảm căng cứng.',
        'note': 'Không nâng vai lên khi kéo giãn. Kéo nhẹ nhàng, tránh giật mạnh để không gây chấn thương. Duy trì hơi thở ổn định trong suốt thời gian giữ tư thế.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, hai chân rộng bằng vai, thả lỏng vai và lưng.|Giãn cơ: Đưa một tay ngang qua ngực, tay còn lại giữ và kéo nhẹ cánh tay đó sát vào ngực để cảm nhận căng ở vai. |  Giữ tư thế: Giữ vị trí kéo giãn 15–30 giây, thở đều, sau đó đổi bên.',
        'imageUrl': "assets/training/images/Danco.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 12,
        'name': 'Dumbbell Side Lateral Raise Behind Back',
        'sets': 3,
        'reps': 20,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Vaitruoc.mp4',
        'videoVip': 'assets/training/videos/Vaivip.mp4',
        'description': 'Dumbbell Side Lateral Raise Behind Back là biến thể của bài nâng tạ ngang tay, thực hiện với tạ đơn ở phía sau cơ thể, giúp tác động sâu vào cơ vai giữa và vai sau, đồng thời cải thiện độ linh hoạt khớp vai.',
        'note': 'Không đung đưa người, giữ lưng thẳng, chọn mức tạ vừa sức để duy trì kỹ thuật chuẩn.',
        'step': 'Tư thế chuẩn bị: Đứng thẳng, chân rộng bằng vai, một tay cầm tạ đơn đặt ở phía sau hông, lòng bàn tay hướng vào trong.| Nâng tạ: Hít vào, từ từ nâng tay sang ngang đến ngang vai, giữ thẳng cánh tay.|Hạ tạ: Thở ra, hạ tạ trở về vị trí ban đầu một cách kiểm soát, lặp lại rồi đổi tay.',
        'imageUrl': "assets/training/images/Vai.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 12,
        'name': 'Incline Bench Reverse Fly',
        'sets': 3,
        'reps': 20,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Vaitruoc1.mp4',
        'videoVip': 'assets/training/videos/Vaivip.mp4',
        'description': 'Incline Bench Reverse Fly là bài tập vai sau và lưng trên, thực hiện khi nằm sấp trên ghế dốc với tạ đơn, giúp phát triển cơ vai sau, cơ xô và cơ thang, đồng thời cải thiện tư thế và sức mạnh phần lưng trên.',
        'note': 'Giữ lưng và cổ thẳng, không nhún vai quá mức, tránh dùng lực quán tính, chọn mức tạ vừa sức để duy trì kỹ thuật.',
        'step': ' Tư thế chuẩn bị: Nằm sấp trên ghế dốc, ngực áp sát ghế, hai tay cầm tạ đơn duỗi thẳng xuống, lòng bàn tay hướng vào nhau.|Nâng tạ: Hít vào, nâng hai tay sang ngang đến ngang vai, khuỷu tay hơi cong, siết cơ vai sau.|Hạ tạ: Thở ra, hạ tạ chậm và có kiểm soát về vị trí ban đầu, lặp lại.',
        'imageUrl': "assets/training/images/Vai.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 12,
        'name': 'Incline Bench Dumbbell Shrug',
        'sets': 3,
        'reps': 20,
        'duration': 15,
        'videoUrl': 'assets/training/videos/Cauvai.mp4',
        'videoVip': 'assets/training/videos/Vaivip.mp4',
        'description': 'Incline Bench Dumbbell Shrug là bài tập cô lập cơ cầu vai, giúp phát triển phần cơ trap trên hiệu quả mà không gây căng lưng dưới như các bài shrug đứng thông thường.',
        'note': 'Giữ lưng và cổ thẳng, không nhún vai quá mức, tránh dùng lực quán tính, chọn mức tạ vừa sức để duy trì kỹ thuật.',
        'step': '  Tư thế chuẩn bị: Nằm úp người lên ghế nghiêng (incline), hai tay giữ tạ thả lỏng hướng thẳng xuống đất, vai không gồng.| Nâng vai: Thở ra, gồng cơ cầu vai và kéo vai lên hướng về tai, giữ khuỷu tay thẳng, không co tay.| Trở về vị trí ban đầu: Hít vào, từ từ hạ vai xuống vị trí ban đầu, cảm nhận cơ giãn.',
        'imageUrl': "assets/training/images/Vai.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 12,
        'name': 'Machine Shoulder Press',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Vaitren.mp4',
        'videoVip': 'assets/training/videos/Vaivip.mp4',
        'description': 'Machine Shoulder Press là bài đẩy vai sử dụng máy, giúp tập trung phát triển cơ vai trước và vai giữa, đồng thời hỗ trợ ổn định khớp vai nhờ chuyển động dẫn hướng cố định.',
        'note': 'Giữ lưng áp sát ghế, không nhún vai quá mức, tránh dùng quán tính, điều chỉnh ghế sao cho tay cầm ngang vai khi bắt đầu.',
        'step': ' Tư thế chuẩn bị: Ngồi trên ghế máy, lưng tựa thẳng, hai tay nắm tay cầm ở ngang vai, lòng bàn tay hướng về phía trước.|Đẩy tạ: Hít vào, đẩy tay cầm lên cao đến khi tay gần duỗi thẳng, không khóa khớp.|Hạ tạ: Thở ra, hạ tay cầm chậm về vị trí ban đầu, kiểm soát toàn bộ chuyển động.',
        'imageUrl': "assets/training/images/Vai.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 12,
        'name': 'Cable One Arm Reverse Curl',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Taytruoc1.mp4',
        'videoVip': 'assets/training/videos/Taytruocvip.mp4',
        'description': 'Cable One Arm Reverse Curl là bài cuốn tạ ngược một tay với cáp, tập trung vào cơ cẳng tay và cơ tay trước, giúp tăng sức mạnh và độ săn chắc cẳng tay.',
        'note': 'Không vung tay, giữ lưng thẳng, thực hiện chậm và kiểm soát để tối đa tác động lên cơ cẳng tay.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, quay mặt về phía máy kéo cáp, tay cầm thanh hoặc tay cầm đơn ở vị trí thấp, lòng bàn tay hướng xuống, khuỷu tay sát thân người.| Cuốn tạ: Hít vào, cuốn tay lên phía trước đến khi cẳng tay vuông góc với sàn, giữ cổ tay thẳng.|Hạ tạ: Thở ra, từ từ hạ tay trở về vị trí ban đầu, kiểm soát toàn bộ chuyển động.',
        'imageUrl': "assets/training/images/Tay.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 12,
        'name': 'Incline Bench Kettlebell Curl',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Taytruoc2.mp4',
        'videoVip': 'assets/training/videos/Taytruocvip.mp4',
        'description': 'Cable One Arm Reverse Curl là bài cuốn tạ ngược một tay với cáp, tập trung vào cơ cẳng tay và cơ tay trước, giúp tăng sức mạnh và độ săn chắc cẳng tay.',
        'note': 'Giữ lưng và ngực áp sát ghế để cô lập cơ tay trước. Không vung tạ hoặc sử dụng lực quán tính. Chọn mức tạ phù hợp để duy trì kỹ thuật chuẩn suốt bài tập.',
        'step': ' Tư thế chuẩn bị: Điều chỉnh ghế nghiêng khoảng 45°, đứng hoặc quỳ phía sau ghế, tỳ ngực vào phần tựa, một tay cầm tạ ấm với lòng bàn tay hướng ra trước, tay duỗi thẳng xuống.| Cuốn tạ: Hít vào, gập khuỷu tay để nâng tạ lên gần vai, giữ cố định phần cánh tay trên, chỉ di chuyển cẳng tay.| Hạ tạ: Thở ra, từ từ hạ tạ trở lại vị trí ban đầu, kiểm soát tốc độ để tránh mất form.',
        'imageUrl': "assets/training/images/Tay.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 12,
        'name': 'Incline Bench Kettlebell Curl',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Cangtay.mp4',
        'videoVip': 'assets/training/videos/Taytruocvip.mp4',
        'description': 'Concentration Curl là một trong những bài tập cô lập cơ tay trước (biceps) hiệu quả nhất. Với tư thế ngồi và cánh tay được cố định trên đùi, bài tập giúp loại bỏ sự hỗ trợ từ các nhóm cơ khác, từ đó tập trung hoàn toàn vào việc kích hoạt cơ nhị đầu. Đây là bài tập lý tưởng để tạo độ nét và sự phân tách rõ ràng ở bắp tay, đồng thời giúp cải thiện sự kết nối tâm trí–cơ bắp trong quá trình luyện tập.',
        'note': ' Giữ thân người cố định, không nhấc khuỷu tay khỏi đùi, tránh đung đưa vai hay lưng; tập trung siết cơ bắp tay suốt quá trình thực hiện.',
        'step': ' Tư thế chuẩn bị: Ngồi trên ghế phẳng, chân dang rộng, tay cầm tạ đơn, tỳ khuỷu tay lên mặt trong của đùi cùng bên, tay còn lại đặt trên đùi còn lại để giữ thăng bằng.|  Gập tay: Thở ra, cuốn tạ lên từ từ bằng lực cơ tay trước, không vung tạ hoặc dùng quán tính.| Trở về vị trí ban đầu: Hít vào, từ từ hạ tạ xuống đến khi tay gần duỗi thẳng (không thả rơi tạ), giữ cơ luôn căng.',
        'imageUrl': "assets/training/images/Tay.png",
      });
      //Day3

      await db.insert('exercise', {
        'day_id': 15*i+ 13,
        'name': 'Dãn cơ',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Danco.mp4',
        'videoVip': 'assets/training/videos/Dancovip.mp4',
        'description': 'Dãn cơ là động tác giãn cơ vai đơn giản, thực hiện bằng cách kéo cánh tay ngang qua ngực để kéo giãn cơ vai sau và cơ xung quanh khớp vai, giúp tăng độ linh hoạt và giảm căng cứng.',
        'note': 'Không nâng vai lên khi kéo giãn. Kéo nhẹ nhàng, tránh giật mạnh để không gây chấn thương. Duy trì hơi thở ổn định trong suốt thời gian giữ tư thế.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, hai chân rộng bằng vai, thả lỏng vai và lưng.|Giãn cơ: Đưa một tay ngang qua ngực, tay còn lại giữ và kéo nhẹ cánh tay đó sát vào ngực để cảm nhận căng ở vai. |  Giữ tư thế: Giữ vị trí kéo giãn 15–30 giây, thở đều, sau đó đổi bên.',
        'imageUrl': "assets/training/images/Danco.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 13,
        'name': 'Lat & Upper Back Stretch on SkiErg',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Lat1.mp4',
        'videoVip': 'assets/training/videos/Lungvip.mp4',
        'description': 'Lat & Upper Back Stretch on SkiErg là động tác giãn cơ lưng và vai được thực hiện với máy SkiErg, giúp kéo giãn cơ xô (Latissimus dorsi), cơ lưng giữa và cơ vai sau, cải thiện độ linh hoạt phần thân trên.',
        'note': 'Giữ lưng thẳng, không cong lưng quá mức. Không khóa khớp khuỷu tay, thả lỏng vai để tăng hiệu quả kéo giãn. Có thể thực hiện động tác này với thanh cố định hoặc dây kháng lực nếu không có máy SkiErg.',
        'step': ' Tư thế chuẩn bị: Đứng đối diện máy SkiErg, hai chân rộng bằng vai, tay nắm chặt tay cầm, hơi gập gối.| Giãn cơ: Đẩy hông ra sau, gập người về trước, giữ cánh tay thẳng và cảm nhận sự kéo giãn ở lưng và vai.| Giữ tư thế: Giữ vị trí này 20–30 giây, thở sâu và đều, sau đó từ từ trở lại vị trí ban đầu.',
        'imageUrl': "assets/training/images/Lung.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 13,
        'name': ' Straight-Arm Cable Pulldown',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Lat2.mp4',
        'videoVip': 'assets/training/videos/Lungvip.mp4',
        'description': 'Straight-Arm Cable Pulldown là bài kéo xô với tay duỗi thẳng, sử dụng dây cáp, giúp cô lập và phát triển cơ xô (latissimus dorsi) hiệu quả, đặc biệt là phần cơ lưng rộng dưới, đồng thời hỗ trợ cải thiện khả năng kiểm soát chuyển động tay trong các bài tập kéo khác như pull-up, lat pulldown.',
        'note': 'Giữ tay luôn duỗi thẳng, tránh dùng quán tính hay gập khuỷu tay; siết cơ bụng và giữ lưng thẳng trong suốt chuyển động để cô lập tốt cơ lưng.',
        'step': 'Tư thế chuẩn bị: Đứng hơi cúi người, tay nắm thanh cáp cao, tay duỗi thẳng, lưng giữ thẳng. |Kéo thanh cáp: Kéo thanh cáp xuống gần đùi theo vòng cung, siết cơ xô, tay vẫn duỗi thẳng. | Trả về vị trí ban đầu:Đưa cáp trở lại chậm rãi, kiểm soát lực, giữ căng liên tục lên cơ lưng.',
        'imageUrl': "assets/training/images/Lung.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 13,
        'name': 'Kettlebell Bent-Over Row',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Lungduoi.mp4',
        'videoVip': 'assets/training/videos/Lungvip.mp4',
        'description': 'Kettlebell Bent-Over Row là bài tập kéo tạ chuông khi người cúi về phía trước, giúp phát triển sức mạnh và độ dày cho cơ lưng giữa, đồng thời cải thiện tư thế và khả năng giữ thăng bằng của thân trên. Bài tập này phù hợp để cô lập cơ lưng với mức tạ vừa phải, hỗ trợ tốt cho các bài tập kéo lớn như deadlift hoặc pull-up.',
        'note': 'Giữ lưng luôn thẳng, không cong lưng hay ngửa đầu quá mức; tránh dùng đà hông để kéo tạ; tập trung vào cơ lưng thay vì tay; kiểm soát chuyển động để đạt hiệu quả tối đa và tránh chấn thương.',
        'step': ' Đứng hai chân rộng bằng vai, mỗi tay cầm một quả tạ chuông, cúi người về phía trước đến khi thân trên gần song song sàn, lưng giữ thẳng, mắt nhìn xuống sàn, tay duỗi thẳng tự nhiên.| Hít vào, kéo hai tay cầm tạ lên phía eo bằng cách siết cơ lưng và gập khuỷu tay về sau. Giữ khuỷu tay gần thân người khi kéo.|Thở ra, từ từ hạ tạ trở lại vị trí ban đầu, giữ lưng thẳng và kiểm soát toàn bộ chuyển động. ',
        'imageUrl': "assets/training/images/Lung.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 13,
        'name': 'Dumbbell One-Arm Row',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Trap1.mp4',
        'videoVip': 'assets/training/videos/Lungvip.mp4',
        'description': 'Dumbbell One-Arm Row là bài tập kéo tạ đơn bằng một tay, thường thực hiện với ghế hoặc tư thế chống đùi như hình. Bài tập giúp tăng cường cơ lưng giữa và lưng xô, hỗ trợ cải thiện độ dày lưng, phát triển cơ đối xứng và tăng khả năng kiểm soát thân trên.',
        'note': 'Giữ lưng luôn thẳng, không cong lưng hay ngửa đầu quá mức; tránh dùng đà hông để kéo tạ; tập trung vào cơ lưng thay vì tay; kiểm soát chuyển động để đạt hiệu quả tối đa và tránh chấn thương.',
        'step': ' Đứng hai chân rộng, một tay tựa lên đùi hoặc ghế, tay còn lại cầm tạ đơn, thân người cúi về phía trước, lưng thẳng, mắt nhìn xuống và tay cầm tạ duỗi thẳng dưới vai.| Hít vào, kéo tạ lên ngang eo bằng cách gập khuỷu tay về sau, giữ khuỷu tay sát thân và siết chặt cơ lưng ở điểm cao nhất.|Thở ra, từ từ hạ tạ xuống vị trí ban đầu, kiểm soát chuyển động để giữ căng thẳng lên cơ mục tiêu.  ',
        'imageUrl': "assets/training/images/Lung.png",
      });

      //Day4

      await db.insert('exercise', {
        'day_id': 15*i+ 14,
        'name': 'Dãn cơ',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Danco.mp4',
        'videoVip': 'assets/training/videos/Dancovip.mp4',
        'description': 'Dãn cơ là động tác giãn cơ vai đơn giản, thực hiện bằng cách kéo cánh tay ngang qua ngực để kéo giãn cơ vai sau và cơ xung quanh khớp vai, giúp tăng độ linh hoạt và giảm căng cứng.',
        'note': 'Không nâng vai lên khi kéo giãn. Kéo nhẹ nhàng, tránh giật mạnh để không gây chấn thương. Duy trì hơi thở ổn định trong suốt thời gian giữ tư thế.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, hai chân rộng bằng vai, thả lỏng vai và lưng.|Giãn cơ: Đưa một tay ngang qua ngực, tay còn lại giữ và kéo nhẹ cánh tay đó sát vào ngực để cảm nhận căng ở vai. |  Giữ tư thế: Giữ vị trí kéo giãn 15–30 giây, thở đều, sau đó đổi bên.',
        'imageUrl': "assets/training/images/Danco.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 14,
        'name': 'Cable Crunch',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Gapbung1.mp4',
        'videoVip': 'assets/training/videos/Bungvip.mp4',
        'description': 'Cable Crunch là bài tập bụng sử dụng máy kéo cáp, tập trung vào cơ bụng giữa và bụng dưới. Nhờ chuyển động gập thân có kiểm soát dưới lực cản của dây cáp, bài tập giúp siết cơ bụng sâu và hiệu quả hơn các động tác gập bụng thông thường.',
        'note': 'Không dùng tay để kéo dây, chuyển động phải do cơ bụng điều khiển. Giữ hông cố định, tránh nhấc hông hoặc đẩy người ra sau. Gập người có kiểm soát, không dùng quán tính, siết bụng ở điểm cuối chuyển động.',
        'step': ' Gắn dây thừng vào ròng rọc cao. Quỳ xuống trước máy, hai tay nắm hai đầu dây, đặt gần hai bên đầu (sát tai), lưng giữ thẳng tự nhiên, đầu hơi cúi.| Thở ra, siết cơ bụng, gập người về phía trước bằng cách cuộn phần thân trên xuống dưới, kéo dây theo chuyển động tự nhiên. Giữ hông cố định, chỉ chuyển động ở thân trên.| Hít vào, từ từ nâng thân trên trở về tư thế ban đầu nhưng không để cơ bụng mất căng.',
        'imageUrl': "assets/training/images/Bung.png",
      });



      await db.insert('exercise', {
        'day_id': 15*i+ 14,
        'name': 'Standing Dumbbell Side Bend',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Gapnguoi1.mp4',
        'videoVip': 'assets/training/videos/Bungvip.mp4',
        'description': 'Standing Dumbbell Side Bend là bài tập tác động trực tiếp đến cơ liên sườn – nhóm cơ hai bên bụng. Với tạ đơn hoặc đĩa tạ nâng qua đầu, bài tập giúp tăng sức mạnh cơ bụng bên, cải thiện độ linh hoạt cột sống và tạo đường cong eo rõ nét.',
        'note': 'Không nghiêng ra sau hay đẩy hông sang bên. Luôn giữ bụng căng và lưng thẳng trong suốt bài tập. Thực hiện chậm và có kiểm soát để tránh chấn thương cột sống.',
        'step': ' Đứng thẳng, hai chân rộng bằng vai. Hai tay giữ tạ đơn bằng cả hai tay, nâng cao qua đầu, khuỷu tay duỗi nhẹ. Giữ thân người ổn định, siết nhẹ cơ bụng.|Thở ra, nghiêng thân trên sang một bên (ví dụ: bên trái), cảm nhận cơ liên sườn bên đối diện bị kéo giãn. Hông và chân giữ nguyên, không nghiêng hoặc xoay. |Hít vào, từ từ đưa thân trên trở về vị trí trung lập. Sau đó lặp lại với bên còn lại. ',
        'imageUrl': "assets/training/images/Bung.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 14,
        'name': 'Crunch',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Gapnguoi2.mp4',
        'videoVip': 'assets/training/videos/Bungvip.mp4',
        'description': 'Crunch là bài tập bụng cơ bản, hiệu quả cao, thường dùng để kích hoạt và phát triển cơ bụng thẳng. Hình minh họa cho thấy tư thế chuẩn, giúp tối ưu hiệu quả và giảm nguy cơ chấn thương cổ/lưng.',
        'note': 'Không kéo cổ, không dùng đà, lưng dưới luôn chạm sàn, cằm không ép ngực.',
        'step': ' Tư thế chuẩn bị: Nằm ngửa, co gối, bàn chân đặt sàn, tay đặt sau đầu không kéo cổ.| Gập bụng: Thở ra, nâng vai khỏi sàn, siết bụng, không nhấc lưng dưới.| Trở lại vị trí ban đầu: Hít vào, từ từ hạ vai, giữ mắt nhìn lên, cổ thẳng.',
        'imageUrl': "assets/training/images/Bung.png",
      });
      await db.insert('exercise', {
        'day_id': 15*i+ 14,
        'name': 'Side Bend',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Coliensuon2.mp4',
        'videoVip': 'assets/training/videos/Bungvip.mp4',
        'description': 'Side Bend là bài tập hiệu quả giúp siết chặt và phát triển cơ liên sườn, cải thiện vóc dáng eo và thân trên cân đối.',
        'note': 'Không xoay thân khi nghiêng, giữ lưng thẳng, không dùng đà, chuyển động chậm và kiểm soát, tránh nghiêng quá sâu gây căng lưng.',
        'step': '  Tư thế chuẩn bị: Đứng thẳng, 1 tay cầm tạ buông dọc thân, tay kia đặt nhẹ sau đầu hoặc hông.| Nghiêng người: Thở ra, nghiêng thân sang bên cầm tạ, cảm nhận cơ liên sườn co lại.| Trở lại: Hít vào, từ từ kéo người thẳng lại, siết bụng, lặp lại đủ số reps rồi đổi bên.',
        'imageUrl': "assets/training/images/Bung.png",
      });

      //Day5
      await db.insert('exercise', {
        'day_id': 15*i+ 15,
        'name': 'Dãn cơ',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Danco.mp4',
        'videoVip': 'assets/training/videos/Dancovip.mp4',
        'description': 'Dãn cơ là động tác giãn cơ vai đơn giản, thực hiện bằng cách kéo cánh tay ngang qua ngực để kéo giãn cơ vai sau và cơ xung quanh khớp vai, giúp tăng độ linh hoạt và giảm căng cứng.',
        'note': 'Không nâng vai lên khi kéo giãn. Kéo nhẹ nhàng, tránh giật mạnh để không gây chấn thương. Duy trì hơi thở ổn định trong suốt thời gian giữ tư thế.',
        'step': ' Tư thế chuẩn bị: Đứng thẳng, hai chân rộng bằng vai, thả lỏng vai và lưng.|Giãn cơ: Đưa một tay ngang qua ngực, tay còn lại giữ và kéo nhẹ cánh tay đó sát vào ngực để cảm nhận căng ở vai. |  Giữ tư thế: Giữ vị trí kéo giãn 15–30 giây, thở đều, sau đó đổi bên.',
        'imageUrl': "assets/training/images/Danco.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 15,
        'name': 'Treadmill Running',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Chaybo.mp4',
        'videoVip': 'assets/training/videos/Chanvip.mp4',
        'description': 'Chạy bộ trên máy chạy (Treadmill Running) là bài tập cardio giúp nâng cao sức bền tim mạch, đốt cháy calo và cải thiện sức khỏe tổng thể. Bài tập này kích hoạt nhiều nhóm cơ cùng lúc, bao gồm cơ chân (đùi trước, đùi sau, bắp chân), cơ mông, cơ core (bụng, lưng dưới) và một phần cơ tay khi đánh tay. Chạy trên máy còn cho phép điều chỉnh tốc độ, độ dốc để phù hợp với mục tiêu luyện tập, giảm áp lực lên khớp so với chạy ngoài trời trên mặt đường cứng.',
        'note': 'Giữ tư thế chuẩn, không ngửa hoặc cúi người quá mức và luôn giữ lưng thẳng; thở đều và sâu để duy trì sức bền; nếu mới tập hãy bắt đầu với tốc độ thấp trước khi tăng tốc; không nhìn xuống chân để tránh mất thăng bằng; mang giày chạy bộ có độ đàn hồi và hỗ trợ tốt; luôn kẹp khóa an toàn của máy chạy vào quần áo để máy tự dừng nếu bị ngã.',
        'step': ' Chuẩn bị: Đứng thẳng trên hai bên thành máy chạy (không đặt chân lên băng tải khi máy đang chạy), bật máy và chọn tốc độ khởi động chậm (2–4 km/h), bước chân lên băng tải khi đã sẵn sàng.| Chạy: Giữ dáng người thẳng, mắt nhìn về phía trước, đánh tay tự nhiên theo nhịp chân (góc khuỷu tay khoảng 90°), bước chân nhẹ tiếp đất bằng phần giữa bàn chân hoặc gót rồi lăn ra mũi chân, tăng dần tốc độ và/hoặc độ dốc nếu muốn tăng độ khó.| Kết thúc: Giảm dần tốc độ về mức đi bộ để hồi phục (cool-down) trong 3–5 phút, dừng máy hoàn toàn trước khi bước xuống.',
        'imageUrl': "assets/training/images/Chan.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 15,
        'name': 'Cable Kickback',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Codui1.mp4',
        'videoVip': 'assets/training/videos/Chanvip.mp4',
        'description': 'Cable Kickback là bài tập cô lập cơ mông (gluteus maximus) và một phần cơ đùi sau (hamstrings) bằng cách dùng máy cáp để tạo lực cản trong chuyển động đá chân ra sau. Bài tập này giúp làm săn chắc, nâng mông, cải thiện sức mạnh hông và hỗ trợ các bài tập sức mạnh khác như squat hay deadlift. Nhờ lực căng liên tục từ dây cáp, cơ mông được kích hoạt đều trong cả pha kéo và hạ chân.',
        'note': 'Giữ thân người cố định, không cong lưng quá mức; tập trung siết cơ mông ở đỉnh chuyển động; không đá chân quá cao gây mất kiểm soát; chọn mức tạ vừa phải để đảm bảo đúng kỹ thuật; thở ra khi đá chân và hít vào khi hạ chân; luôn giữ căng cơ liên tục trong suốt bài tập để đạt hiệu quả tối đa.',
        'step': 'Chuẩn bị: Gắn dây đeo cổ chân vào ròng rọc thấp của máy cáp, đeo vào mắt cá chân của chân tập, hai tay nắm chắc tay cầm hoặc khung máy để giữ thăng bằng, thân người hơi nghiêng về phía trước, chân trụ hơi khuỵu gối.|Đá chân ra sau: Thở ra và đá chân đeo cáp ra sau, tập trung siết cơ mông, không vung người hoặc dùng quán tính, giữ đầu gối hơi gập nhẹ trong suốt chuyển động.|  Trở về vị trí ban đầu: Hít vào và từ từ đưa chân trở lại vị trí ban đầu, giữ lực kiểm soát để cơ vẫn căng, sau đó lặp lại đủ số lần và đổi chân.',
        'imageUrl': "assets/training/images/Chan.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 15,
        'name': 'Leg Extension',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Codui2.mp4',
        'videoVip': 'assets/training/videos/Chanvip.mp4',
        'description': 'Leg Extension là bài tập cô lập cơ tứ đầu đùi (quadriceps) sử dụng máy, giúp tăng sức mạnh và độ nét cho đùi trước. Đây là một trong những bài tập hiệu quả nhất để phát triển cơ tứ đầu vì nó tập trung hoàn toàn vào nhóm cơ này mà hầu như không có sự hỗ trợ từ các nhóm cơ khác. Bài tập phù hợp để cải thiện sức mạnh phần thân dưới, hỗ trợ hiệu suất cho các động tác squat, lunges hoặc chạy.',
        'note': 'Điều chỉnh ghế và thanh đệm phù hợp với chiều dài chân để tránh chấn thương; không dùng quán tính để nâng tạ; không duỗi chân quá nhanh hoặc khóa gối ở đỉnh; tập trung cảm nhận cơ đùi trước làm việc; chọn mức tạ phù hợp để duy trì kỹ thuật đúng; thở ra khi duỗi chân và hít vào khi hạ xuống.',
        'step': ' Chuẩn bị: Ngồi vào máy Leg Extension, điều chỉnh ghế và thanh đệm sao cho đầu gối ngang với trục xoay của máy, đặt chân dưới thanh đệm sao cho phần cổ chân tiếp xúc, hai tay nắm tay cầm của máy để giữ ổn định.|Bước 2 – Duỗi chân: Thở ra và dùng cơ đùi trước đẩy thanh đệm lên cho đến khi chân gần duỗi thẳng hoàn toàn nhưng không khóa khớp gối, tập trung siết cơ tứ đầu ở đỉnh chuyển động.|Hạ chân: Hít vào và từ từ hạ thanh đệm xuống về vị trí ban đầu, giữ kiểm soát lực để cơ vẫn căng trong suốt quá trình.',
        'imageUrl': "assets/training/images/Chan.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 15,
        'name': 'Dumbbell Hip Thrust',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Dayhong.mp4',
        'videoVip': 'assets/training/videos/Chanvip.mp4',
        'description': 'Dumbbell Hip Thrust là bài tập tác động mạnh vào cơ mông (gluteus maximus) và một phần cơ đùi sau (hamstrings), đồng thời kích hoạt cơ core để giữ ổn định thân người. Đây là bài tập hiệu quả để phát triển sức mạnh và kích thước mông, cải thiện khả năng bùng nổ và hỗ trợ các động tác như squat, deadlift hoặc chạy nước rút. Việc sử dụng tạ đơn đặt trên hông giúp tăng thêm lực cản, từ đó tối ưu kích hoạt cơ.',
        'note': 'Giữ lưng thẳng và cổ ở vị trí trung lập, không ngửa đầu quá mức; không đẩy hông quá cao gây cong lưng; tập trung siết cơ mông ở đỉnh chuyển động; chọn tạ phù hợp để duy trì kỹ thuật chuẩn; thở ra khi nâng hông và hít vào khi hạ xuống; đặt gót chân chắc trên sàn để tối ưu lực từ cơ mông và đùi sau.',
        'step': 'Chuẩn bị: Ngồi trên sàn, lưng tựa vào mép ghế, đặt một tạ đơn ngang hông và giữ chắc bằng hai tay, gập gối và đặt bàn chân phẳng trên sàn, rộng bằng vai.| Nâng hông: Thở ra, đẩy gót chân xuống sàn và nâng hông lên cho đến khi thân người và đùi tạo thành một đường thẳng, siết chặt cơ mông ở đỉnh chuyển động.|Hạ hông: Hít vào, từ từ hạ hông xuống gần sát sàn nhưng không để chạm hẳn, giữ căng cơ liên tục rồi lặp lại động tác.',
        'imageUrl': "assets/training/images/Chan.png",
      });

      await db.insert('exercise', {
        'day_id': 15*i+ 15,
        'name': 'Elliptical Trainer',
        'sets': 3,
        'reps': 20,
        'duration': 0,
        'videoUrl': 'assets/training/videos/Xedap.mp4',
        'videoVip': 'assets/training/videos/Chanvip.mp4',
        'description': 'Elliptical Trainer là bài tập cardio toàn thân sử dụng máy elip, mô phỏng chuyển động đi bộ hoặc chạy nhưng giảm tối đa tác động lên khớp. Bài tập này kích hoạt cả nhóm cơ thân dưới (đùi trước, đùi sau, mông, bắp chân) và thân trên (ngực, vai, tay) khi kết hợp tay cầm di chuyển. Nó giúp tăng sức bền tim mạch, đốt mỡ và cải thiện khả năng vận động nhịp nhàng.',
        'note': 'Giữ trọng tâm cơ thể đều hai chân, tránh dồn lực quá nhiều lên mũi hoặc gót; không nắm tay cầm quá chặt gây căng cơ vai; hít thở đều đặn theo nhịp; khởi động trước và giãn cơ sau khi tập; nếu mới bắt đầu, tập khoảng 10–15 phút rồi tăng dần thời gian và cường độ.',
        'step': 'Chuẩn bị: Đứng lên máy elip, đặt chân lên bàn đạp, tay nắm chắc tay cầm di chuyển hoặc cố định tùy mục tiêu tập.|Bắt đầu chuyển động: Đẩy một chân về phía trước đồng thời kéo tay đối diện về phía sau, mô phỏng động tác chạy nhưng mượt mà và liên tục.|Điều chỉnh: Duy trì tư thế thẳng lưng, mắt nhìn thẳng, vai thả lỏng; điều chỉnh tốc độ và lực cản (resistance) theo mục tiêu (đốt mỡ → nhẹ, nhanh; tăng sức mạnh → nặng, chậm).',
        'imageUrl': "assets/training/images/Chan.png",
      });
    }
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

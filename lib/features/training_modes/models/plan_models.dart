class WorkoutPlan {
  int? id;
  String title;
  String description;
  String gender;
  String location;
  String type; // ví dụ "muscle_gain", "fat_loss"

  WorkoutPlan({
    this.id,
    required this.title,
    required this.description,
    required this.gender,
    required this.location,
    required this.type,
  });


  factory WorkoutPlan.fromMap(Map<String, dynamic> map) {
    return WorkoutPlan(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      gender: map['gender'],
      location: map['location'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'gender': gender,
      'location': location,
      'type': type,
    };
  }
}

class WorkoutDay {
  int? id;
  int planId;
  int day;
  // string type;   // nhóm cơ tập trong này đó


  WorkoutDay({
    this.id,
    required this.planId,
    required this.day,
  });

  factory WorkoutDay.fromMap(Map<String, dynamic> map) {
    return WorkoutDay(
      id: map['id'],
      planId: map['plan_id'],
      day: map['day'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plan_id': planId,
      'day': day,
    };
  }
}



class Exercise {
  int? id;
  int dayId;                        // ID của ngày tập chứa bài tập này
  String name;                     // Tên bài tập
  int sets;                        // Số hiệp
  int reps;                        // Số lần mỗi hiệp
  int duration;                    // Thời lượng bài tập (nếu là bài tập theo thời gian), đơn vị: giây
  String videoUrl;                 // Đường dẫn video minh họa
  String videoVip;
  String description;              // Mô tả chi tiết bài tập
  String note;                     // Cảnh báo hoặc lời khuyên
  List<String> step;              // Các bước thực hiện bài tập
  String imageUrl;                 // Đường dẫn hình ảnh minh họa

  Exercise({
    this.id,
    required this.dayId,
    required this.name,
    required this.sets,
    required this.reps,
    required this.duration,
    required this.videoUrl,
    required this.videoVip,
    required this.description,
    required this.note,
    required this.step,
    required this.imageUrl,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      dayId: map['day_id'],
      name: map['name'],
      sets: map['sets'],
      reps: map['reps'],
      duration: map['duration'],
      videoUrl: map['videoUrl'],
      videoVip: map['videoVip'],
      description: map['description'],
      note: map['note'],
      step: List<String>.from((map['step'] as String).split('|')), // dùng '|' để lưu danh sách step trong SQLite
      imageUrl: map['imageUrl'],
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day_id': dayId,
      'name': name,
      'sets': sets,
      'reps': reps,
      'duration': duration,
      'videoUrl': videoUrl,
      'videoVip': videoVip,
      'description': description,
      'note': note,
      'step': step.join('|'), // nối các bước lại thành chuỗi để lưu SQLite
      'imageUrl': imageUrl,
    };
  }
}


class WorkoutPlanProgress {
  //final String userId;
  final int planId;
  int currentDay;
  int currentExercise;

  WorkoutPlanProgress({
    //required this.userId,
    required this.planId,
    required this.currentDay,
    required this.currentExercise,
  });

  factory WorkoutPlanProgress.fromMap(Map<String, dynamic> map) {
    return WorkoutPlanProgress(
      //userId: map['user_id'],
      planId: map['plan_id'],
      currentDay: map['current_day'],
      currentExercise: map['current_exercise'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      //'user_id': userId,
      'plan_id': planId,
      'current_day': currentDay,
      'current_exercise': currentExercise,
    };
  }
}


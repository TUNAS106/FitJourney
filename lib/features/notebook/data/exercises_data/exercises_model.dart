class Exercise {
  final int? id;
  final String name;
  final String description;
  final int duration; // Thời gian gợi ý mỗi hiệp (phút)
  final String category; // Nhóm cơ chính
  final String difficulty; // Dễ, Trung bình, Khó
  final String equipment; // Dụng cụ cần thiết
  final String muscles; // Nhóm cơ tác động chính
  final String caloriesBurned; // Lượng calo tiêu hao ước tính
  final String imageUrl; // Ảnh minh họa
  final int sets;
  final int timePerSet;
  Exercise({
    this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.category,
    required this.difficulty,
    required this.equipment,
    required this.muscles,
    required this.caloriesBurned,
    required this.imageUrl,
    required this.sets,
    required this.timePerSet,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'duration': duration,
    'category': category,
    'difficulty': difficulty,
    'equipment': equipment,
    'muscles': muscles,
    'caloriesBurned': caloriesBurned,
    'imageUrl': imageUrl,
    'sets': sets,
    'timePerSet': timePerSet,
  };

  factory Exercise.fromMap(Map<String, dynamic> map) => Exercise(
    id: map['id'],
    name: map['name'],
    description: map['description'],
    duration: map['duration'],
    category: map['category'],
    difficulty: map['difficulty'],
    equipment: map['equipment'],
    muscles: map['muscles'],
    caloriesBurned: map['caloriesBurned'],
    imageUrl: map['imageUrl'],
    sets: map['sets'],
    timePerSet: map['timePerSet'],
  );
}

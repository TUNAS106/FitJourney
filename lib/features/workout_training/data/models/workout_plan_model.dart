import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutPlanModel {
  final String title;
  final String description;
  final String gender;
  final String location;
  final String type;
  final List<WorkoutDay> days;

  WorkoutPlanModel({
    required this.title,
    required this.description,
    required this.gender,
    required this.location,
    required this.type,
    required this.days,
  });

  factory WorkoutPlanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WorkoutPlanModel(
      title: data['title'],
      description: data['description'],
      gender: data['gender'],
      location: data['location'],
      type: data['type'],
      days: (data['days'] as List)
          .map((day) => WorkoutDay.fromMap(day))
          .toList(),
    );
  }
}

class WorkoutDay {
  final int day;
  final List<Exercise> exercises;

  WorkoutDay({
    required this.day,
    required this.exercises,
  });

  factory WorkoutDay.fromMap(Map<String, dynamic> map) {
    return WorkoutDay(
      day: map['day'],
      exercises: (map['exercises'] as List)
          .map((exercise) => Exercise.fromMap(exercise))
          .toList(),
    );
  }
}

class Exercise {
  final String name;
  final int sets;
  final int reps;
  final int duration;
  final String videoUrl;
  final String stretching;
  final String warmup;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.duration,
    required this.videoUrl,
    required this.stretching,
    required this.warmup,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'],
      sets: map['sets'],
      reps: map['reps'],
      duration: map['duration'],
      videoUrl: map['video_url'],
      stretching: map['stretching'],
      warmup: map['warmup'],
    );
  }
}
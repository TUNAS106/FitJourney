import 'package:fitjourney/features/workout_training/presentation/pages/video_player_screen.dart';
import 'package:fitjourney/features/workout_training/presentation/pages/workout_session_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/workout_plan_model.dart';
import '../bloc/workout_bloc.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final WorkoutPlanModel plan;

  const WorkoutDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(plan.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (plan.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(plan.description, style: TextStyle(fontSize: 16)),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text("Danh sách bài tập:", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: plan.days.length,
              itemBuilder: (context, dayIndex) {
                final day = plan.days[dayIndex];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Ngày ${day.day}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    ...day.exercises.map((exercise) {// Duyệt qua từng bài tập trong ngày
                      return ListTile(
                        title: Text(exercise.name),
                        subtitle: Text(
                          "${exercise.sets} sets x ${exercise.reps} reps - ${exercise.duration} phút",
                        ),
                        trailing: Icon(Icons.play_circle_fill),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VideoPlayerScreen(videoUrl: exercise.videoUrl),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Đánh dấu bắt đầu buổi tập, dispatch Bloc nếu cần
                  context.read<TrainingBloc>().add(StartWorkoutSession(plan));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutSessionScreen(plan: plan),
                    ),
                  );
                },
                child: const Text("Bắt đầu buổi tập"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
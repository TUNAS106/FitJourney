import 'package:flutter/material.dart';
import '../models/plan_models.dart';
import '../db/workout_plan_repository.dart';
import 'workout_session_screen.dart';

class WorkoutPlanModel extends StatefulWidget {
  final WorkoutPlan plan;
  final WorkoutPlanProgress progress; // thêm vào

  const WorkoutPlanModel({Key? key, required this.plan, required this.progress}) : super(key: key);

  @override
  _WorkoutPlanModelScreenState createState() => _WorkoutPlanModelScreenState();
}

class _WorkoutPlanModelScreenState extends State<WorkoutPlanModel> {
  final WorkoutPlanRepository _repository = WorkoutPlanRepository();
  late Future<List<WorkoutDay>> _daysFuture;

  @override
  void initState() {
    super.initState();
    _daysFuture = _repository.getDaysForPlan(widget.plan.id!);
  }

  void _startWorkout(List<WorkoutDay> days) {
    final currentDayIndex = widget.progress.currentDay - 1;
    if (currentDayIndex >= 0 && currentDayIndex < days.length) {
      final day = days[currentDayIndex];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WorkoutSessionScreen(
            day: day,
            progress: widget.progress,
            onProgressUpdated: () {
              setState(() {}); // cập nhật lại UI
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể bắt đầu ngày tập hiện tại.')),
      );
    }
  }

  void _onDayTapped(WorkoutDay day) {
    if (day.day > widget.progress.currentDay) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Để mở các bài tập này, bạn phải thực xong các bài tập trước đó và lưu kết quả trước.')),
      );
    } else if (day.day < widget.progress.currentDay) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WorkoutSessionScreen(
            day: day,
            progress: WorkoutPlanProgress(
              currentDay: widget.progress.currentDay,
              currentExercise: 10, planId: widget.progress.planId,
            ),
            onProgressUpdated: () {
              setState(() {}); // cập nhật lại UI
            },
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WorkoutSessionScreen(
            day: day,
            progress: widget.progress,
            onProgressUpdated: () {
              setState(() {}); // cập nhật lại UI
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plan.title),
      ),
      body: FutureBuilder<List<WorkoutDay>>(
        future: _daysFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có ngày tập nào.'));
          }

          final days = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    final day = days[index];
                    final isCurrent = day.day == widget.progress.currentDay;

                    return Opacity(
                      opacity: day.day > widget.progress.currentDay ? 0.5 : 1.0,
                      child: ListTile(
                        title: Text('Ngày ${day.day}'),
                        trailing: FutureBuilder<List<Exercise>>(
                          future: _repository.getExercisesForDay(day.id!), // lấy bài tập trong ngày
                          builder: (context, exerciseSnapshot) {
                            if (exerciseSnapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (exerciseSnapshot.hasError || !exerciseSnapshot.hasData || exerciseSnapshot.data!.isEmpty) {
                              return Text('0%');
                            }

                            final exercises = exerciseSnapshot.data!;
                            final totalExercises = exercises.length;

                            // Tính tiến độ từ currentDay và currentExercise
                            final completedExercises = isCurrent ? widget.progress.currentExercise ?? 0 : 0;

                            int percent;

                            if (day.day < widget.progress.currentDay) {
                              // Ngày đã hoàn thành (100%)
                              percent = 100;
                            } else if (day.day == widget.progress.currentDay) {
                              // Ngày hiện tại
                              final completedExercises = widget.progress.currentExercise;
                              percent = (completedExercises / totalExercises * 100).clamp(0, 100).toInt();
                            } else {
                              // Ngày chưa tới
                              percent = 0;
                            }
                            return SizedBox(
                              width: 40,
                              height: 40,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: percent / 100,
                                    backgroundColor: Colors.grey[200],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      percent == 100 ? Colors.green : Colors.blue,
                                    ),
                                    strokeWidth: 3,
                                  ),
                                  Text(
                                    '$percent%',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        onTap: () => _onDayTapped(day),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () => _startWorkout(days),
                  child: Text('Bắt đầu tập luyện'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

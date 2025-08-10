import 'package:flutter/material.dart';
import '../models/plan_models.dart';
import '../db/workout_plan_repository.dart';
import 'workout_session_screen.dart';

class WorkoutPlanModel extends StatefulWidget {
  final WorkoutPlan plan;
  final WorkoutPlanProgress progress;
  final VoidCallback onProgressUpdated;

  const WorkoutPlanModel({
    Key? key,
    required this.plan,
    required this.progress,
    required this.onProgressUpdated,
  }) : super(key: key);

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
              setState(() {});
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
        SnackBar(
          content: Text(
            'Để mở các bài tập này, bạn phải thực xong các bài tập trước đó và lưu kết quả trước.',
          ),
        ),
      );
    } else if (day.day < widget.progress.currentDay) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WorkoutSessionScreen(
            day: day,
            progress: WorkoutPlanProgress(
              currentDay: widget.progress.currentDay,
              currentExercise: 10,
              planId: widget.progress.planId,
            ),
            onProgressUpdated: () {
              setState(() {});
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
              setState(() {});
            },
          ),
        ),
      );
    }
  }

  Widget _buildDayCard(WorkoutDay day, bool isLocked, bool isCurrent) {
    return FutureBuilder<List<Exercise>>(
      future: _repository.getExercisesForDay(day.id!),
      builder: (context, exerciseSnapshot) {
        if (exerciseSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (exerciseSnapshot.hasError ||
            !exerciseSnapshot.hasData ||
            exerciseSnapshot.data!.isEmpty) {
          return _dayCardContent(day, 0, isLocked, isCurrent);
        }

        final totalExercises = exerciseSnapshot.data!.length;

        int percent;
        if (day.day < widget.progress.currentDay) {
          percent = 100;
        } else if (day.day == widget.progress.currentDay) {
          final completedExercises = widget.progress.currentExercise ?? 0;
          percent =
              (completedExercises / totalExercises * 100).clamp(0, 100).toInt();
        } else {
          percent = 0;
        }

        return _dayCardContent(day, percent, isLocked, isCurrent);
      },
    );
  }

  Widget _dayCardContent(
      WorkoutDay day, int percent, bool isLocked, bool isCurrent) {
    return GestureDetector(
      onTap: isLocked ? null : () => _onDayTapped(day),
      child: Opacity(
        opacity: isLocked ? 0.5 : 1.0,
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: isCurrent
                    ? [Colors.orangeAccent, Colors.deepOrange]
                    : [Colors.grey.shade200, Colors.grey.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor:
                  isCurrent ? Colors.white : Colors.grey.shade300,
                  child: Icon(
                    isLocked ? Icons.lock : Icons.fitness_center,
                    color: isCurrent ? Colors.blueAccent : Colors.grey,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ngày ${day.day}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: percent / 100,
                          minHeight: 8,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            percent == 100 ? Colors.green : Colors.orangeAccent,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '$percent% hoàn thành',
                        style: TextStyle(
                          fontSize: 12,
                          color: isCurrent ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: () async {
          widget.onProgressUpdated();
          return true;
        },
          child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text(widget.plan.title),
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.redAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
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
                      final isLocked = day.day > widget.progress.currentDay;
                      return _buildDayCard(day, isLocked, isCurrent);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, -2))
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => _startWorkout(days),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.orangeAccent[700],
                    ),
                    child: Text(
                      'Bắt đầu tập luyện',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

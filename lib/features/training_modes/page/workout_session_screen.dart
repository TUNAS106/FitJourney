import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/Load_workout_plans.dart';
import '../models/plan_models.dart';
import '../db/workout_plan_repository.dart';
import 'exercise_screen.dart';

class WorkoutSessionScreen extends StatefulWidget {
  final WorkoutDay day;
  final WorkoutPlanProgress progress; // thêm progress để biết currentExercise
  final VoidCallback? onDaySkipped;
  final VoidCallback onProgressUpdated;



  const WorkoutSessionScreen({
    Key? key,
    required this.day,
    required this.progress,
    this.onDaySkipped, required this.onProgressUpdated,
  }) : super(key: key);




  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  late Future<List<Exercise>> _exercisesFuture;
  bool _isStarted = false;
  DateTime? _startTime;
  Duration _elapsedTime = Duration.zero;
  Timer? _timer;


  void _startTimer() {
    _startTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _elapsedTime = DateTime.now().difference(_startTime!);
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _exercisesFuture =
        WorkoutPlanRepository().getExercisesForDay(widget.day.id!);
  }

  void _confirmSkipDay(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Xác nhận'),
        content: Text('Bạn có chắc chắn muốn kết thúc ngày hiện tại không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              if (widget.day.day == widget.progress.currentDay) {
                widget.progress.currentExercise = 0;
                widget.progress.currentDay += 1;
                // Cập nhật progress trong Firestore
                await FirebaseUserService().updateUserProgress(FirebaseAuth.instance.currentUser!.uid, widget.progress);
              }
              widget.onProgressUpdated();
              Navigator.pop(ctx); // đóng dialog
              Navigator.pop(context); // thoát về màn hình kế hoạch
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã kết thúc ngày hiện tại')),
              );
            },
            child: Text('Xác nhận', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _checkIfDayCompleted(List<Exercise> exercises) {
    if (widget.progress.currentExercise >= exercises.length &&  widget.progress.currentDay == widget.day.day) {
      // Đã hoàn thành tất cả bài tập của ngày
      widget.progress.currentDay++;
      widget.progress.currentExercise = 0;

      // Cập nhật lên Firestore
      FirebaseUserService().updateUserProgress(
          FirebaseAuth.instance.currentUser!.uid,
          widget.progress
      );
      widget.onProgressUpdated();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chúc mừng! Bạn đã hoàn thành ngày ${widget.day.day}')),
      );

    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final exercises = await _exercisesFuture;
        widget.onProgressUpdated(); // Gọi callback để cập nhật màn hình trước
        _checkIfDayCompleted(exercises);
        if (_isStarted == true) {
          _stopTimer();
          setState(() {
            _isStarted = false;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Hoàn thành buổi tập'),
                content: Text(
                  'Hôm nay bạn đã tập được kha khá đấy .\n'
                      'Thời gian: ${_elapsedTime.inMinutes} phút ${_elapsedTime.inSeconds % 60} giây\n'
                      'Hãy cố gắng hơn vào hôm sau nhé!',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng dialog
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
        return true; // Cho phép thoát khỏi màn hình
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ngày ${widget.day.day}'),
          actions: _isStarted
              ? [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${_elapsedTime.inMinutes.toString().padLeft(2, '0')}:${(_elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ]
              : [
            IconButton(
              icon: Icon(Icons.skip_next),
              onPressed: () => _confirmSkipDay(context),
              tooltip: 'Bỏ qua ngày',
            ),
          ],
        ),
        body: FutureBuilder<List<Exercise>>(
          future: _exercisesFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
            final exercises = snapshot.data!;
            return ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final ex = exercises[index];
                final currentExercise = widget.progress.currentExercise;

                return Opacity(
                  opacity: index > currentExercise ? 0.4 : 1.0, // Làm mờ nếu chưa tới lượt tập
                  child: ListTile(
                    leading: ex.imageUrl != null
                        ? Image.asset(ex.imageUrl!, width: 60, height: 60, fit: BoxFit.cover)
                        : Icon(Icons.fitness_center, size: 40),
                    title: Text(ex.name),
                    subtitle: Text(
                      '${ex.sets} sets x ${ex.reps} reps | ${ex.duration}s',
                    ),
                    trailing: index < currentExercise
                        ? Icon(Icons.check_circle, color: Colors.green) // Đã hoàn thành
                        : (index == currentExercise
                        ? Icon(Icons.fiber_manual_record, color: Colors.blue) // Đang tập
                        : null), // Chưa đến lượt
                    onTap: () {
                      if (index == currentExercise) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ExerciseScreen(
                              exercise: ex,
                              progress: widget.progress,
                              onProgressUpdated: () {
                                setState(() {}); // cập nhật lại UI
                              },
                              exerciseIndexInDay: index,
                            ),
                          ),
                        );
                      }
                      if (index < currentExercise) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ExerciseScreen(
                              exercise: ex,
                              progress: widget.progress,
                              onProgressUpdated: () {
                                setState(() {}); // cập nhật lại UI
                              },
                              exerciseIndexInDay: index,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isStarted
                ? ElevatedButton.icon(
              icon: Icon(Icons.stop),
              label: Text('Kết thúc tập'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                _stopTimer();
                setState(() {
                  _isStarted = false;
                });

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Hoàn thành buổi tập'),
                      content: Text(
                        'Hôm nay bạn đã tập được kha khá đấy .\n'
                            'Thời gian: ${_elapsedTime.inMinutes} phút ${_elapsedTime.inSeconds % 60} giây\n'
                            'Hãy cố gắng hơn vào hôm sau nhé!',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Đóng dialog
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );

              },
            )
                : ElevatedButton.icon(
              icon: Icon(Icons.play_arrow),
              label: Text('Bắt đầu'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () async {
                final exercises = await _exercisesFuture;
                final currentIndex = widget.progress.currentExercise;
                if (currentIndex < exercises.length) {
                  final currentExercise = exercises[currentIndex];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseScreen(
                        exercise: currentExercise,
                        progress: widget.progress,
                        onProgressUpdated: () {
                          setState(() {}); // cập nhật lại UI
                        },
                        exerciseIndexInDay: currentIndex,//index,
                    ),

                    ),
                  );
                  setState(() {
                    _isStarted = true;
                  });
                  _startTimer();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bạn đã hoàn thành tất cả bài tập trong ngày!')),
                  );
                }
              },
            ),
          ),
      ),
    );
  }
  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}

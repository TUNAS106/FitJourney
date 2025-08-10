import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/Load_workout_plans.dart';
import '../models/plan_models.dart';
import '../db/workout_plan_repository.dart';
import 'exercise_screen.dart';

class WorkoutSessionScreen extends StatefulWidget {
  final WorkoutDay day;
  final WorkoutPlanProgress progress;
  final VoidCallback? onDaySkipped;
  final VoidCallback onProgressUpdated;

  const WorkoutSessionScreen({
    Key? key,
    required this.day,
    required this.progress,
    this.onDaySkipped,
    required this.onProgressUpdated,
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
  late ConfettiController _confettiController;

  void _startTimer() {
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
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
    _exercisesFuture = WorkoutPlanRepository().getExercisesForDay(widget.day.id!);
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  void _confirmSkipDay(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn kết thúc ngày hiện tại không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              if (widget.day.day == widget.progress.currentDay) {
                widget.progress.currentExercise = 0;
                widget.progress.currentDay += 1;
                await FirebaseUserService().updateUserProgress(
                  FirebaseAuth.instance.currentUser!.uid,
                  widget.progress,
                );
              }
              widget.onProgressUpdated();
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã kết thúc ngày hiện tại')),
              );
            },
            child: const Text('Xác nhận', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _checkIfDayCompleted(List<Exercise> exercises) {
    if (widget.progress.currentExercise >= exercises.length &&
        widget.progress.currentDay == widget.day.day) {
      widget.progress.currentDay++;
      widget.progress.currentExercise = 0;

      FirebaseUserService().updateUserProgress(
        FirebaseAuth.instance.currentUser!.uid,
        widget.progress,
      );
      widget.onProgressUpdated();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('🎉 Chúc mừng! Bạn đã hoàn thành ngày ${widget.day.day}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final exercises = await _exercisesFuture;
        widget.onProgressUpdated();
        _checkIfDayCompleted(exercises);

        if (_isStarted) {
          _stopTimer();
          setState(() => _isStarted = false);
          _showFinishDialog();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.redAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(
            'Ngày ${widget.day.day}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: _isStarted
              ? [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${_elapsedTime.inMinutes.toString().padLeft(2, '0')}:${(_elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ]
              : [
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: () => _confirmSkipDay(context),
              tooltip: 'Bỏ qua ngày',
            ),
          ],
        ),
        body: FutureBuilder<List<Exercise>>(
          future: _exercisesFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final exercises = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final ex = exercises[index];
                final currentExercise = widget.progress.currentExercise;

                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: index > currentExercise ? 0.4 : 1.0,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ex.imageUrl != null
                            ? Image.asset(
                          ex.imageUrl!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        )
                            : const Icon(Icons.fitness_center, size: 50),
                      ),
                      title: Text(
                        ex.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        '${ex.sets} sets x ${ex.reps} reps | ${ex.duration} phút',
                      ),
                      trailing: index < currentExercise
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : (index == currentExercise
                          ? const Icon(Icons.play_circle_fill,
                          color: Colors.blue, size: 30)
                          : null),
                      onTap: () {
                        if (index <= currentExercise) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ExerciseScreen(
                                exercise: ex,
                                progress: widget.progress,
                                onProgressUpdated: () {
                                  setState(() {});
                                },
                                exerciseIndexInDay: index,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: Icon(_isStarted ? Icons.stop : Icons.play_arrow, size: 28),
            label: Text(
              _isStarted ? 'Kết thúc tập' : 'Bắt đầu',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: _isStarted ? Colors.red :  Colors.orangeAccent[700],
            ),
            onPressed: () async {
              if (_isStarted) {
                _stopTimer();
                setState(() => _isStarted = false);
                _showFinishDialog();
              } else {
                final exercises = await _exercisesFuture;
                final currentIndex = widget.progress.currentExercise;
                if (currentIndex < exercises.length) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseScreen(
                        exercise: exercises[currentIndex],
                        progress: widget.progress,
                        onProgressUpdated: () {
                          setState(() {});
                        },
                        exerciseIndexInDay: currentIndex,
                      ),
                    ),
                  );
                  setState(() => _isStarted = true);
                  _startTimer();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Bạn đã hoàn thành tất cả bài tập hôm nay!')),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  void _showFinishDialog() {
    _confettiController.play(); // Bắt đầu pháo hoa

    showDialog(
      context: context,
      builder: (_) => Stack(
        alignment: Alignment.topCenter,
        children: [
          AlertDialog(
            title: const Text('Hoàn thành buổi tập'),
            content: Text(
              '💪 Hôm nay bạn đã tập rất tốt!\n'
                  '⏱ Thời gian: ${_elapsedTime.inMinutes} phút ${_elapsedTime.inSeconds % 60} giây\n'
                  '🔥 Hãy duy trì tinh thần này nhé!',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.red, Colors.orange, Colors.blue, Colors.purple],
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _stopTimer();
    _confettiController.dispose();
    super.dispose();
  }
}

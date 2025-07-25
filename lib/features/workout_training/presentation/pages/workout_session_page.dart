import 'dart:async';
import 'package:flutter/material.dart';

import '../../data/models/workout_plan_model.dart';

class WorkoutSessionScreen extends StatefulWidget {
  final WorkoutPlanModel plan;

  const WorkoutSessionScreen({super.key, required this.plan});

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isPaused = false;
  int _currentDayIndex = 0;
  int _currentExerciseIndex = 0;

  @override
  void initState() {
    super.initState();
    _startExercise();
  }

  void _startExercise() {
    final currentExercise = widget.plan.days[_currentDayIndex].exercises[_currentExerciseIndex];
    final duration = currentExercise.duration * 60; // minutes to seconds
    setState(() {
      _remainingSeconds = duration;
      _isPaused = false;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0 && !_isPaused) {
        setState(() {
          _remainingSeconds--;
        });
      } else if (_remainingSeconds == 0) {
        _timer?.cancel();
        _nextExercise();
      }
    });
  }

  void _pauseResume() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _nextExercise() {
    final currentDay = widget.plan.days[_currentDayIndex];
    if (_currentExerciseIndex < currentDay.exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
      });
      _startExercise();
    } else if (_currentDayIndex < widget.plan.days.length - 1) {
      setState(() {
        _currentDayIndex++;
        _currentExerciseIndex = 0;
      });
      _startExercise();
    } else {
      _completeSession();
    }
  }

  void _completeSession() {
    _timer?.cancel();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Workout session completed!")),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  @override
  Widget build(BuildContext context) {
    final currentDay = widget.plan.days[_currentDayIndex];
    final currentExercise = currentDay.exercises[_currentExerciseIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Workout: ${widget.plan.title}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Current Exercise:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              currentExercise.name,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 12),
            Text(
              "${currentExercise.sets} sets x ${currentExercise.reps} reps",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 32),
            Text(
              _formatTime(_remainingSeconds),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  label: Text(_isPaused ? "Resume" : "Pause"),
                  onPressed: _pauseResume,
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.skip_next),
                  label: Text("Skip"),
                  onPressed: _nextExercise,
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text("Complete"),
                  onPressed: _completeSession,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
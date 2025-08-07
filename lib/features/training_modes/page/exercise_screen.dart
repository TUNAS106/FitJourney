import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../auth/pages/upgrade_vip_page.dart';
import '../models/Load_workout_plans.dart';
import '../models/plan_models.dart';
import 'local_video_player_screen.dart';
import 'dart:async';

class ExerciseScreen extends StatefulWidget {
  final Exercise exercise;
  final WorkoutPlanProgress progress;
  final VoidCallback onProgressUpdated;
  final int exerciseIndexInDay;
  const ExerciseScreen({Key? key, required this.exercise, required this.progress, required this.onProgressUpdated, required this.exerciseIndexInDay}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  int setsDone = 0;
  List<int> repsHistory = [];
  int inputReps = 0;
  bool isResting = false;
  Timer? _restTimer;
  int restSecondsLeft = 0;

  void _startRestCountdown() {
    setState(() {
      isResting = true;
      restSecondsLeft = 120;
    });

    _restTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        restSecondsLeft--;
        if (restSecondsLeft <= 0) {
          isResting = false;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _onAddSet() async {
    if (inputReps <= 0) return;

    setState(() {
      setsDone++;
      repsHistory.add(inputReps);
      inputReps = 0;
    });
    widget.onProgressUpdated();

    print(': ${widget.exerciseIndexInDay}, : ${widget.progress.currentExercise}');
    if (setsDone >= widget.exercise.sets &&
        widget.exercise.dayId == widget.progress.currentDay &&
        widget.exerciseIndexInDay == widget.progress.currentExercise) {
      widget.progress.currentExercise++;
      await FirebaseUserService().updateUserProgress(FirebaseAuth.instance.currentUser!.uid, widget.progress);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bạn đã hoàn thành bài tập!')),
      );
    }
      _startRestCountdown();
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }

  Widget _buildCircleInfo(String label, String value, {Color color = Colors.teal}) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
          ),
          child: Center(
            child: Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;

    return Scaffold(
      appBar: AppBar(
        title: Text(ex.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ex.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    if (ex.description != null)
                      Text("Mô tả: ${ex.description!}", style: TextStyle(fontSize: 16)),
                    if (ex.note != null && ex.note!.isNotEmpty)
                      Text("\nGhi chú: ${ex.note!}", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                    if (ex.step != null && ex.step!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text("Các bước:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ...ex.step!.map((s) => Text('- $s', style: TextStyle(fontSize: 15))).toList(),
                        ],
                      ),
                    if (ex.note != null && ex.note!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text("Lưu ý:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Text('- ${ex.note!}', style: TextStyle(fontSize: 15)),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircleInfo('Repeats', '${ex.reps}'),
                _buildCircleInfo('Rest', isResting ? '${(restSecondsLeft ~/ 60).toString().padLeft(2, '0')}:${(restSecondsLeft % 60).toString().padLeft(2, '0')}' : '2:00'),
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: CircularProgressIndicator(
                            value: setsDone / ex.sets,
                            strokeWidth: 5,
                            backgroundColor: Colors.grey[300],
                            color: Colors.teal,
                          ),
                        ),
                        Text(
                          '${((setsDone / ex.sets) * 100).toInt()}%',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(height: 6),
                    Text('Sets done'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nhập số reps đã tập',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => inputReps = int.tryParse(val) ?? 0,
            ),
            SizedBox(height: 12),
              Center(
                child: ElevatedButton.icon(
                  onPressed:  _onAddSet,
                  icon: Icon(Icons.add),
                  label: Text('Thêm Set'),
                ),
              ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lịch sử tập:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                ...repsHistory.asMap().entries.map((entry) =>
                    Text('Set ${entry.key + 1}: ${entry.value} reps')
                ),
              ],
            ),
            SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    final isVip = await FirebaseUserService().isVip(user!.uid);
                    if (isVip) {
                      if (ex.videoUrl.startsWith('assets/')) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                LocalVideoPlayerScreen(
                                    videoAssetPath: ex.videoUrl),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Video không hỗ trợ: ${ex
                              .videoUrl}')),
                        );
                      }
                    }
                    else {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: Text('Nâng cấp tài khoản'),
                            content: Text('Tính năng này chỉ dành cho người dùng VIP. Bạn có muốn nâng cấp không?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop(); // đóng dialog
                                },
                                child: Text('Hủy'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop(); // đóng dialog
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => UpgradeVipPage(),
                                    ),
                                  );
                                },
                                child: Text('Nâng cấp'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  icon: Icon(Icons.play_circle_fill),
                  label: Text('Xem video hướng dẫn'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

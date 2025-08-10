import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
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


  const ExerciseScreen({
    Key? key,
    required this.exercise,
    required this.progress,
    required this.onProgressUpdated,
    required this.exerciseIndexInDay,
  }) : super(key: key);

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
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    if (widget.exercise.videoUrl.isNotEmpty) {
      _videoController = widget.exercise.videoUrl.startsWith('assets/')
          ? VideoPlayerController.asset(widget.exercise.videoUrl)
          : VideoPlayerController.network(widget.exercise.videoUrl);

      _videoController.initialize().then((_) {
        _videoController.play();
        setState(() {});
      });
      _videoController.addListener(() {
        if (_videoController.value.position == _videoController.value.duration &&
            _videoController.value.isInitialized) {
          _videoController.seekTo(Duration.zero);
          _videoController.play();
        }
      });
    }
  }

  void _startRestCountdown() {
    _restTimer?.cancel();
    setState(() {
      isResting = true;
      restSecondsLeft = 120;
    });

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {

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

    if (setsDone >= widget.exercise.sets &&
        widget.exercise.dayId == widget.progress.currentDay &&
        widget.exerciseIndexInDay == widget.progress.currentExercise) {
      widget.progress.currentExercise++;
      await FirebaseUserService().updateUserProgress(
        FirebaseAuth.instance.currentUser!.uid,
        widget.progress,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn đã hoàn thành bài tập!')),
      );
    }
    _startRestCountdown();
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    _videoController.dispose();
    super.dispose();
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;

    return Scaffold(
      appBar: AppBar(
        title: Text(ex.name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ex.videoUrl.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Video hướng dẫn",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: _videoController.value.isInitialized
                          ? _videoController.value.aspectRatio
                          : 16 / 9,
                      child: VideoPlayer(_videoController),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: IconButton(
                      iconSize: 50,
                      icon: Icon(
                        _videoController.value.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.orangeAccent[700],
                      ),
                      onPressed: () {
                        setState(() {
                          _videoController.value.isPlaying
                              ? _videoController.pause()
                              : _videoController.play();
                        });
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoCard('Repeats', '${ex.reps}', Icons.repeat, Colors.blue),
                _buildInfoCard(
                  'Rest',
                  isResting
                      ? '${(restSecondsLeft ~/ 60).toString().padLeft(2, '0')}:${(restSecondsLeft % 60).toString().padLeft(2, '0')}'
                      : '2:00',
                  Icons.timer,
                  Colors.orange,
                ),
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: setsDone / ex.sets,
                            strokeWidth: 6,
                            backgroundColor: Colors.grey[300],
                            color: Colors.teal,
                          ),
                        ),
                        Text('${((setsDone / ex.sets) * 100).toInt()}%',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text('Sets done'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nhập số reps đã tập',
                prefixIcon: const Icon(Icons.fitness_center),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => inputReps = int.tryParse(val) ?? 0,
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton.icon(
                onPressed: _onAddSet,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Thêm Set', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ex.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    if (ex.description != null)
                      Text("Mô tả: ${ex.description!}", style: const TextStyle(fontSize: 16)),
                    if (ex.step != null && ex.step!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      const Text("Các bước:", style: TextStyle(fontWeight: FontWeight.w600)),
                      ...ex.step!.map((s) => Text('- $s')).toList(),
                    ],
                    if (ex.note != null && ex.note!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      const Text("Lưu ý:", style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('- ${ex.note!}'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Lịch sử tập:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: repsHistory
                  .asMap()
                  .entries
                  .map((e) => Chip(label: Text('Set ${e.key + 1}: ${e.value} reps')))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  final isVip = await FirebaseUserService().isVip(user!.uid);
                  if (isVip) {
                    if (ex.videoVip.startsWith('assets/')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LocalVideoPlayerScreen(videoAssetPath: ex.videoVip),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Video không hỗ trợ: ${ex.videoVip}')),
                      );
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Nâng cấp tài khoản'),
                          content: const Text(
                              'Tính năng này chỉ dành cho người dùng VIP. Bạn có muốn nâng cấp không?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(dialogContext).pop(),
                              child: const Text('Hủy'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => UpgradeVipPage()),
                                );
                              },
                              child: const Text('Nâng cấp'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.orangeAccent[700],
                ),
                icon: const Icon(Icons.play_circle_fill, size: 28),
                label: const Text('Xem video hướng dẫn', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

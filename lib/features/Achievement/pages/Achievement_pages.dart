import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../models/Achievement_controller.dart';
import '../models/Achievement_models.dart';

class AchievementPage extends StatefulWidget {
  final String userId;
  final VoidCallback onProgressUpdated;

  const AchievementPage({required this.userId, Key? key, required this.onProgressUpdated}) : super(key: key);

  @override
  _AchievementPageState createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  int currentChallenge = 1;
  final UserService _userService = UserService();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _loadChallenge();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadChallenge() async {
    int challenge = await _userService.getChallenge(widget.userId);
    setState(() {
      currentChallenge = challenge;
    });
  }

  Future<void> _completeChallenge() async {
    int newChallenge = currentChallenge + 1;
    await _userService.updateChallenge(widget.userId, newChallenge);
    setState(() {
      currentChallenge = newChallenge;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.onProgressUpdated();
        return true; // Cho phép quay lại
      },
      child: Stack(
        children: [Scaffold(
          appBar: AppBar(
            title: const Text("🏆 Achievements"),
            centerTitle: true,
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
          body: ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: allAchievements.length,
            itemBuilder: (context, index) {
              final achievement = allAchievements[index];
              final isCompleted = achievement.id < currentChallenge;
              final isCurrent = achievement.id == currentChallenge;
              final isLocked = achievement.id > currentChallenge;
      
              Color cardColor;
              if (isCompleted) {
                cardColor = Colors.white;
              } else if (isCurrent) {
                cardColor = Colors.orange.shade50;
              } else {
                cardColor = Colors.grey.shade200;
              }
      
              IconData iconData;
              Color iconColor;
              if (isCompleted) {
                iconData = Icons.check_circle;
                iconColor = Colors.green;
              } else if (isLocked) {
                iconData = Icons.lock;
                iconColor = Colors.grey;
              } else {
                iconData = Icons.flag;
                iconColor = Colors.orange;
              }
      
              return Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor: iconColor.withOpacity(0.15),
                    child: Icon(iconData, color: iconColor, size: 28),
                  ),
                  title: Text(
                    achievement.description,
                    style: TextStyle(
                      color: isLocked ? Colors.grey : Colors.black,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  trailing: isCurrent
                      ? ElevatedButton.icon(
                    onPressed: () async {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Xác nhận hoàn thành"),
                          content: const Text(
                              "Bạn chắc chắn đã hoàn thành thử thách này chưa?\nNếu xác nhận, tiến trình của bạn sẽ được tăng."),
                          actions: [
                            TextButton(
                              child: const Text("Hủy"),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: const Text("Xác nhận"),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ],
                        ),
                      );
      
                      if (confirm == true) {
                        _confettiController.play();
                        await _completeChallenge();
      
                        // Hiển thị hộp thoại chúc mừng
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("🎉 Chúc mừng!"),
                            content: Text(
                              "Bạn đã hoàn thành thử thách #${currentChallenge - 1}!\nTiếp tục cố gắng để đạt được thành tích tiếp theo nhé!",
                            ),
                            actions: [
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text("Hoàn thành"),
                  )
                      : null,
                ),
              );
            },
          ),
        ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [Colors.red, Colors.blue, Colors.green, Colors.orange],
            ),
          ),
      ]
      ),
    );
  }
}

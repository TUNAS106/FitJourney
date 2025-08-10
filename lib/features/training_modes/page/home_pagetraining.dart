import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../auth/data/models/User.dart';
import '../db/workout_plan_repository.dart';
import '../models/plan_models.dart';
import '../models/Load_workout_plans.dart';
import 'Workout_Plan_Model.dart';

class HomePageTraining extends StatefulWidget {
  @override
  _HomePageTrainingState createState() => _HomePageTrainingState();
}

class _HomePageTrainingState extends State<HomePageTraining> {
  final WorkoutPlanRepository _repository = WorkoutPlanRepository();
  final FirebaseUserService _firebaseService = FirebaseUserService();
  Map<int, int> totalDayMap = {};
  late Future<List<WorkoutPlan>> _allPlansFuture;
  late Future<List<WorkoutPlanProgress>> _progressFuture;
  late User _user;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _user = authState.user;

      _allPlansFuture = _repository.getAllPlans();
      _progressFuture = _firebaseService.fetchUserProgress(_user.id);

      final allPlans = await _allPlansFuture;
      for (var plan in allPlans) {
        final count = await _repository.getDayCountForPlan(plan.id!);
        totalDayMap[plan.id!] = count;
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is! Authenticated) {
      return Center(child: Text('Vui lòng đăng nhập để xem kế hoạch tập luyện.'));
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: FutureBuilder<List<WorkoutPlan>>(
        future: _allPlansFuture,
        builder: (context, planSnapshot) {
          if (planSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (planSnapshot.hasError) {
            return Center(child: Text('Lỗi: ${planSnapshot.error}'));
          }

          final plans = planSnapshot.data ?? [];
          return FutureBuilder<List<WorkoutPlanProgress>>(
            future: _progressFuture,
            builder: (context, progressSnapshot) {
              if (progressSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (progressSnapshot.hasError) {
                return Center(child: Text('Lỗi: ${progressSnapshot.error}'));
              }

              final progressList = progressSnapshot.data ?? [];
              final progressMap = {for (var p in progressList) p.planId: p};

              final activePlans =
              plans.where((p) => progressMap.containsKey(p.id)).toList();
              final suggestedPlans =
              plans.where((p) => !progressMap.containsKey(p.id)).toList();

              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  _buildSectionTitle('Đang tập', Icons.play_circle_fill),
                  if (activePlans.isEmpty)
                    _buildEmptyMessage('Bạn chưa có kế hoạch tập luyện nào đang hoạt động.'),
                  ...activePlans.map((plan) {
                    final progress = progressMap[plan.id]!;
                    final totalDays = totalDayMap[plan.id] ?? 1;
                    final percent =
                    ((progress.currentDay - 1) / totalDays).clamp(0, 1);

                    return _buildPlanCard(
                      plan: plan,
                      description: plan.description,
                      progressValue: percent.toDouble(),
                      progressText: '${(percent * 100).toInt()}% hoàn thành',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkoutPlanModel(
                              plan: plan,
                              progress: progress,
                              onProgressUpdated: () {
                                setState(() {}); // cập nhật lại UI
                              },
                            ),
                          ),
                        );
                      },
                      onDelete: () async {
                        final confirm = await _showConfirmDialog();
                        if (confirm) {
                          try {
                            await FirebaseUserService()
                                .removeUserProgress(_user.id, plan.id!);
                            setState(() {
                              _progressFuture =
                                  _firebaseService.fetchUserProgress(_user.id);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Đã xóa kế hoạch.')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Xóa thất bại: $e')),
                            );
                          }
                        }
                      },
                      isSuggested: false,
                    );
                  }),

                  SizedBox(height: 20),
                  _buildSectionTitle('Gợi ý', Icons.lightbulb_outline),
                  if (suggestedPlans.isEmpty)
                    _buildEmptyMessage('Không có kế hoạch gợi ý nào'),
                  ...suggestedPlans.map((plan) {
                    return _buildPlanCard(
                      plan: plan,
                      description: plan.description,
                      onAdd: () async {
                        final hasIncompletePlan = activePlans.any((activePlan) {
                          final progress = progressMap[activePlan.id];
                          if (progress == null) return false;
                          final percent = ((progress.currentDay - 1) /
                              (totalDayMap[plan.id] ?? 1));
                          return percent < 1;
                        });
                        if (hasIncompletePlan) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Bạn đã có kế hoạch tập luyện chưa hoàn thành.')),
                          );
                          return;
                        }

                        final newProgress = WorkoutPlanProgress(
                          planId: plan.id ?? 0,
                          currentDay: 1,
                          currentExercise: 0,
                        );

                        try {
                          await _firebaseService.addUserProgress(
                              _user.id, newProgress);
                          setState(() {
                            _progressFuture =
                                _firebaseService.fetchUserProgress(_user.id);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đã thêm vào danh sách.')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Thêm thất bại: $e')),
                          );
                        }
                      },
                      isSuggested: true,
                    );
                  }),
                  // ======= LỊCH THÁNG =======
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: DateTime.now(),
                    calendarFormat: CalendarFormat.month,
                    headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
                    selectedDayPredicate: (day) {
                      return isSameDay(day, DateTime.now()); // đánh dấu ngày hôm nay
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    // 🔹 Thêm phần này để vẽ icon tạ
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        bool isOddDay = day.day % 2 != 0; // ngày lẻ
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${day.day}',
                              style: TextStyle(color: Colors.black),
                            ),
                            if (isOddDay) // chỉ hiển thị icon nếu là ngày lẻ
                              Icon(
                                Icons.fitness_center,
                                size: 14,
                                color: Colors.grey,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  // ==========================
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildEmptyMessage(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(message, style: TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildPlanCard({
    required WorkoutPlan plan,
    required String description,
    double? progressValue,
    String? progressText,
    VoidCallback? onTap,
    VoidCallback? onDelete,
    VoidCallback? onAdd,
    required bool isSuggested,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                plan.gender.toLowerCase() == 'female'
                    ? Icons.female
                    : Icons.male,
                size: 36,
                color: plan.gender.toLowerCase() == 'female'
                    ? Colors.pink
                    : Colors.blue,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(description,
                        style: TextStyle(color: Colors.grey[700])),
                    if (progressValue != null) ...[
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progressValue,
                        color: Colors.green,
                        backgroundColor: Colors.grey[300],
                      ),
                      SizedBox(height: 4),
                      Text(progressText ?? '',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600])),
                    ]
                  ],
                ),
              ),
              SizedBox(width: 8),
              if (isSuggested)
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.blueAccent),
                  onPressed: onAdd,
                ),
              if (!isSuggested)
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa kế hoạch này không?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Hủy')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Xóa', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ??
        false;
  }
}

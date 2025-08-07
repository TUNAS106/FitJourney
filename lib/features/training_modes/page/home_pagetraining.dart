import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      // Tính totalDays cho mỗi plan và lưu vào map
      final allPlans = await _allPlansFuture;
      for (var plan in allPlans) {
        final count = await _repository.getDayCountForPlan(plan.id!);
        totalDayMap[plan.id!] = count;
      }

      setState(() {}); // Đảm bảo cập nhật lại UI
    }
  }
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is! Authenticated) {
      return Center(child: Text('Vui lòng đăng nhập để xem kế hoạch tập luyện.'));
    }

    return Scaffold(
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

              // Tạo map từ planId để dễ tra cứu tiến độ
              final progressMap = {
                for (var p in progressList) p.planId: p
              };

              // Phân loại
              final activePlans = plans.where((p) => progressMap.containsKey(p.id)).toList();
              final suggestedPlans = plans.where((p) => !progressMap.containsKey(p.id)).toList();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Đang tập'),
                    if (activePlans.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Bạn chưa có kế hoạch tập luyện nào đang hoạt động.'),
                      ),
                    ...activePlans.map((plan) {
                      final progress = progressMap[plan.id]!;
                      final totalDays = totalDayMap[plan.id] ?? 1;
                      final percent = ((progress.currentDay-1) / totalDays * 100).clamp(0, 100).toInt();

                      return ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              plan.gender.toLowerCase() == 'female'
                                  ? Icons.female
                                  : Icons.male,
                              color: plan.gender.toLowerCase() == 'female'
                                  ? Colors.pink
                                  : Colors.blue,
                            ),
                            SizedBox(height: 4),
                            Icon(
                              plan.location.toLowerCase() == 'gym'
                                  ? Icons.fitness_center
                                  : Icons.home,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                          ],
                        ),
                        title: Text(plan.title),
                        subtitle:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(plan.description), // Thêm description
                            Text('$percent% hoàn thành'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Xác nhận xóa'),
                                content: Text('Bạn có chắc chắn muốn xóa kế hoạch này khỏi danh sách đang tập không?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text('Hủy'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text('Xóa', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              try {
                                await FirebaseUserService().removeUserProgress(_user.id, plan.id!);
                                setState(() {
                                  _progressFuture = _firebaseService.fetchUserProgress(_user.id);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Đã xóa kế hoạch khỏi danh sách đang tập.')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Xóa thất bại: $e')),
                                );
                              }
                            }
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => WorkoutPlanModel(plan: plan, progress: progress,)),
                          );
                        },
                      );
                    }),


                    Divider(),
                    _buildSectionTitle('Gợi ý'),
                    if (suggestedPlans.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Không có kế hoạch gợi ý nào'),
                      ),
                    ...suggestedPlans.map((plan) {
                      return ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              plan.gender.toLowerCase() == 'female'
                                  ? Icons.female
                                  : Icons.male,
                              color: plan.gender.toLowerCase() == 'female'
                                  ? Colors.pink
                                  : Colors.blue,
                            ),
                            SizedBox(height: 4),
                            Icon(
                              plan.location.toLowerCase() == 'gym'
                                  ? Icons.fitness_center
                                  : Icons.home,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                          ],
                        ),
                        title: Text(plan.title),
                        subtitle: Text(plan.description),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            final hasIncompletePlan = activePlans.any((activePlan) {
                              final progress = progressMap[activePlan.id];
                              if (progress == null) return false;
                              final percent = ((progress.currentDay -1) / (totalDayMap[plan.id] ?? 1) * 100);
                              return percent < 100;
                            });
                            if (hasIncompletePlan) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Bạn đã có kế hoạch tập luyện chưa hoàn thành.')),
                              );
                              return;
                            }

                            final newProgress = WorkoutPlanProgress(
                              planId: plan.id ?? 0,
                              currentDay: 1,
                              currentExercise: 0,
                            );

                            try {
                              await _firebaseService.addUserProgress(_user.id, newProgress);

                              setState(() {
                                _progressFuture = _firebaseService.fetchUserProgress(_user.id);
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Đã thêm vào danh sách đang tập')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Thêm thất bại: $e')),
                              );
                            }
                          },
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

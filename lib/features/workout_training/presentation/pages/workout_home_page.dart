import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/workout_plan_repository.dart';
import '../bloc/workout_bloc.dart';
import 'WorkoutDetailPage.dart';

class WorkoutHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutBloc(WorkoutPlanRepository())..add(LoadWorkoutPlans()),
      child: Scaffold(

        body: BlocBuilder<WorkoutBloc, WorkoutState>(
          builder: (context, state) {
            if (state is WorkoutLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is WorkoutLoaded) {
              return ListView.builder(
                itemCount: state.plans.length,
                itemBuilder: (context, index) {
                  final plan = state.plans[index];
                  return ListTile(
                    title: Text(plan.title),
                    subtitle: Text(plan.description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => TrainingBloc(),
                            child: WorkoutDetailScreen(plan: plan),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is WorkoutError) {
              return Center(child: Text('Errorrrrrrrrrrrrrrrrrrrrrrrrrrrr: ${state.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}

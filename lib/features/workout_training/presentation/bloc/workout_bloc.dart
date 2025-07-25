import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/workout_plan_model.dart';
import '../../data/repository/workout_plan_repository.dart';

// Workout Bloc: Handles loading workout plans
abstract class WorkoutEvent {}
class LoadWorkoutPlans extends WorkoutEvent {}

abstract class WorkoutState {}
class WorkoutInitial extends WorkoutState {}
class WorkoutLoading extends WorkoutState {}
class WorkoutLoaded extends WorkoutState {
  final List<WorkoutPlanModel> plans;
  WorkoutLoaded(this.plans);
}
class WorkoutError extends WorkoutState {
  final String message;
  WorkoutError(this.message);
}

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final WorkoutPlanRepository repository;

  WorkoutBloc(this.repository) : super(WorkoutInitial()) {
    on<LoadWorkoutPlans>((event, emit) async {
      emit(WorkoutLoading());
      try {
        final plans = await repository.fetchWorkoutPlans();
        emit(WorkoutLoaded(plans));
      } catch (e) {
        emit(WorkoutError(e.toString()));
      }
    });
  }
}

// Training Bloc: Handles workout session state
abstract class TrainingEvent {}
class StartWorkoutSession extends TrainingEvent {
  final WorkoutPlanModel plan;
  StartWorkoutSession(this.plan);
}

abstract class TrainingState {}
class TrainingInitial extends TrainingState {}
class WorkoutSessionInProgress extends TrainingState {
  final WorkoutPlanModel plan;
  final int currentExerciseIndex;
  final bool isPaused;

  WorkoutSessionInProgress({
    required this.plan,
    required this.currentExerciseIndex,
    this.isPaused = false,
  });
}

class TrainingBloc extends Bloc<TrainingEvent, TrainingState> {
  TrainingBloc() : super(TrainingInitial()) {
    on<StartWorkoutSession>((event, emit) {
      emit(WorkoutSessionInProgress(
        plan: event.plan,
        currentExerciseIndex: 0,
        isPaused: false,
      ));
    });
  }
}
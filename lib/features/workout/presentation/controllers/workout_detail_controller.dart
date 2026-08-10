import 'package:get/get.dart';
import '../../data/models/workout_models.dart';
import '../views/active_workout_view.dart';
import '../../../home/presentation/controllers/workout_tab_controller.dart';

class WorkoutDetailController extends GetxController {
  final WorkoutDay workoutDay;

  WorkoutDetailController({required this.workoutDay});

  final session = Rxn<WorkoutSession>();

  @override
  void onInit() {
    super.onInit();
    _loadWorkoutData();
  }

  late List<Exercise> availableExercises;
  final searchQuery = ''.obs;

  void _loadWorkoutData() {
    availableExercises = [
      Exercise(
        id: 'w1',
        name: 'Bear Roll',
        imageUrl: 'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=200&h=200&fit=crop',
        isWarmup: true,
        targetSets: [TargetSet(setNumber: 1, minReps: 10, maxReps: 10, rir: 0, restDurationSeconds: 30)],
      ),
      Exercise(
        id: 'w2',
        name: 'High Standing Lunge',
        imageUrl: 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=200&h=200&fit=crop',
        isWarmup: true,
        targetSets: [TargetSet(setNumber: 1, minReps: 10, maxReps: 10, rir: 0, restDurationSeconds: 30)],
      ),
      Exercise(
        id: 'e1',
        name: 'Barbell Box Squat',
        imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=200&h=200&fit=crop',
        targetSets: [
          TargetSet(setNumber: 1, minReps: 8, maxReps: 10, rir: 2, restDurationSeconds: 120),
          TargetSet(setNumber: 2, minReps: 8, maxReps: 10, rir: 2, restDurationSeconds: 120),
          TargetSet(setNumber: 3, minReps: 8, maxReps: 10, rir: 2, restDurationSeconds: 120),
        ],
      ),
      Exercise(
        id: 'e2',
        name: 'Close-Grip Bench Press',
        imageUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=200&h=200&fit=crop',
        targetSets: [
          TargetSet(setNumber: 1, minReps: 8, maxReps: 10, rir: 2, restDurationSeconds: 120),
          TargetSet(setNumber: 2, minReps: 8, maxReps: 10, rir: 2, restDurationSeconds: 120),
          TargetSet(setNumber: 3, minReps: 8, maxReps: 10, rir: 2, restDurationSeconds: 120),
        ],
      ),
      Exercise(
        id: 'e3',
        name: 'Seated Leg Curl',
        imageUrl: 'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=200&h=200&fit=crop',
        targetSets: [
          TargetSet(setNumber: 1, minReps: 10, maxReps: 12, rir: 2, restDurationSeconds: 90),
          TargetSet(setNumber: 2, minReps: 10, maxReps: 12, rir: 2, restDurationSeconds: 90),
          TargetSet(setNumber: 3, minReps: 10, maxReps: 12, rir: 2, restDurationSeconds: 90),
        ],
      ),
      Exercise(
        id: 'e4',
        name: 'One-Arm Row',
        imageUrl: 'https://images.unsplash.com/photo-1603287681836-b174ce5074c2?w=200&h=200&fit=crop',
        targetSets: [
          TargetSet(setNumber: 1, minReps: 10, maxReps: 12, rir: 2, restDurationSeconds: 90),
          TargetSet(setNumber: 2, minReps: 10, maxReps: 12, rir: 2, restDurationSeconds: 90),
        ],
      ),
      Exercise(
        id: 'e5',
        name: 'Barbell Hip Thrust',
        imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=200&h=200&fit=crop',
        targetSets: [
          TargetSet(setNumber: 1, minReps: 10, maxReps: 12, rir: 2, restDurationSeconds: 120),
          TargetSet(setNumber: 2, minReps: 10, maxReps: 12, rir: 2, restDurationSeconds: 120),
          TargetSet(setNumber: 3, minReps: 10, maxReps: 12, rir: 2, restDurationSeconds: 120),
        ],
      ),
      Exercise(
        id: 'e6',
        name: 'Lat Pulldown',
        imageUrl: 'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?w=200&h=200&fit=crop',
        targetSets: [
          TargetSet(setNumber: 1, minReps: 10, maxReps: 12, rir: 2, restDurationSeconds: 90),
          TargetSet(setNumber: 2, minReps: 10, maxReps: 12, rir: 2, restDurationSeconds: 90),
          TargetSet(setNumber: 3, minReps: 10, maxReps: 12, rir: 2, restDurationSeconds: 90),
        ],
      ),
      Exercise(
        id: 'e7',
        name: 'Dumbbell Shoulder Press',
        imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=200&h=200&fit=crop',
        targetSets: [
          TargetSet(setNumber: 1, minReps: 10, maxReps: 12, rir: 2, restDurationSeconds: 90),
          TargetSet(setNumber: 2, minReps: 10, maxReps: 12, rir: 2, restDurationSeconds: 90),
          TargetSet(setNumber: 3, minReps: 10, maxReps: 12, rir: 2, restDurationSeconds: 90),
        ],
      ),
      Exercise(
        id: 'e8',
        name: 'Leg Extension',
        imageUrl: 'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=200&h=200&fit=crop',
        targetSets: [
          TargetSet(setNumber: 1, minReps: 12, maxReps: 15, rir: 2, restDurationSeconds: 90),
          TargetSet(setNumber: 2, minReps: 12, maxReps: 15, rir: 2, restDurationSeconds: 90),
          TargetSet(setNumber: 3, minReps: 12, maxReps: 15, rir: 2, restDurationSeconds: 90),
        ],
      ),
      Exercise(
        id: 'e9',
        name: 'Triceps Pushdown',
        imageUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=200&h=200&fit=crop',
        targetSets: [
          TargetSet(setNumber: 1, minReps: 12, maxReps: 15, rir: 2, restDurationSeconds: 60),
          TargetSet(setNumber: 2, minReps: 12, maxReps: 15, rir: 2, restDurationSeconds: 60),
          TargetSet(setNumber: 3, minReps: 12, maxReps: 15, rir: 2, restDurationSeconds: 60),
        ],
      ),
      Exercise(
        id: 'e10',
        name: 'Standing Calf Raise',
        imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=200&h=200&fit=crop',
        targetSets: [
          TargetSet(setNumber: 1, minReps: 15, maxReps: 20, rir: 2, restDurationSeconds: 60),
          TargetSet(setNumber: 2, minReps: 15, maxReps: 20, rir: 2, restDurationSeconds: 60),
          TargetSet(setNumber: 3, minReps: 15, maxReps: 20, rir: 2, restDurationSeconds: 60),
        ],
      ),
    ];

    session.value = WorkoutSession(
      id: workoutDay.id,
      name: workoutDay.title,
      startTime: DateTime.now(),
      exercises: List.from(availableExercises),
    );
  }

  List<Exercise> get filteredExercises {
    if (searchQuery.value.isEmpty) {
      return availableExercises;
    }
    return availableExercises
        .where((e) => e.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void addExercise(Exercise exercise) {
    if (session.value != null) {
      final newExercise = Exercise(
        id: exercise.id + DateTime.now().millisecondsSinceEpoch.toString(), // ensure unique ID if added multiple times
        name: exercise.name,
        imageUrl: exercise.imageUrl,
        videoUrl: exercise.videoUrl,
        isWarmup: false, // force it to be a regular workout exercise
        targetMuscles: exercise.targetMuscles,
        targetSets: exercise.targetSets,
        sets: exercise.sets,
      );
      final updatedExercises = List<Exercise>.from(session.value!.exercises)..add(newExercise);
      session.value = WorkoutSession(
        id: session.value!.id,
        name: session.value!.name,
        startTime: session.value!.startTime,
        exercises: updatedExercises,
      );
    }
  }

  void deleteExercise(String id) {
    if (session.value != null) {
      final updatedExercises = session.value!.exercises.where((e) => e.id != id).toList();
      session.value = WorkoutSession(
        id: session.value!.id,
        name: session.value!.name,
        startTime: session.value!.startTime,
        exercises: updatedExercises,
      );
    }
  }

  void startWorkout() {
    if (session.value != null) {
      Get.to(() => ActiveWorkoutView(session: session.value!));
    }
  }
}

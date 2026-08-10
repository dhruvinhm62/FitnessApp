class TargetSet {
  final int setNumber;
  final int minReps;
  final int maxReps;
  final int rir;
  final int restDurationSeconds;

  TargetSet({
    required this.setNumber,
    required this.minReps,
    required this.maxReps,
    required this.rir,
    required this.restDurationSeconds,
  });
}

class WorkoutSet {
  final String id;
  final int setNumber;
  final bool isWarmup;
  int reps;
  double weight;
  int rir;
  bool isCompleted;

  WorkoutSet({
    required this.id,
    required this.setNumber,
    this.isWarmup = false,
    this.reps = 0,
    this.weight = 0,
    this.rir = 2,
    this.isCompleted = false,
  });
}

class Exercise {
  final String id;
  final String name;
  final String imageUrl;
  final String videoUrl;
  final bool isWarmup;
  final List<String> targetMuscles;
  final List<TargetSet> targetSets;
  final List<WorkoutSet> sets;

  Exercise({
    required this.id,
    required this.name,
    this.imageUrl = '',
    this.videoUrl = '',
    this.isWarmup = false,
    this.targetMuscles = const [],
    this.targetSets = const [],
    List<WorkoutSet>? sets,
  }) : sets = sets ?? [];
}

class WorkoutSession {
  final String id;
  final String name;
  final List<Exercise> exercises;
  final DateTime startTime;

  WorkoutSession({
    required this.id,
    required this.name,
    required this.exercises,
    required this.startTime,
  });
}

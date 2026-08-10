import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../exercise_details/presentation/controllers/exercise_details_controller.dart';
import '../../data/models/workout_models.dart';

class ActiveWorkoutController extends GetxController {
  final WorkoutSession session;
  final int initialExerciseIndex;

  ActiveWorkoutController({required this.session, this.initialExerciseIndex = 0});

  final currentExerciseIndex = 0.obs;
  
  // Sets for the current exercise
  final currentSets = <WorkoutSet>[].obs;
  
  // Timer state
  final isTimerActive = false.obs;
  final timerSeconds = 0.obs;
  final maxTimerSeconds = 0.obs;
  Timer? _timer;

  // UI state
  final isSettingUpExpanded = true.obs;
  final isTechniqueExpanded = true.obs;
  final notes = <ExerciseNote>[].obs;
  
  final manuallyExpandedSetId = RxnString();

  void toggleSettingUp() => isSettingUpExpanded.value = !isSettingUpExpanded.value;
  void toggleTechnique() => isTechniqueExpanded.value = !isTechniqueExpanded.value;

  void toggleSetExpanded(String setId, bool currentExpandedState) {
    if (currentExpandedState) {
      manuallyExpandedSetId.value = 'none';
    } else {
      manuallyExpandedSetId.value = setId;
    }
  }

  void addNote(String title, String description) {
    notes.add(ExerciseNote(
      title: title,
      description: description,
      date: DateTime.now(),
    ));
  }

  // Video state
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  final isVideoInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentExerciseIndex.value = initialExerciseIndex;
    _loadCurrentExerciseSets();
  }

  @override
  void onClose() {
    _timer?.cancel();
    _disposeVideoControllers();
    super.onClose();
  }

  void _disposeVideoControllers() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    videoPlayerController = null;
    chewieController = null;
    isVideoInitialized.value = false;
  }

  void _loadCurrentExerciseSets() {
    if (currentExerciseIndex.value >= session.exercises.length) return;
    
    final exercise = session.exercises[currentExerciseIndex.value];
    
    _initializeVideo(exercise.videoUrl);

    if (exercise.sets.isEmpty) {
      // Generate mock sets
      currentSets.value = [
        WorkoutSet(id: 'w1', setNumber: 1, isWarmup: true, reps: 8, weight: 0),
        WorkoutSet(id: 'w2', setNumber: 2, isWarmup: true, reps: 5, weight: 0),
        WorkoutSet(id: 'w3', setNumber: 3, isWarmup: true, reps: 3, weight: 0),
        ...exercise.targetSets.map((ts) => WorkoutSet(
          id: 'ws${ts.setNumber}', 
          setNumber: ts.setNumber, 
          reps: ts.maxReps, 
          weight: 0
        )),
      ];
      // Save back to model
      exercise.sets.addAll(currentSets);
    } else {
      currentSets.value = List.from(exercise.sets);
    }
  }

  Future<void> _initializeVideo(String url) async {
    _disposeVideoControllers();
    
    if (url.isEmpty) {
      url = 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
    }

    try {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
      await videoPlayerController!.initialize();

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        aspectRatio: 3 / 4,
        autoPlay: false,
        looping: false,
        showControls: false,
        allowFullScreen: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      isVideoInitialized.value = true;
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  void completeSet(int index) {
    var set = currentSets[index];
    set.isCompleted = true;
    currentSets[index] = set;
    manuallyExpandedSetId.value = null;
    currentSets.refresh();
    
    _startRestTimer(175); // 2:55 mock
  }

  void addSet() {
    if (currentSets.isEmpty) {
      currentSets.add(WorkoutSet(
        id: 'set_${DateTime.now().millisecondsSinceEpoch}',
        setNumber: 1,
        isWarmup: false,
        reps: 0,
        weight: 0,
        rir: 2,
        isCompleted: false,
      ));
    } else {
      final lastSet = currentSets.last;
      currentSets.add(WorkoutSet(
        id: 'set_${DateTime.now().millisecondsSinceEpoch}',
        setNumber: lastSet.setNumber + 1,
        isWarmup: false,
        reps: lastSet.reps,
        weight: lastSet.weight,
        rir: lastSet.rir,
        isCompleted: false,
      ));
    }
  }

  void updateSetWeight(int index, double delta) {
    var set = currentSets[index];
    set.weight = (set.weight + delta).clamp(0, 9999);
    currentSets[index] = set;
    currentSets.refresh();
  }

  void updateSetReps(int index, int delta) {
    var set = currentSets[index];
    set.reps = (set.reps + delta).clamp(0, 999);
    currentSets[index] = set;
    currentSets.refresh();
  }

  void updateSetRir(int index, int rir) {
    var set = currentSets[index];
    set.rir = rir;
    currentSets[index] = set;
    currentSets.refresh();
  }
  
  void _startRestTimer(int durationSeconds) {
    isTimerActive.value = true;
    timerSeconds.value = durationSeconds;
    maxTimerSeconds.value = durationSeconds;
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    isTimerActive.value = false;
  }
  
  void skipRest() {
    stopTimer();
  }

  void adjustRestTimer(int seconds) {
    timerSeconds.value += seconds;
    if (timerSeconds.value < 0) {
      timerSeconds.value = 0;
      stopTimer();
    } else {
      maxTimerSeconds.value = timerSeconds.value > maxTimerSeconds.value 
          ? timerSeconds.value : maxTimerSeconds.value;
    }
  }
  
  void skipExercise() {
    if (currentExerciseIndex.value < session.exercises.length - 1) {
      currentExerciseIndex.value++;
      _loadCurrentExerciseSets();
    } else {
      finishWorkout();
    }
  }

  void nextExercise() {
    if (currentExerciseIndex.value < session.exercises.length - 1) {
      currentExerciseIndex.value++;
      _loadCurrentExerciseSets();
    } else {
      finishWorkout();
    }
  }
  
  void finishWorkout() {
    Get.back();
    Get.snackbar('Workout Complete', 'Great job completing your workout!', 
        snackPosition: SnackPosition.BOTTOM);
  }
}

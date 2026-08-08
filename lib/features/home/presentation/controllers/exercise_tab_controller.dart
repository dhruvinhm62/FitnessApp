import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class Exercise {
  final String id;
  final String name;
  final String imageUrl;
  final String equipment;
  final String difficulty;
  final DateTime addedAt;

  Exercise({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.equipment,
    required this.difficulty,
    required this.addedAt,
  });
}

class ExerciseTabController extends GetxController {
  final searchQuery = ''.obs;
  
  // Filter & Sort States
  final sortBy = 'A-Z'.obs; // A-Z, Z-A, Newest added, Oldest added
  final selectedEquipment = <String>[].obs;
  final selectedDifficulty = <String>[].obs;

  final exercises = <Exercise>[].obs;
  final allExercises = <Exercise>[];
  final searchController = TextEditingController();

  // Filter options available
  final equipmentOptions = ['Barbell', 'Dumbbell', 'Machine', 'Bodyweight', 'Cable'];
  final difficultyOptions = ['Beginner', 'Intermediate', 'Advanced'];

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    final List<Exercise> dummyExercises = [];
    final titles = [
      '3-Way Band Seated Hip Abduction',
      'Abducted Contralateral Dumbbell Single-Leg RDL',
      'Alternating Squat/RDL',
      'American Deadlift',
      'Barbell Bench Press',
      'Incline Dumbbell Press',
      'Cable Crossover',
      'Dumbbell Flyes',
      'Push-Ups',
      'Pull-Ups',
      'Lat Pulldown',
      'Seated Cable Row',
      'Barbell Deadlift',
      'T-Bar Row',
      'Barbell Squat',
      'Leg Press',
      'Walking Lunges',
      'Leg Extensions',
      'Lying Leg Curls',
      'Standing Calf Raises',
      'Overhead Press',
      'Lateral Raises',
      'Front Raises',
      'Reverse Pec Deck Fly',
      'Barbell Shrugs',
      'Barbell Curls',
      'Hammer Curls',
      'Preacher Curls',
      'Triceps Pushdown',
      'Skull Crushers',
      'Overhead Triceps Extension',
      'Triceps Dips',
      'Plank',
      'Russian Twists',
      'Hanging Leg Raises',
      'Cable Woodchoppers',
      'Ab Wheel Rollout',
      'Bicycle Crunches',
      'Mountain Climbers',
      'Burpees',
    ];
    final images = [
      'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=200&q=80',
      'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=200&q=80',
      'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=200&q=80',
      'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=200&q=80',
      'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=200&q=80',
      'https://images.unsplash.com/photo-1534367610401-9f5ed68180aa?w=200&q=80',
      'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=200&q=80',
    ];

    final random = Random(42); // Use a seed for consistent mock data

    for (int i = 0; i < titles.length; i++) {
      dummyExercises.add(
        Exercise(
          id: 'e$i',
          name: titles[i],
          imageUrl: images[i % images.length],
          equipment: equipmentOptions[random.nextInt(equipmentOptions.length)],
          difficulty: difficultyOptions[random.nextInt(difficultyOptions.length)],
          addedAt: DateTime.now().subtract(Duration(days: random.nextInt(365))),
        ),
      );
    }
    
    for (int i = 0; i < 5; i++) {
      dummyExercises.add(
        Exercise(
          id: 'e${titles.length + i}',
          name: 'Advanced ${titles[i]}',
          imageUrl: images[i % images.length],
          equipment: equipmentOptions[random.nextInt(equipmentOptions.length)],
          difficulty: difficultyOptions[random.nextInt(difficultyOptions.length)],
          addedAt: DateTime.now().subtract(Duration(days: random.nextInt(365))),
        ),
      );
    }

    allExercises.addAll(dummyExercises);
    applyFilters();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void clearSearch() {
    searchController.clear();
    updateSearch('');
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void toggleEquipmentFilter(String equipment) {
    if (selectedEquipment.contains(equipment)) {
      selectedEquipment.remove(equipment);
    } else {
      selectedEquipment.add(equipment);
    }
    // We don't call applyFilters() automatically because user has to click "Apply now" in dialog
  }

  void toggleDifficultyFilter(String difficulty) {
    if (selectedDifficulty.contains(difficulty)) {
      selectedDifficulty.remove(difficulty);
    } else {
      selectedDifficulty.add(difficulty);
    }
    // We don't call applyFilters() automatically because user has to click "Apply now" in dialog
  }

  void setSortBy(String sort) {
    sortBy.value = sort;
    // We don't call applyFilters() automatically because user has to click "Apply now" in dialog
  }

  void applyFilters() {
    final query = searchQuery.value.toLowerCase().trim();
    List<Exercise> filtered = allExercises.where((exercise) {
      // Search
      if (query.isNotEmpty && !exercise.name.toLowerCase().contains(query)) {
        return false;
      }
      // Equipment
      if (selectedEquipment.isNotEmpty && !selectedEquipment.contains(exercise.equipment)) {
        return false;
      }
      // Difficulty
      if (selectedDifficulty.isNotEmpty && !selectedDifficulty.contains(exercise.difficulty)) {
        return false;
      }
      return true;
    }).toList();

    // Sort
    if (sortBy.value == 'A-Z') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    } else if (sortBy.value == 'Z-A') {
      filtered.sort((a, b) => b.name.compareTo(a.name));
    } else if (sortBy.value == 'Newest added') {
      filtered.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    } else if (sortBy.value == 'Oldest added') {
      filtered.sort((a, b) => a.addedAt.compareTo(b.addedAt));
    }

    exercises.value = filtered;
  }
}

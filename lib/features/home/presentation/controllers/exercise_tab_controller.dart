import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Exercise {
  final String id;
  final String name;
  final String imageUrl;

  Exercise({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class ExerciseTabController extends GetxController {
  final searchQuery = ''.obs;
  final selectedFilter = 'All'.obs;
  final filters = ['All', 'Chest', 'Back', 'Legs', 'Core'].obs;

  final exercises = <Exercise>[].obs;
  final allExercises = <Exercise>[];
  final searchController = TextEditingController();

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

    for (int i = 0; i < titles.length; i++) {
      dummyExercises.add(
        Exercise(
          id: 'e$i',
          name: titles[i],
          imageUrl: images[i % images.length],
        ),
      );
    }
    
    // Add a few more to reach exactly 45 exercises
    for (int i = 0; i < 5; i++) {
      dummyExercises.add(
        Exercise(
          id: 'e${titles.length + i}',
          name: 'Advanced ${titles[i]}',
          imageUrl: images[i % images.length],
        ),
      );
    }

    allExercises.addAll(dummyExercises);
    _applyFilters();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void clearSearch() {
    searchController.clear();
    updateSearch('');
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) {
      exercises.value = allExercises;
    } else {
      exercises.value = allExercises.where((exercise) {
        return exercise.name.toLowerCase().contains(query);
      }).toList();
    }
  }
}

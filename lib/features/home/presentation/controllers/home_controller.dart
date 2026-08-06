import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

enum TimeFilterMode { weekly, monthly, yearly, allTime }

class StreakDay {
  final String day;
  final int date;
  final bool isCompleted;
  final bool isToday;

  StreakDay({required this.day, required this.date, this.isCompleted = false, this.isToday = false});
}

class MemberSpotlight {
  final String name;
  final String beforeImageUrl;
  final String afterImageUrl;

  MemberSpotlight({required this.name, required this.beforeImageUrl, required this.afterImageUrl});
}

class ChartFilterState {
  final filterMode = TimeFilterMode.weekly.obs;
  final selectedMonth = DateTime.now().month.obs;
  final selectedWeekNumber = 3.obs;
  final selectedYear = DateTime.now().year.obs;

  String get formattedFilterText {
    switch (filterMode.value) {
      case TimeFilterMode.weekly:
        final monthName = _getMonthName(selectedMonth.value);
        return 'Week ${selectedWeekNumber.value}, $monthName ${selectedYear.value}';
      case TimeFilterMode.monthly:
        final monthName = _getMonthName(selectedMonth.value);
        return '$monthName ${selectedYear.value}';
      case TimeFilterMode.yearly:
        return '${selectedYear.value}';
      case TimeFilterMode.allTime:
        return 'All Time';
    }
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }
}

class HomeController extends GetxController {
  final userName = "Sarah".obs;
  
  // Header
  final currentWorkoutTitle = "Day 1: Full Body Workout".obs;

  // Program Status
  final daysRemaining = 21.obs;
  final percentComplete = 21.obs;

  // Streak
  final streakDays = <StreakDay>[
    StreakDay(day: 'Mon', date: 3, isCompleted: true),
    StreakDay(day: 'Tue', date: 4, isCompleted: true),
    StreakDay(day: 'Wed', date: 5, isToday: true),
    StreakDay(day: 'Thu', date: 6),
    StreakDay(day: 'Fri', date: 7),
    StreakDay(day: 'Sat', date: 8),
    StreakDay(day: 'Sun', date: 9),
  ].obs;

  // Member Spotlight
  final spotlights = <MemberSpotlight>[
    MemberSpotlight(
      name: "Gillian Young",
      beforeImageUrl: "https://via.placeholder.com/150",
      afterImageUrl: "https://via.placeholder.com/150",
    ),
    MemberSpotlight(
      name: "Jessica Smith",
      beforeImageUrl: "https://via.placeholder.com/150",
      afterImageUrl: "https://via.placeholder.com/150",
    ),
  ].obs;

  // Team
  final teamName = "Bret Contreras PhD".obs;
  final teamImageUrl = "https://via.placeholder.com/150".obs;

  // Trackers
  final currentWeight = 145.5.obs;
  final weightProgress = (-2.5).obs;
  final waterIntake = 1.5.obs;
  final waterGoal = 3.0.obs;

  // Statistics Filters
  final activityFilter = ChartFilterState();
  final topExercisesFilter = ChartFilterState();
  final waterFilter = ChartFilterState();
  final weightFilter = ChartFilterState();
}

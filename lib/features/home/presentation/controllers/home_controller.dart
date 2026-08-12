import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

enum TimeFilterMode { weekly, monthly, yearly, allTime }

class StreakDay {
  final String day;
  final int date;
  final bool isCompleted;
  final bool isToday;
  final bool isSkipped;

  StreakDay({
    required this.day,
    required this.date,
    this.isCompleted = false,
    this.isToday = false,
    this.isSkipped = false,
  });
}

class MemberSpotlight {
  final String name;
  final String beforeImageUrl;
  final String afterImageUrl;
  final String testimonial;

  MemberSpotlight({
    required this.name,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    required this.testimonial,
  });
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

  @override
  void onInit() {
    super.onInit();
    _initStreakDays();
  }
  
  // Header
  final currentWorkoutTitle = "Day 1: Full Body Workout".obs;

  // Program Status
  final daysRemaining = 21.obs;
  final percentComplete = 21.obs;

  // Streak – generated dynamically from real current week
  final streakDays = <StreakDay>[].obs;

  static const _streakDayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  String get todayWorkoutLabel {
    final now = DateTime.now();
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    const weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final dow = weekdays[now.weekday - 1];
    return "TODAY'S WORKOUT • ${now.day} ${months[now.month - 1]}, $dow";
  }

  void _initStreakDays() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final yesterday = today.subtract(const Duration(days: 1));
    final dayBeforeYesterday = today.subtract(const Duration(days: 2));

    streakDays.value = List.generate(7, (i) {
      final day = monday.add(Duration(days: i));
      final isToday = day == today;
      final isYesterday = day == yesterday;
      final isDayBeforeYesterday = day == dayBeforeYesterday;
      final isPast = day.isBefore(today);

      bool isCompleted = false;
      bool isSkipped = false;

      if (isToday) {
        // today – neither completed nor skipped yet
      } else if (isYesterday) {
        isSkipped = true;
      } else if (isDayBeforeYesterday || isPast) {
        isCompleted = true;
      }

      return StreakDay(
        day: _streakDayLabels[i],
        date: day.day,
        isCompleted: isCompleted,
        isSkipped: isSkipped,
        isToday: isToday,
      );
    });
  }

  // Member Spotlight
  final spotlights = <MemberSpotlight>[
    MemberSpotlight(
      name: "Gillian Young",
      beforeImageUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&q=80",
      afterImageUrl: "https://images.unsplash.com/photo-1548690312-e3b507d8c110?w=400&q=80",
      testimonial: "I'm so grateful to BBB! I lost my glutes after giving birth and it was really hard to get them back. I loved going from training five times a week to just three with the BBB program, with great tutorials and a program that keeps you learning and progressing steadily.",
    ),
    MemberSpotlight(
      name: "Renata Bommes",
      beforeImageUrl: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400&q=80",
      afterImageUrl: "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=400&q=80",
      testimonial: "Nothing compares to the glute growth I've achieved with Booty by Bret. The improvements go beyond glute growth—my lifting technique has improved with support from the coaches, I can lift much heavier, feel stronger, and have more energy for all my activities. And, of course, I get extra motivation from the amazing BBB community on Facebook.",
    ),
    MemberSpotlight(
      name: "Vivianna",
      beforeImageUrl: "https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=400&q=80",
      afterImageUrl: "https://images.unsplash.com/photo-1534367610401-9f5ed68180aa?w=400&q=80",
      testimonial: "Bret's expertise in glute training is unparalleled. His programs are challenging yet achievable, and I love how they keep me motivated with fresh workouts every month. Booty By Bret has increased my overall strength which has benefited my aerial practice. The Facebook community is incredibly supportive, and the coaches' feedback is always helpful and constructive.",
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

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class WorkoutDay {
  final String id;
  final String title;
  final String subtitle;
  final List<String> muscleGroups;
  final bool isRestDay;
  final bool isCompleted;
  
  WorkoutDay({
    required this.id,
    required this.title,
    required this.subtitle,
    this.muscleGroups = const [],
    this.isRestDay = false,
    this.isCompleted = false,
  });
}

class WorkoutWeek {
  final String id;
  final String title;
  final List<WorkoutDay> days;
  bool isExpanded;

  WorkoutWeek({
    required this.id,
    required this.title,
    required this.days,
    this.isExpanded = false,
  });
}

class WorkoutTabController extends GetxController {
  final activeProgramName = "Booty Builder 1.0".obs;
  final activeProgramPhase = "Phase 1 - Hypertrophy".obs;

  // Calendar dates mock
  final calendarDates = [
    {'day': 'M', 'date': '27'},
    {'day': 'T', 'date': '28'},
    {'day': 'W', 'date': '29'},
    {'day': 'T', 'date': '30'},
    {'day': 'F', 'date': '31'},
    {'day': 'S', 'date': '1'},
    {'day': 'S', 'date': '2'},
  ].obs;
  final selectedDateIndex = 1.obs;

  final weeks = <WorkoutWeek>[].obs;

  @override
  void onInit() {
    super.onInit();
    _generateSchedule();
  }

  void _generateSchedule() {
    int days = 4;
    if (selectedWorkoutDays.value == "3 Days") days = 3;
    if (selectedWorkoutDays.value == "5 Days") days = 5;

    final newWeeks = <WorkoutWeek>[];
    
    for (int w = 1; w <= 4; w++) {
      final weekDays = <WorkoutDay>[];
      int workoutCount = 1;
      int restCount = 1;

      for (int d = 1; d <= 7; d++) {
        bool isWorkout = false;
        if (days == 3) {
          isWorkout = (d == 1 || d == 3 || d == 5);
        } else if (days == 4) {
          isWorkout = (d == 1 || d == 2 || d == 4 || d == 5);
        } else if (days == 5) {
          isWorkout = (d >= 1 && d <= 5);
        }

        if (isWorkout) {
          weekDays.add(
            WorkoutDay(
              id: 'w${w}_d$d',
              title: 'Workout Day $workoutCount',
              subtitle: '${selectedWorkoutType.value} Focus',
              muscleGroups: ['Full Body'],
              isCompleted: (w == 1 && d == 1), // mock first day completed
            )
          );
          workoutCount++;
        } else {
          weekDays.add(
            WorkoutDay(
              id: 'w${w}_d$d',
              title: 'Rest Day $restCount',
              subtitle: 'Recovery',
              isRestDay: true,
            )
          );
          restCount++;
        }
      }
      
      newWeeks.add(WorkoutWeek(
        id: 'w$w',
        title: 'Week $w',
        days: weekDays,
        isExpanded: w == 1,
      ));
    }
    
    weeks.value = newWeeks;
  }

  void toggleWeek(int index) {
    weeks[index].isExpanded = !weeks[index].isExpanded;
    weeks.refresh();
  }

  void selectDate(int index) {
    selectedDateIndex.value = index;
  }

  // Workout Settings
  final selectedWorkoutType = "Home".obs;
  final selectedWorkoutDays = "4 Days".obs;

  void showWorkoutSettings() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 8),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          border: Border(top: BorderSide(color: AppColors.black, width: 2)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Workout Settings', style: TextStyle(color: AppColors.black, fontSize: 20, fontWeight: FontWeight.w900)),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.black),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('WHERE DO YOU PLAN TO WORKOUT?', style: TextStyle(color: AppColors.black, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              const SizedBox(height: 12),
              Obx(() {
                Widget buildCard(String title, String subtitle, IconData icon) {
                  final isSelected = selectedWorkoutType.value == title;
                  return GestureDetector(
                    onTap: () => selectedWorkoutType.value = title,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(isSelected ? 15.0 : 16.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: isSelected ? AppColors.black : Colors.grey[400]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(icon, color: AppColors.black, size: 28),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  subtitle,
                                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppColors.black : Colors.grey[400]!,
                                width: isSelected ? 7 : 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    buildCard('Home', 'Bodyweight exercises only', Icons.home),
                    buildCard('Semi Equipped', 'Dumbbells and resistance bands', Icons.fitness_center),
                    buildCard('Fully Equipped Gym', 'Access to machines and barbells', Icons.domain),
                  ],
                );
              }),
              const SizedBox(height: 32),
              const Text('HOW MANY DAYS PER WEEK?', style: TextStyle(color: AppColors.black, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              const SizedBox(height: 12),
              Obx(() {
                Widget buildDayCard(String title, IconData icon) {
                  final isSelected = selectedWorkoutDays.value == title;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => selectedWorkoutDays.value = title,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.black : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? AppColors.black : Colors.grey[400]!,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icon, color: isSelected ? AppColors.white : AppColors.black, size: 28),
                            const SizedBox(height: 8),
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 14, 
                                fontWeight: FontWeight.bold, 
                                color: isSelected ? AppColors.white : AppColors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return Row(
                  children: [
                    buildDayCard('3 Days', Icons.battery_4_bar),
                    const SizedBox(width: 12),
                    buildDayCard('4 Days', Icons.fitness_center),
                    const SizedBox(width: 12),
                    buildDayCard('5 Days', Icons.local_fire_department),
                  ],
                );
              }),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _generateSchedule();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: const BorderSide(color: AppColors.black, width: 2),
                    ),
                  ),
                  child: const Text('SAVE SETTINGS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

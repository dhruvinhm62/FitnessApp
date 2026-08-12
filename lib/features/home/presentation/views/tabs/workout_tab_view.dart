import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../controllers/workout_tab_controller.dart';

class WorkoutTabView extends StatelessWidget {
  WorkoutTabView({super.key});

  final WorkoutTabController controller = Get.put(WorkoutTabController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.black,
            elevation: 0,
            toolbarHeight: 60,
            automaticallyImplyLeading: false,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () {
                if (Get.isRegistered<DashboardController>()) {
                  Get.find<DashboardController>().changeTab(0);
                }
              },
            ),
            title: const Text(
              'WORKOUT',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () => controller.showWorkoutSettings(),
                  child: const Icon(Icons.settings, color: AppColors.white),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildCurvedHeader(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 24,
                    bottom: 120,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_buildWeeksList()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurvedHeader() {
    return Container(
      width: double.infinity,
      color: AppColors.black,
      child: Container(
        height: 220,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.5),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        Text(
                          controller.currentMonthYear,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.currentWeekLabel,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildCalendarStrip(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarStrip() {
    return SizedBox(
      height: 70,
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(controller.calendarDates.length, (index) {
            final dateData = controller.calendarDates[index];
            final isSelected = controller.selectedDateIndex.value == index;
            final status = dateData['status'] ?? 'future';

            final bool isCompleted = status == 'completed';
            final bool isSkipped = status == 'skipped';
            final bool isToday = status == 'today';

            Color bgColor = Colors.transparent;
            Color borderColor = AppColors.white.withOpacity(0.3);
            double borderWidth = 1;

            if (isCompleted) {
              bgColor = const Color(0xFF34C759); // green
              borderColor = const Color(0xFF34C759);
            } else if (isSkipped) {
              bgColor = const Color(0xFF007AFF); // blue
              borderColor = const Color(0xFF007AFF);
            } else if (isToday || isSelected) {
              bgColor = Colors.transparent;
              borderColor = AppColors.white;
              borderWidth = 2;
            }

            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectDate(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: bgColor,
                    border: Border.all(
                      color: borderColor,
                      width: borderWidth,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dateData['day']!,
                        style: TextStyle(
                          color: AppColors.white.withOpacity(
                            (isCompleted || isSkipped) ? 0.85 : 0.7,
                          ),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isCompleted)
                        const Icon(
                          Icons.check_rounded,
                          color: AppColors.white,
                          size: 18,
                        )
                      else if (isSkipped)
                        const Icon(
                          Icons.close_rounded,
                          color: AppColors.white,
                          size: 18,
                        )
                      else ...[
                        Text(
                          dateData['date']!,
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        if (isToday || isSelected) ...[
                          const SizedBox(height: 2),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildWeeksList() {
    return Obx(
      () => Column(
        children: controller.weeks.asMap().entries.map((entry) {
          final index = entry.key;
          final week = entry.value;
          return _buildWeekSection(index, week);
        }).toList(),
      ),
    );
  }

  Widget _buildWeekSection(int index, WorkoutWeek week) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.black, width: 2),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => controller.toggleWeek(index),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    week.title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Icon(
                    week.isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.black,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          if (week.isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Column(
                children: week.days.map((day) => _buildDayCard(day)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDayCard(WorkoutDay day) {
    Color cardColor = day.isCompleted ? AppColors.black : AppColors.white;
    Color textColor = day.isCompleted ? AppColors.white : AppColors.black;
    IconData icon = day.isCompleted
        ? Icons.check
        : (day.isRestDay ? Icons.bedtime_outlined : Icons.fitness_center);
    Color iconColor = day.isCompleted ? AppColors.white : AppColors.black;

    return GestureDetector(
      onTap: () => controller.startWorkout(day),
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: AppColors.black, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: day.isCompleted
                    ? AppColors.white.withOpacity(0.2)
                    : AppColors.background,
                border: Border.all(
                  color: day.isCompleted
                      ? Colors.transparent
                      : AppColors.black.withOpacity(0.1),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day.title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (day.muscleGroups.isNotEmpty)
                    Text(
                      day.muscleGroups.join(' • '),
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    )
                  else
                    Text(
                      day.subtitle,
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: textColor),
          ],
        ),
      ),
    );
  }
}

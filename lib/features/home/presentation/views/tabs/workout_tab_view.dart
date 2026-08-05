import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controllers/workout_tab_controller.dart';

class WorkoutHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    
    // Create a curvy wave at the bottom
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height - 60);
    var secondEndPoint = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

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
            leading: const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Icon(Icons.calendar_today_outlined, color: AppColors.white),
            ),
            title: const Text(
              'WORKOUT',
              style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.5),
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
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWeeksList(),
                    ],
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Column(
                      children: [
                        Text('JULY 2026', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        SizedBox(height: 4),
                        Text('WEEK 4', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
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
      child: Obx(() => ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.calendarDates.length,
        itemBuilder: (context, index) {
          final dateData = controller.calendarDates[index];
          final isSelected = controller.selectedDateIndex.value == index;
          return GestureDetector(
            onTap: () => controller.selectDate(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.white : Colors.transparent,
                border: Border.all(color: AppColors.white, width: isSelected ? 0 : 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dateData['day']!,
                    style: TextStyle(
                      color: isSelected ? AppColors.black : AppColors.white.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateData['date']!,
                    style: TextStyle(
                      color: isSelected ? AppColors.black : AppColors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 2),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      )),
    );
  }

  Widget _buildWeeksList() {
    return Obx(() => Column(
      children: controller.weeks.asMap().entries.map((entry) {
        final index = entry.key;
        final week = entry.value;
        return _buildWeekSection(index, week);
      }).toList(),
    ));
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
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                  ),
                  Icon(
                    week.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
    IconData icon = day.isCompleted ? Icons.check : (day.isRestDay ? Icons.bedtime_outlined : Icons.fitness_center);
    Color iconColor = day.isCompleted ? AppColors.white : AppColors.black;

    return Container(
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
              color: day.isCompleted ? AppColors.white.withOpacity(0.2) : AppColors.background,
              border: Border.all(color: day.isCompleted ? Colors.transparent : AppColors.black.withOpacity(0.1)),
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
    );
  }

}

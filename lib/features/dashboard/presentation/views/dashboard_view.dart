import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../home/presentation/views/tabs/workout_tab_view.dart';
import '../../../home/presentation/views/tabs/exercise_tab_view.dart';
import '../../../home/presentation/views/tabs/statistics_tab_view.dart';
import '../../../home/presentation/views/tabs/profile_tab_view.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // allows the body to go behind the floating bar
      body: Obx(() => IndexedStack(
            index: controller.currentTab.value,
            children: [
              const HomeView(),
              WorkoutTabView(),
              const ExerciseTabView(),
              const StatisticsTabView(),
              const ProfileTabView(),
            ],
          )),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
                      _buildNavItem(Icons.fitness_center_outlined, Icons.fitness_center, 'Workout', 1),
                      _buildNavItem(Icons.directions_run_outlined, Icons.directions_run, 'Exercise', 2),
                      _buildNavItem(Icons.bar_chart_outlined, Icons.bar_chart, 'Stats', 3),
                      _buildNavItem(Icons.person_outline, Icons.person, 'Profile', 4),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData activeIcon, String label, int index) {
    bool isSelected = controller.currentTab.value == index;
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? Colors.white : Colors.grey[400],
              size: 24,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

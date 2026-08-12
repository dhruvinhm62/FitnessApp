import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../controllers/settings_controller.dart';
import '../widgets/settings_expansion_tile.dart';
import 'package:fitness_app/core/widgets/custom_back_button.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

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
            centerTitle: true,
            leading: const CustomBackButton(color: AppColors.white),
            iconTheme: const IconThemeData(color: AppColors.white),
            title: const Text(
              'SETTINGS',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'APP SETTINGS',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        Obx(
                          () => SwitchListTile(
                            title: const Text(
                              'Enable Notification',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                            ),
                            value: controller.notificationsEnabled.value,
                            onChanged: controller.toggleNotifications,
                            activeThumbColor: AppColors.black,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                          ),
                        ),
                        Obx(() {
                          if (controller.notificationsEnabled.value) {
                            return Column(
                              children: [
                                const Divider(height: 1, color: Color(0xFFE0E0E0)),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                                  title: const Text('Workout Reminder', style: TextStyle(fontSize: 14, color: AppColors.black)),
                                  trailing: GestureDetector(
                                    onTap: () async {
                                      final TimeOfDay? picked = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: const ColorScheme.light(
                                                primary: AppColors.black, 
                                                onPrimary: AppColors.white, 
                                                onSurface: AppColors.black, 
                                              ),
                                              textButtonTheme: TextButtonThemeData(
                                                style: TextButton.styleFrom(foregroundColor: AppColors.black),
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (picked != null) {
                                        controller.setWorkoutReminderTime(picked.format(context));
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        controller.workoutReminderTime.value,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(height: 1, color: Color(0xFFE0E0E0)),
                                SwitchListTile(
                                  title: const Text(
                                    'Achievement Notifications',
                                    style: TextStyle(fontSize: 14, color: AppColors.black),
                                  ),
                                  value: controller.achievementNotifications.value,
                                  onChanged: controller.toggleAchievementNotifications,
                                  activeThumbColor: AppColors.black,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                ),
                                const Divider(height: 1, color: Color(0xFFE0E0E0)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Water Reminder', style: TextStyle(fontSize: 14, color: AppColors.black)),
                                      DropdownButton<String>(
                                        value: controller.waterReminderFrequency.value,
                                        underline: const SizedBox(),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.black),
                                        icon: const Icon(Icons.arrow_drop_down, color: AppColors.black),
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            controller.setWaterReminderFrequency(newValue);
                                          }
                                        },
                                        items: <String>['Off', 'Every 1 hour', 'Every 2 hours', 'Every 4 hours']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
                        Obx(
                          () => SwitchListTile(
                            title: const Text(
                              'Haptic feedback',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                            ),
                            value: controller.hapticFeedback.value,
                            onChanged: controller.toggleHapticFeedback,
                            activeThumbColor: AppColors.black,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
                        Obx(
                          () => SwitchListTile(
                            title: const Text(
                              'Keep awake during use',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                            ),
                            value: controller.keepAwake.value,
                            onChanged: controller.toggleKeepAwake,
                            activeThumbColor: AppColors.black,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 12.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Use metric units',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                              ),
                              Obx(
                                () => CupertinoSlidingSegmentedControl<bool>(
                                  backgroundColor: Colors.grey[200]!,
                                  thumbColor: Colors.white,
                                  groupValue: controller.useMetricUnits.value,
                                  children: {
                                    false: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      child: Text(
                                        'Lbs',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              !controller.useMetricUnits.value
                                              ? Colors.black
                                              : Colors.grey[700],
                                          fontWeight:
                                              !controller.useMetricUnits.value
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    true: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      child: Text(
                                        'Kg',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: controller.useMetricUnits.value
                                              ? Colors.black
                                              : Colors.grey[700],
                                          fontWeight:
                                              controller.useMetricUnits.value
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  },
                                  onValueChanged: (value) {
                                    if (value != null)
                                      controller.setMetricUnits(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'USER PREFERENCES',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        Obx(
                          () => SettingsExpansionTile(
                            title: 'Experience Level',
                            selectedOption: controller.exerciseLevel.value,
                            onChanged: controller.setExerciseLevel,
                            customExpandedChild: Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
                              child: Column(
                                children: [
                                  _buildExperienceCard('Beginner', 'Lifting for the past year or less', Icons.signal_cellular_alt_1_bar, controller.exerciseLevel.value, controller.setExerciseLevel),
                                  _buildExperienceCard('Intermediate', 'Lifting for more than the past year, but less than 4 years', Icons.signal_cellular_alt_2_bar, controller.exerciseLevel.value, controller.setExerciseLevel),
                                  _buildExperienceCard('Advanced', 'Lifting for the past 4 years or more', Icons.signal_cellular_alt, controller.exerciseLevel.value, controller.setExerciseLevel),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => SettingsExpansionTile(
                            title: 'Workout Type',
                            selectedOption: controller.workoutPlan.value,
                            onChanged: controller.setWorkoutPlan,
                            customExpandedChild: Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
                              child: Column(
                                children: [
                                  _buildWorkoutTypeCard('Home', 'Bodyweight exercises only', Icons.home, controller.workoutPlan.value, controller.setWorkoutPlan),
                                  _buildWorkoutTypeCard('Semi Equipped', 'Dumbbells and resistance bands', Icons.fitness_center, controller.workoutPlan.value, controller.setWorkoutPlan),
                                  _buildWorkoutTypeCard('Fully Equipped Gym', 'Access to machines and barbells', Icons.domain, controller.workoutPlan.value, controller.setWorkoutPlan),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => SettingsExpansionTile(
                            title: 'Workout Days',
                            selectedOption: controller.workoutDays.value,
                            onChanged: controller.setWorkoutDays,
                            customExpandedChild: Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 24),
                              child: Row(
                                children: [
                                  _buildDayCard('3 Days', Icons.battery_4_bar, controller.workoutDays.value, controller.setWorkoutDays),
                                  const SizedBox(width: 12),
                                  _buildDayCard('4 Days', Icons.fitness_center, controller.workoutDays.value, controller.setWorkoutDays),
                                  const SizedBox(width: 12),
                                  _buildDayCard('5 Days', Icons.local_fire_department, controller.workoutDays.value, controller.setWorkoutDays),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(String title, String subtitle, IconData icon, String selectedValue, Function(String) onSelect) {
    final isSelected = selectedValue == title;
    return GestureDetector(
      onTap: () => onSelect(title),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Icon(icon, color: AppColors.black, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.black : Colors.grey[400]!,
                  width: isSelected ? 5 : 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutTypeCard(String title, String subtitle, IconData icon, String selectedValue, Function(String) onSelect) {
    final isSelected = selectedValue == title;
    return GestureDetector(
      onTap: () => onSelect(title),
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
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.black : Colors.grey[400]!,
                  width: isSelected ? 5 : 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(String title, IconData icon, String selectedValue, Function(String) onSelect) {
    final isSelected = selectedValue == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
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
              Icon(icon, color: isSelected ? AppColors.white : AppColors.black, size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12, 
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
}

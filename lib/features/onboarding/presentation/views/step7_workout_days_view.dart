import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_header.dart';

class Step7WorkoutDaysView extends GetView<OnboardingController> {
  const Step7WorkoutDaysView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const OnboardingHeader(step: 7, title: 'Workout Days'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      'How many days per week?',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    _buildCard('3 Days', 'Good for beginners or busy schedules', Icons.battery_4_bar),
                    const SizedBox(height: 16),
                    _buildCard('4 Days', 'Ideal for building muscle and strength', Icons.fitness_center),
                    const SizedBox(height: 16),
                    _buildCard('5 Days', 'Maximum results for dedicated lifters', Icons.local_fire_department),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.workoutDays.value.isNotEmpty) {
                      controller.finishOnboarding();
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('COMPLETE ONBOARDING'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, IconData icon) {
    return Obx(() {
      final isSelected = controller.workoutDays.value == title;
      return GestureDetector(
        onTap: () => controller.workoutDays.value = title,
        child: Container(
          padding: EdgeInsets.all(isSelected ? 19.0 : 20.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey[400]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: Icon(icon, color: Colors.black, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey[400]!,
                    width: isSelected ? 6 : 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

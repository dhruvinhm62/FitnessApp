import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_header.dart';

class Step5ExperienceView extends GetView<OnboardingController> {
  const Step5ExperienceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const OnboardingHeader(step: 5, title: 'Experience Level'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      'What is your experience level with lifting?',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    _buildExperienceCard('None', 'Currently not lifting', Icons.do_not_disturb_on_total_silence),
                    const SizedBox(height: 16),
                    _buildExperienceCard('Beginner', 'Lifting for the past year or less', Icons.signal_cellular_alt_1_bar),
                    const SizedBox(height: 16),
                    _buildExperienceCard('Intermediate', 'Lifting for more than the past year, but less than 4 years', Icons.signal_cellular_alt_2_bar),
                    const SizedBox(height: 16),
                    _buildExperienceCard('Advanced', 'Lifting for the past 4 years or more', Icons.signal_cellular_alt),
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
                    if (controller.experienceLevel.value.isNotEmpty) {
                      controller.nextToWorkoutType();
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('NEXT'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceCard(String title, String subtitle, IconData icon) {
    return Obx(() {
      final isSelected = controller.experienceLevel.value == title;
      return GestureDetector(
        onTap: () => controller.experienceLevel.value = title,
        child: Container(
          padding: EdgeInsets.all(isSelected ? 19.0 : 20.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey[400]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(4),
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

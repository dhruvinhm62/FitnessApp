import 'package:fitness_app/core/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';

class OnboardingHeader extends StatelessWidget {
  final int step;
  final int totalSteps;
  final String title;

  const OnboardingHeader({super.key, required this.step, required this.title, this.totalSteps = 7});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: CustomBackButton(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: step / totalSteps,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
          minHeight: 4,
        ),
      ],
    );
  }
}

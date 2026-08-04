import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/custom_height_picker.dart';

class Step3HeightView extends GetView<OnboardingController> {
  const Step3HeightView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const OnboardingHeader(step: 3, title: 'Height'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      'What is your height?',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    _buildSegmentedControl(),
                    const Spacer(),
                    _buildHeightPicker(),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: controller.nextToWeight,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text('NEXT'),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Obx(() {
      return Center(
        child: CupertinoSlidingSegmentedControl<String>(
          backgroundColor: Colors.grey[200]!,
          thumbColor: Colors.white,
          groupValue: controller.heightUnit.value,
          children: {
            'ft/in': Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                'Feet and Inches',
                style: TextStyle(
                  color: controller.heightUnit.value == 'ft/in' ? Colors.black : Colors.grey[700],
                  fontWeight: controller.heightUnit.value == 'ft/in' ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            'cm': Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                'Centimeters',
                style: TextStyle(
                  color: controller.heightUnit.value == 'cm' ? Colors.black : Colors.grey[700],
                  fontWeight: controller.heightUnit.value == 'cm' ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          },
          onValueChanged: (value) {
            if (value != null) controller.heightUnit.value = value;
          },
        ),
      );
    });
  }

  Widget _buildHeightPicker() {
    return const CustomHeightPicker();
  }
}

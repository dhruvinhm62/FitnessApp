import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/custom_date_picker.dart';

class Step2DobView extends GetView<OnboardingController> {
  const Step2DobView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize date if null
    if (controller.dob.value == null) {
      controller.dob.value = DateTime(1996, 6, 15);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const OnboardingHeader(step: 2, title: 'Date of Birth'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      'When were you born?',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 250,
                      child: CustomDatePicker(
                        initialDate: controller.dob.value ?? DateTime(1996, 6, 15),
                        onDateChanged: (DateTime newDate) {
                          controller.dob.value = newDate;
                        },
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (controller.dob.value != null) {
                          controller.nextToHeight();
                        }
                      },
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
}

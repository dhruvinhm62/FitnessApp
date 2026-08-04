import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/horizontal_ruler_slider.dart';

class Step4WeightView extends GetView<OnboardingController> {
  const Step4WeightView({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.weightValue.value.isEmpty) {
      controller.weightValue.value = '183'; // default
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const OnboardingHeader(step: 4, title: 'Weight'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      'What is your weight?',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    _buildSegmentedControl(),
                    const Spacer(),
                    Obx(() => Text(
                          '${controller.weightValue.value} ${controller.weightUnit.value}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 100,
                      child: Obx(() {
                        bool isKg = controller.weightUnit.value == 'kg';
                        return HorizontalRulerSlider(
                          key: ValueKey(controller.weightUnit.value), // force rebuild on unit change
                          min: isKg ? 30 : 60,
                          max: isKg ? 200 : 400,
                          initialValue: int.tryParse(controller.weightValue.value) ?? (isKg ? 75 : 183),
                          onChanged: (val) {
                            controller.weightValue.value = val.toString();
                          },
                        );
                      }),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: controller.nextToExperience,
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
          groupValue: controller.weightUnit.value,
          children: {
            'lbs': Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                'Pounds',
                style: TextStyle(
                  color: controller.weightUnit.value == 'lbs' ? Colors.black : Colors.grey[700],
                  fontWeight: controller.weightUnit.value == 'lbs' ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            'kg': Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                'Kilograms',
                style: TextStyle(
                  color: controller.weightUnit.value == 'kg' ? Colors.black : Colors.grey[700],
                  fontWeight: controller.weightUnit.value == 'kg' ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          },
          onValueChanged: (value) {
            if (value != null) {
              controller.weightUnit.value = value;
              controller.weightValue.value = value == 'kg' ? '75' : '183';
            }
          },
        ),
      );
    });
  }
}

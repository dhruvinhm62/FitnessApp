import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weight_tracker_controller.dart';
import '../../../../core/constants/app_colors.dart';
import 'weight_logging_bottom_sheet.dart';
import 'weight_history_view.dart';

class WeightTrackerView extends StatelessWidget {
  WeightTrackerView({super.key});

  final WeightTrackerController controller = Get.put(WeightTrackerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'WEIGHT TRACKER',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppColors.white),
            onPressed: () => Get.to(() => WeightHistoryView()),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildMainWeightCard(),
                      const SizedBox(height: 32),
                      _buildInfoCards(),
                    ],
                  ),
                ),
              ),
            ),
            _buildLogButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMainWeightCard() {
    return Container(
      height: 320, // Make it a bit taller to look superb
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.black, width: 2),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(8, 8), // More pronounced shadow for "superb" brutalism
            blurRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.scale, size: 64, color: AppColors.black),
            const SizedBox(height: 24),
            Obx(() {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      controller.currentWeight.value.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: AppColors.black,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'lbs',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.flag, color: AppColors.black, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'GOAL',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${controller.goalWeight.value}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'lbs',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.rocket_launch, color: AppColors.black, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'START',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${controller.startWeight.value}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'lbs',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Get.bottomSheet(
              const WeightLoggingBottomSheet(),
              isScrollControlled: true,
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text('LOG WEIGHT'),
          ),
        ),
      ),
    );
  }
}

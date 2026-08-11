import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/water_intake_controller.dart';
import '../widgets/wave_progress_indicator.dart';
import 'drink_logging_view.dart';
import 'water_goal_bottom_sheet.dart';
import '../../../../core/constants/app_colors.dart';

class WaterIntakeView extends StatelessWidget {
  WaterIntakeView({super.key});

  final WaterIntakeController controller = Get.put(WaterIntakeController());

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
          'WATER TRACKER',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🔥 ', style: TextStyle(fontSize: 12)),
                    Obx(
                      () => Text(
                        '${controller.streakDays.value}-DAY STREAK',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppColors.black,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMainWaveCard(),
              const SizedBox(height: 32),
              _buildInfoCards(context),
              const SizedBox(height: 32),
              _buildHistorySection(),
              _buildDrinkButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainWaveCard() {
    return Container(
      height: 280,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // The Blue Wave
            Positioned.fill(
              child: Obx(() {
                double percentage =
                    controller.currentIntake.value / controller.dailyGoal.value;
                return WaveProgressIndicator(
                  percentage: percentage.clamp(0.0, 1.0),
                );
              }),
            ),
            // The Text Container
            Center(
              child: Obx(() {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
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
                        controller.currentIntake.value.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: AppColors.black,
                          letterSpacing: -2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'L',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              _showUpdateTargetBottomSheet(context);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
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
                      Icon(Icons.flag, color: AppColors.black, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'TARGET',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.edit, color: AppColors.black, size: 16),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    double pct =
                        (controller.currentIntake.value /
                            controller.dailyGoal.value) *
                        100;
                    return FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${controller.dailyGoal.value}L',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${pct.toStringAsFixed(0)}%)',
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
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
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, color: AppColors.black, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'NEXT',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '06:00',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'PM',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HISTORY',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: Obx(() {
            if (controller.history.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    "No history yet.",
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
            return Scrollbar(
              controller: controller.historyScrollController,
              thumbVisibility: true,
              thickness: 6,
              radius: const Radius.circular(3),
              child: ListView.separated(
                controller: controller.historyScrollController,
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: controller.history.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final amount = controller.history[index];
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 85,
                      height: 100,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.water_drop,
                            color: AppColors.black,
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '+${amount}L',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDrinkButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => DrinkLoggingView());
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text('+ ADD DRINK'),
        ),
      ),
    );
  }

  void _showUpdateTargetBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return WaterGoalBottomSheet(
          initialGoal: controller.dailyGoal.value,
          onSave: (newGoal) {
            controller.dailyGoal.value = newGoal;
          },
        );
      },
    );
  }
}

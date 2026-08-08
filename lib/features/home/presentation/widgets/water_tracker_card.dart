import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/home_controller.dart';
import '../../../water_intake/presentation/views/water_intake_view.dart';

class WaterTrackerCard extends StatelessWidget {
  final HomeController controller;
  
  const WaterTrackerCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => WaterIntakeView());
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
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.water_drop_outlined,
                        color: AppColors.black,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Water',
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Today',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${controller.waterIntake.value}',
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'L',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: (controller.waterIntake.value / controller.waterGoal.value).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Goal: ${controller.waterGoal.value}L',
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${(controller.waterGoal.value - controller.waterIntake.value).toStringAsFixed(1)}L left',
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
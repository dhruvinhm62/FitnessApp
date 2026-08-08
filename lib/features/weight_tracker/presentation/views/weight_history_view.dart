import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/weight_tracker_controller.dart';
import '../../../../core/constants/app_colors.dart';

class WeightHistoryView extends StatelessWidget {
  WeightHistoryView({super.key});

  final WeightTrackerController controller = Get.find<WeightTrackerController>();

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
          'WEIGHT HISTORY',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.history.isEmpty) {
          return const Center(
            child: Text(
              'No weight logs yet.',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.grey, fontSize: 16),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          itemCount: controller.history.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final log = controller.history[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.monitor_weight_outlined, color: AppColors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${log.weight} lbs',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM d, yyyy • h:mm a').format(log.timestamp),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 28),
                    onPressed: () => controller.deleteLog(index),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}

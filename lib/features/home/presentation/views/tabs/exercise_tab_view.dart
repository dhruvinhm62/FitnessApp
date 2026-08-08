import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../controllers/exercise_tab_controller.dart';
import 'widgets/exercise_filter_dialog.dart';

class ExerciseTabView extends GetView<ExerciseTabController> {
  const ExerciseTabView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ExerciseTabController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.black,
            elevation: 0,
            toolbarHeight: 60,
            automaticallyImplyLeading: false,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () {
                if (Get.isRegistered<DashboardController>()) {
                  Get.find<DashboardController>().changeTab(0);
                }
              },
            ),
            title: Text(
              'EXERCISES',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: AppColors.black,
                  child: Container(
                    height: 220,
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 12,),
                        const Text(
                          'Exercise Library',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'YOU CAN FIND ALL EXERCISE HERE',
                          style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 1.5),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        // Search Bar Pill
                        Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: controller.searchController,
                                  onChanged: controller.updateSearch,
                                  decoration: const InputDecoration(
                                    hintText: 'Search Exercises',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              Obx(() {
                                if (controller.searchQuery.value.isNotEmpty) {
                                  return GestureDetector(
                                    onTap: controller.clearSearch,
                                    child: Icon(Icons.close, color: Colors.grey[600], size: 20),
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Filter Button Pill
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.dialog(const ExerciseFilterDialog(), useSafeArea: false);
                            },
                            icon: const Icon(
                              Icons.tune,
                              color: AppColors.white,
                              size: 20,
                            ),
                            label: const Text(
                              'Filter & Sort',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.black,
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: const BorderSide(
                                  color: AppColors.white,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.exercises.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 165),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        const Text(
                          'No exercise found',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 24,
                  bottom: 120,
                ),
                itemCount: controller.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = controller.exercises[index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('/exercise-details', arguments: exercise);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                      children: [
                        // Square image with rounded corners
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            exercise.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Title
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                exercise.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Target Muscle Group',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Outline Play Button
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.black,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: AppColors.black,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ));
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

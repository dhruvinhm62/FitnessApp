import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/presentation/controllers/workout_tab_controller.dart';
import '../controllers/workout_detail_controller.dart';
import '../../data/models/workout_models.dart';
import 'active_workout_view.dart';
import 'package:fitness_app/core/widgets/custom_back_button.dart';

class WorkoutDetailView extends StatelessWidget {
  final WorkoutDay workoutDay;

  const WorkoutDetailView({super.key, required this.workoutDay});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkoutDetailController(workoutDay: workoutDay));

    // Extract day number from title, e.g., "Day 1 - Full Body" -> "1"
    String dayNumber = "1";
    if (workoutDay.title.toLowerCase().contains("day ")) {
      final parts = workoutDay.title.toLowerCase().split("day ");
      if (parts.length > 1) {
        dayNumber = parts[1].split(" ")[0];
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.session.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.black),
          );
        }

        final session = controller.session.value!;
        final warmups = session.exercises.where((e) => e.isWarmup).toList();
        final workouts = session.exercises.where((e) => !e.isWarmup).toList();

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.black,
              elevation: 0,
              toolbarHeight: 60,
              centerTitle: true,
              leading: CustomBackButton(color: AppColors.white),
              title: Text(
                "WORKOUT",
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
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 16,
                      bottom: 40,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Workout Day $dayNumber",
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "HOME FOCUS",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 8,
                      bottom: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                            listTileTheme: const ListTileThemeData(
                              dense: true,
                              minVerticalPadding: 0,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            tilePadding: EdgeInsets.zero,
                            iconColor: AppColors.black,
                            collapsedIconColor: AppColors.black,
                            title: Padding(
                              padding: EdgeInsets.zero,
                              child: Row(
                                children: [
                                  const Text(
                                    'Warmup',
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Flex(
                                          direction: Axis.horizontal,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: List.generate(
                                            (constraints.constrainWidth() / 8)
                                                .floor(),
                                            (index) => const SizedBox(
                                              width: 4,
                                              height: 1.5,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            children: warmups
                                .map(
                                  (e) => _buildDismissibleExerciseItem(
                                    e,
                                    controller,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                            listTileTheme: const ListTileThemeData(
                              dense: true,
                              minVerticalPadding: 0,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            tilePadding: EdgeInsets.zero,
                            iconColor: AppColors.black,
                            collapsedIconColor: AppColors.black,
                            title: Padding(
                              padding: EdgeInsets.zero,
                              child: Row(
                                children: [
                                  const Text(
                                    "Workout",
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Flex(
                                          direction: Axis.horizontal,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: List.generate(
                                            (constraints.constrainWidth() / 8)
                                                .floor(),
                                            (index) => const SizedBox(
                                              width: 4,
                                              height: 1.5,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            children: workouts
                                .map(
                                  (e) => _buildDismissibleExerciseItem(
                                    e,
                                    controller,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Center(
                          child: TextButton.icon(
                            onPressed: () =>
                                _showAddExerciseDialog(context, controller),
                            icon: const Icon(
                              Icons.add,
                              color: AppColors.black,
                              size: 20,
                            ),
                            label: const Text(
                              'Add Exercise',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Bottom Actions
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final tabController = Get.find<WorkoutTabController>();
                              tabController.markDayStatus(workoutDay, 'completed');
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child: const Text('COMPLETE THE WORKOUT'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              final tabController = Get.find<WorkoutTabController>();
                              tabController.markDayStatus(workoutDay, 'skipped');
                              Get.back();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Text('SKIP THE WORKOUT'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              final tabController = Get.find<WorkoutTabController>();
                              tabController.markDayStatus(workoutDay, '');
                              Get.back();
                            },
                            child: const Text(
                              'Reset Day?',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDismissibleExerciseItem(
    Exercise exercise,
    WorkoutDetailController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Slidable(
        key: Key(exercise.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            CustomSlidableAction(
              onPressed: (context) {
                controller.deleteExercise(exercise.id);
              },
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.zero,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 20),
              ),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            final index = controller.session.value!.exercises.indexOf(exercise);
            Get.to(
              () => ActiveWorkoutView(
                session: controller.session.value!,
                initialExerciseIndex: index,
              ),
            );
          },
          child: Container(
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
                  child: Stack(
                    children: [
                      exercise.imageUrl.isNotEmpty
                          ? Image.network(
                              exercise.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.fitness_center,
                                color: AppColors.black,
                              ),
                            ),
                      if (exercise.status == 'completed')
                        Container(
                          width: 60,
                          height: 60,
                          color: const Color(0xFF34C759).withValues(alpha: 0.7), // green
                          child: const Center(
                            child: Icon(Icons.check, color: AppColors.white),
                          ),
                        ),
                      if (exercise.status == 'skipped')
                        Container(
                          width: 60,
                          height: 60,
                          color: const Color(0xFF007AFF).withValues(alpha: 0.7), // blue
                          child: const Center(
                            child: Icon(Icons.close_rounded, color: AppColors.white),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Title and sets
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
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${exercise.targetSets.length} working sets',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
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
                    border: Border.all(color: AppColors.black, width: 2),
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
          ),
        ),
      ),
    );
  }

  void _showAddExerciseDialog(
    BuildContext context,
    WorkoutDetailController controller,
  ) {
    controller.searchQuery.value = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.only(
            top: 12,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Exercise',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => controller.searchQuery.value = value,
                decoration: InputDecoration(
                  hintText: 'Search exercise...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: AppColors.black),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  final exercises = controller.filteredExercises;
                  if (exercises.isEmpty) {
                    return const Center(
                      child: Text(
                        'No exercises found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: exercises.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      return GestureDetector(
                        onTap: () {
                          controller.addExercise(exercise);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
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
                              Expanded(
                                child: Text(
                                  exercise.name,
                                  style: const TextStyle(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.add_circle_outline,
                                color: AppColors.black,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

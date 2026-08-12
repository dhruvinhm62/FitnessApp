import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/workout_models.dart';
import '../controllers/active_workout_controller.dart';
import 'package:fitness_app/core/widgets/custom_back_button.dart';

class ActiveWorkoutView extends StatelessWidget {
  final WorkoutSession session;
  final int initialExerciseIndex;

  const ActiveWorkoutView({
    super.key,
    required this.session,
    this.initialExerciseIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ActiveWorkoutController(
        session: session,
        initialExerciseIndex: initialExerciseIndex,
      ),
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.black,
          elevation: 0,
          centerTitle: true,
          leading: CustomBackButton(color: AppColors.white),
          title: const Text(
            'WORKOUT DETAILS',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.white,
            labelColor: AppColors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Workout'),
              Tab(text: 'Details'),
              Tab(text: 'Notes'),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoadingNext.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.black),
            );
          }
          return TabBarView(
            children: [
              _WorkoutTab(session: session),
              const _DetailsTab(),
              const _NotesTab(),
            ],
          );
        }),
        // No floating bottom timer – shown inline per-set
        bottomNavigationBar: null,
      ),
    );
  }
}


class _WorkoutTab extends GetView<ActiveWorkoutController> {
  final WorkoutSession session;

  const _WorkoutTab({required this.session});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Video Header
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Container(
              color: AppColors.black,
              child: Obx(() {
                if (controller.isVideoInitialized.value &&
                    controller.chewieController != null) {
                  return _CustomVideoPlayer(
                    chewieController: controller.chewieController!,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.white),
                  );
                }
              }),
            ),
          ),

          Obx(() {
            if (controller.currentExerciseIndex.value >=
                session.exercises.length) {
              return const Center(child: Text('Workout Complete'));
            }
            final exercise =
                session.exercises[controller.currentExerciseIndex.value];

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                      border: const Border(
                        left: BorderSide(color: AppColors.black, width: 4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                exercise.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: AppColors.black,
                                  height: 1.6,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sets List
                  ...List.generate(controller.currentSets.length, (index) {
                    final set = controller.currentSets[index];
                    final defaultExpanded =
                        !set.isCompleted &&
                        (index == 0 ||
                            controller.currentSets[index - 1].isCompleted);
                    bool isExpanded;
                    final manualId = controller.manuallyExpandedSetId.value;
                    if (manualId == null) {
                      isExpanded = defaultExpanded;
                    } else if (manualId == 'none') {
                      isExpanded = false;
                    } else {
                      isExpanded = manualId == set.id;
                    }
                    return _buildSetCard(
                      context,
                      controller,
                      index,
                      set,
                      isExpanded,
                    );
                  }),

                  const SizedBox(height: 12),

                  // Add Set button
                  Center(
                    child: TextButton.icon(
                      onPressed: controller.addSet,
                      icon: const Icon(
                        Icons.add,
                        color: AppColors.black,
                        size: 20,
                      ),
                      label: const Text(
                        'Add Set',
                        style: TextStyle(color: AppColors.black, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bottom Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => controller.nextExercise(),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text('FINISH & NEXT'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => controller.skipExercise(),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text('SKIP THE EXERCISE'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSetCard(
    BuildContext context,
    ActiveWorkoutController controller,
    int index,
    WorkoutSet set,
    bool isExpanded,
  ) {
    Color bgColor = set.isWarmup ? Colors.grey[200]! : AppColors.white;
    String setTitle = set.isWarmup
        ? 'Warmup Set ${set.setNumber}'
        : 'Working Set ${set.setNumber}';

    Widget collapsedChild = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
        border: !set.isWarmup ? Border.all(color: Colors.grey[300]!) : null,
      ),
      child: Row(
        children: [
          Text(
            setTitle,
            style: const TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${set.reps} reps',
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (set.isCompleted) ...[
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: AppColors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          GestureDetector(
            onTap: () => controller.toggleSetExpanded(set.id, isExpanded),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );

    // Expanded Card
    Widget expandedChild = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
        border: !set.isWarmup ? Border.all(color: Colors.grey[300]!) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                setTitle,
                style: const TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => controller.toggleSetExpanded(set.id, isExpanded),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    color: AppColors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _buildInputBox(
                  'WEIGHT (lbs)',
                  set.weight.toStringAsFixed(0),
                  () => controller.updateSetWeight(index, -5),
                  () => controller.updateSetWeight(index, 5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputBox(
                  'REPS',
                  set.reps.toString(),
                  () => controller.updateSetReps(index, -1),
                  () => controller.updateSetReps(index, 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'REPS IN RESERVE',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => _showRirBottomSheet(context),
                child: Text(
                  'WHAT\'S RIR?',
                  style: TextStyle(
                    color: AppColors.black.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildRirBox(
                  '0',
                  set.rir == 0,
                  () => controller.updateSetRir(index, 0),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildRirBox(
                  '1',
                  set.rir == 1,
                  () => controller.updateSetRir(index, 1),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildRirBox(
                  '2',
                  set.rir == 2,
                  () => controller.updateSetRir(index, 2),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildRirBox(
                  '3',
                  set.rir == 3,
                  () => controller.updateSetRir(index, 3),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildRirBox(
                  '4+',
                  set.rir == 4,
                  () => controller.updateSetRir(index, 4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.completeSet(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  (!set.isWarmup ? 'Save & start rest timer' : 'Save')
                      .toUpperCase(),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedCrossFade(
          firstChild: collapsedChild,
          secondChild: expandedChild,
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
          firstCurve: Curves.easeInOut,
          secondCurve: Curves.easeInOut,
          sizeCurve: Curves.easeInOut,
          alignment: Alignment.topCenter,
        ),
        // Timer shown BELOW the card (visible even when card is collapsed)
        if (!set.isWarmup)
          Obx(() {
            final isActive = controller.isTimerActive.value &&
                controller.activeRestSetIndex.value == index;
            if (!isActive) return const SizedBox.shrink();

            final duration = controller.timerSeconds.value;
            final mins = (duration / 60).floor();
            final secs = (duration % 60).toString().padLeft(2, '0');
            final progress = controller.maxTimerSeconds.value > 0
                ? duration / controller.maxTimerSeconds.value
                : 0.0;

            return Container(
              margin: const EdgeInsets.only(top: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Left: time + label stacked
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$mins:$secs',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFeatures: [FontFeature.tabularFigures()],
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Rest Timer',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Right: SKIP | −15s | 15s+
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: controller.skipRest,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white24, width: 1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'SKIP',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => controller.adjustRestTimer(-15),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.remove,
                                      color: AppColors.white, size: 13),
                                  SizedBox(width: 3),
                                  Text(
                                    '15s',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => controller.adjustRestTimer(15),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '15s',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                  Icon(Icons.add,
                                      color: AppColors.white, size: 13),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.white),
                    ),
                  ),
                ],
              ),
            );
          }),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildInputBox(
    String label,
    String value,
    VoidCallback onMinus,
    VoidCallback onPlus,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove,
                  color: AppColors.black,
                  size: 20,
                ),
                onPressed: onMinus,
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.black, size: 20),
                onPressed: onPlus,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRirBox(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? AppColors.black : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }

  void _showRirBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 24), // Balance the close button
                const Expanded(
                  child: Text(
                    'What is RIR (Reps in Reserve)?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: AppColors.black),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Reps in reserve is a subjective measurement which has you estimating how many additional reps you\'d be able to perform at the end of your set. We use RIR to quantify effort (proximity to failure).',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            _buildRirInfoCard('0 REPS', 'I can\'t do any more reps.', '0'),
            const SizedBox(height: 8),
            _buildRirInfoCard('1 REP', 'I can do 1 more rep.', '1'),
            const SizedBox(height: 8),
            _buildRirInfoCard('2 REPS', 'I can do 2 more reps.', '2'),
            const SizedBox(height: 8),
            _buildRirInfoCard('3 REPS', 'I can do 3 more reps.', '3'),
            const SizedBox(height: 8),
            _buildRirInfoCard('4 REPS', 'I can do 4+ more reps.', '4+'),
            const SizedBox(height: 24), // padding for bottom edge
          ],
        ),
      ),
    );
  }

  Widget _buildRirInfoCard(String title, String subtitle, String number) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            number,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsTab extends GetView<ActiveWorkoutController> {
  const _DetailsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildExpandableSection(
            title: 'Setting up',
            isExpanded: controller.isSettingUpExpanded,
            onToggle: controller.toggleSettingUp,
            children: [
              _buildNumberedText(
                '1',
                'While standing under a pull-up bar, reach up and grab it with a slightly wider than shoulder-width overhand grip.',
              ),
              _buildNumberedText(
                '2',
                'Take your feet off the floor and hang with your arms straight.',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildExpandableSection(
            title: 'Exercise technique',
            isExpanded: controller.isTechniqueExpanded,
            onToggle: controller.toggleTechnique,
            children: [
              _buildNumberedText(
                '1',
                'Keeping your legs straight, engage your core and raise your legs up in front of you.',
              ),
              _buildNumberedText(
                '2',
                'Raise your legs until they form a 90-degree angle with your torso.',
              ),
              _buildNumberedText(
                '3',
                'Slowly lower your legs back to the starting position.',
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Target Muscles',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildMuscleCard('Abs', 'Primary')),
              const SizedBox(width: 16),
              Expanded(child: _buildMuscleCard('Obliques', 'Secondary')),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Support Equipment',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildEquipmentCard(Icons.fitness_center, 'Straight Pull-Up Bar'),
          const SizedBox(height: 12),
          _buildEquipmentCard(
            Icons.fitness_center_outlined,
            'Multi-Grip Pull-Up Bar',
          ),
          const SizedBox(height: 24),
          const Text(
            'Details',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            Icons.fitness_center,
            'Difficulty Level',
            'Intermediate',
            'Requires a basic level of core strength and stability.',
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.repeat,
            'Suggested Reps',
            '8 - 12',
            'Perform 8 to 12 repetitions per set for optimal hypertrophy.',
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.timer_outlined,
            'Suggested Rest',
            '60s',
            'Rest for 60 seconds between sets to allow muscle recovery.',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required RxBool isExpanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(
                    () => Icon(
                      isExpanded.value
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: isExpanded.value
                  ? Column(
                      children: [
                        Divider(height: 1, color: Colors.grey[200]),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: children,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(width: double.infinity, height: 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedText(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.black,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuscleCard(String name, String type) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.accessibility_new, color: AppColors.black),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                type,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentCard(IconData icon, String name) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.black),
          const SizedBox(width: 16),
          Text(
            name,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(icon, color: Colors.grey[600], size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      value,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesTab extends GetView<ActiveWorkoutController> {
  const _NotesTab();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          if (controller.notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_document, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'No notes yet',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your\nfirst note for this exercise.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20).copyWith(bottom: 100),
            itemCount: controller.notes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final note = controller.notes[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note.description,
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${note.date.day}/${note.date.month}/${note.date.year}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          );
        }),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            onPressed: () => _showAddNoteDialog(),
            backgroundColor: AppColors.black,
            child: const Icon(Icons.add, color: AppColors.white),
          ),
        ),
      ],
    );
  }

  void _showAddNoteDialog() {
    final titleController = TextEditingController();
    final noteController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        backgroundColor: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Add Note',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: titleController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Title is required'
                      : null,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: noteController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Note is required'
                      : null,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('CANCEL'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            controller.addNote(
                              titleController.text,
                              noteController.text,
                            );
                            Get.back();
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('SAVE'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomVideoPlayer extends StatefulWidget {
  final ChewieController chewieController;
  final bool isFullScreenRoute;

  const _CustomVideoPlayer({
    required this.chewieController,
    this.isFullScreenRoute = false,
  });

  @override
  State<_CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<_CustomVideoPlayer> {
  bool _showControls = true;
  Timer? _hideTimer;

  VideoPlayerController get _controller =>
      widget.chewieController.videoPlayerController;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_videoListener);
    _startHideTimer();
  }

  void _videoListener() {
    if (mounted) {
      final value = _controller.value;
      if (value.position >= value.duration && value.duration > Duration.zero) {
        _showControls = true;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _hideTimer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls && _controller.value.isPlaying) {
      _startHideTimer();
    } else {
      _hideTimer?.cancel();
    }
  }

  void _skip(int seconds) {
    final position = _controller.value.position;
    _controller.seekTo(position + Duration(seconds: seconds));
    _startHideTimer();
  }

  void _togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() => _showControls = true);
      _hideTimer?.cancel();
    } else {
      _controller.play();
      _startHideTimer();
    }
  }

  void _toggleMute() {
    final isMuted = _controller.value.volume == 0;
    _controller.setVolume(isMuted ? 1.0 : 0.0);
    _startHideTimer();
  }

  void _toggleFullscreen(BuildContext context) {
    if (widget.isFullScreenRoute) {
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      Navigator.of(context, rootNavigator: true).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: Center(
                  child: _CustomVideoPlayer(
                    chewieController: widget.chewieController,
                    isFullScreenRoute: true,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    _startHideTimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        children: [
          Chewie(controller: widget.chewieController),
          AnimatedOpacity(
            opacity: _showControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              color: Colors.black45,
              child: Stack(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.replay_10,
                            color: AppColors.white,
                            size: 40,
                          ),
                          onPressed: _showControls ? () => _skip(-10) : null,
                        ),
                        IconButton(
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: AppColors.white,
                            size: 60,
                          ),
                          onPressed: _showControls ? _togglePlay : null,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.forward_10,
                            color: AppColors.white,
                            size: 40,
                          ),
                          onPressed: _showControls ? () => _skip(10) : null,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 20,
                    right: 10,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                _controller.value.volume == 0
                                    ? Icons.volume_off
                                    : Icons.volume_up,
                                color: AppColors.white,
                                size: 28,
                              ),
                              onPressed: _showControls ? _toggleMute : null,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                colors: const VideoProgressColors(
                                  playedColor: AppColors.white,
                                  bufferedColor: Colors.white24,
                                  backgroundColor: Colors.white10,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                widget.isFullScreenRoute
                                    ? Icons.fullscreen_exit
                                    : Icons.fullscreen,
                                color: AppColors.white,
                                size: 28,
                              ),
                              onPressed: _showControls
                                  ? () => _toggleFullscreen(context)
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

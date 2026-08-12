import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'tabs/workout_tab_view.dart';
import 'tabs/statistics_tab_view.dart';
import 'my_profile_view.dart';
import 'member_spotlight_details_view.dart';
import '../../../weight_tracker/presentation/views/weight_tracker_view.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/water_tracker_card.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
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
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      'Hi, ${controller.userName.value}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.help_outline, color: AppColors.white),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildCurvedHeader(),
                const SizedBox(height: 24),
                _buildProgramStatus(),
                const SizedBox(height: 32),
                _buildCurrentStreak(),
                const SizedBox(height: 32),
                _buildHealthTrackers(),
                const SizedBox(height: 32),
                _buildMemberSpotlight(),
                const SizedBox(height: 150),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurvedHeader() {
    return Container(
      width: double.infinity,
      color: AppColors.black,
      child: Container(
        height: 220,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    controller.todayWorkoutLabel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      controller.currentWorkoutTitle.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (Get.isRegistered<DashboardController>()) {
                              Get.find<DashboardController>().changeTab(1);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(
                                color: AppColors.black,
                                width: 2,
                              ),
                            ),
                          ),
                          child: const Text(
                            'START WORKOUT',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.analytics_outlined, size: 20, color: AppColors.black),
              SizedBox(width: 8),
              Text(
                'PROGRAM STATUS',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  '${controller.daysRemaining.value} days remaining',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Obx(
                () => Text(
                  '${controller.percentComplete.value}% Complete',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 12,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.black),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.21,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStreak() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.local_fire_department_outlined,
                size: 20,
                color: AppColors.black,
              ),
              SizedBox(width: 8),
              Text(
                'CURRENT STREAK',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: controller.streakDays.map((day) {
                Color circleBg = Colors.white;
                Color borderColor = AppColors.black;
                double borderWidth = 1;
                Widget centerChild;

                if (day.isCompleted) {
                  circleBg = const Color(0xFF34C759); // green
                  borderColor = const Color(0xFF34C759);
                  centerChild = const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 18,
                  );
                } else if (day.isSkipped) {
                  circleBg = const Color(0xFF007AFF); // blue
                  borderColor = const Color(0xFF007AFF);
                  centerChild = const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 18,
                  );
                } else if (day.isToday) {
                  circleBg = Colors.white;
                  borderColor = AppColors.black;
                  borderWidth = 3;
                  centerChild = Text(
                    '${day.date}',
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  );
                } else {
                  // future
                  circleBg = Colors.white;
                  borderColor = Colors.grey.shade300;
                  centerChild = Text(
                    '${day.date}',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  );
                }

                return Column(
                  children: [
                    Text(
                      day.day,
                      style: TextStyle(
                        color: day.isCompleted || day.isSkipped
                            ? AppColors.black
                            : day.isToday
                                ? AppColors.black
                                : Colors.grey.shade400,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: circleBg,
                        border: Border.all(
                          color: borderColor,
                          width: borderWidth,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: centerChild,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTrackers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.monitor_heart_outlined,
                size: 20,
                color: AppColors.black,
              ),
              SizedBox(width: 8),
              Text(
                'HEALTH TRACKERS',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Obx(() {
                  bool isPositive = controller.weightProgress.value < 0;
                  IconData trendIcon = isPositive
                      ? Icons.trending_down
                      : Icons.trending_up;
                  return GestureDetector(
                    onTap: () => Get.to(() => WeightTrackerView()),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Row(
                                children: [
                                  Icon(
                                    Icons.monitor_weight_outlined,
                                    color: AppColors.black,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Weight',
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '7 Days',
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
                                '${controller.currentWeight.value}',
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'lbs',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    trendIcon,
                                    color: AppColors.black,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${controller.weightProgress.value.abs()} lbs',
                                    style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildMiniBar(12),
                                  _buildMiniBar(16),
                                  _buildMiniBar(20),
                                  _buildMiniBar(24),
                                  _buildMiniBar(18),
                                  _buildMiniBar(28),
                                  _buildMiniBar(32, isToday: true),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 16),
              Expanded(child: WaterTrackerCard(controller: controller)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBar(double height, {bool isToday = false}) {
    return Container(
      width: 4,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: isToday
            ? AppColors.black
            : AppColors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildMemberSpotlight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(Icons.star_outline, size: 20, color: AppColors.black),
              SizedBox(width: 8),
              Text(
                'MEMBER SPOTLIGHT',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 240,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
              itemCount: controller.spotlights.length,
              itemBuilder: (context, index) {
                final spotlight = controller.spotlights[index];

                return GestureDetector(
                  onTap: () => Get.to(
                    () => MemberSpotlightDetailsView(spotlight: spotlight),
                  ),
                  child: Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 16),
                    clipBehavior: Clip.antiAlias,
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Image section
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Image.network(
                                  spotlight.beforeImageUrl,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                ),
                              ),
                              Container(width: 2, color: AppColors.black),
                              Expanded(
                                child: Image.network(
                                  spotlight.afterImageUrl,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Text section
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppColors.black, width: 2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                spotlight.name,
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: AppColors.black,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);

    // Create a curvy wave at the bottom
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(
      size.width - (size.width / 4),
      size.height - 60,
    );
    var secondEndPoint = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

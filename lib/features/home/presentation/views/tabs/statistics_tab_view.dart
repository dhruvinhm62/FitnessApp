import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controllers/home_controller.dart';
import 'dart:math' as math;

class StatisticsTabView extends StatelessWidget {
  const StatisticsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // We try to find the HomeController to use real data for trackers
    final HomeController controller = Get.isRegistered<HomeController>() 
        ? Get.find<HomeController>() 
        : Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.black,
            elevation: 0,
            toolbarHeight: 60,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'STATISTICS',
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
                _buildHeader(controller),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 24,
                    bottom: 120,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.bar_chart, size: 20, color: AppColors.black),
                          SizedBox(width: 8),
                          Text(
                            'WEEKLY ACTIVITY',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Week 3, Aug 2026',
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildWeeklyActivityChart(),
                      const SizedBox(height: 32),
                      const Row(
                        children: [
                          Icon(Icons.fitness_center, size: 20, color: AppColors.black),
                          SizedBox(width: 8),
                          Text(
                            'TOP EXERCISES',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildPieChart(),
                      const SizedBox(height: 32),
                      const Row(
                        children: [
                          Icon(Icons.water_drop_outlined, size: 20, color: AppColors.black),
                          SizedBox(width: 8),
                          Text(
                            'WATER INTAKE',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildWaterGraph(),
                      const SizedBox(height: 32),
                      const Row(
                        children: [
                          Icon(Icons.scale_outlined, size: 20, color: AppColors.black),
                          SizedBox(width: 8),
                          Text(
                            'WEIGHT TRACKER',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildWeightGraph(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(HomeController controller) {
    return Container(
      width: double.infinity,
      color: AppColors.black,
      child: Container(
        height: 220,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.monitor_heart_outlined, size: 20, color: AppColors.white),
                SizedBox(width: 8),
                Text(
                  'HEALTH TRACKERS',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.black, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Obx(() {
                    bool isPositive = controller.weightProgress.value < 0;
                    IconData trendIcon = isPositive
                        ? Icons.trending_down
                        : Icons.trending_up;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.scale_outlined, color: AppColors.black, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Weight',
                                  style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {},
                              child: const Icon(Icons.add_circle_outline, color: AppColors.black, size: 20),
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
                            const Text('lbs', style: TextStyle(color: AppColors.black, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(trendIcon, color: AppColors.black, size: 16),
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
                      ],
                    );
                  }),
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
                  ),
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.water_drop_outlined, color: AppColors.black, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Water',
                                  style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {},
                              child: const Icon(Icons.add_circle_outline, color: AppColors.black, size: 20),
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
                            const Text('L', style: TextStyle(color: AppColors.black, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.black, width: 1),
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
                      ],
                    );
                  }),
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

  Widget _buildWeeklyActivityChart() {
    return Container(
      height: 250,
      padding: const EdgeInsets.only(top: 20, right: 20, left: 10, bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('10k', style: TextStyle(color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('5k', style: TextStyle(color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('0', style: TextStyle(color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(width: 8),
                Container(width: 1, color: Colors.grey[300]),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildActivityBar(0.4, 0.3),
                            _buildActivityBar(0.7, 0.4),
                            _buildActivityBar(0.5, 0.5),
                            _buildActivityBar(0.9, 0.6, isHighlighted: true),
                            _buildActivityBar(0.6, 0.6),
                            _buildActivityBar(0.3, 0.6),
                            _buildActivityBar(0.8, 0.7),
                          ],
                        ),
                      ),
                      Container(height: 1, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Mon', style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                          Text('Tue', style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                          Text('Wed', style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                          Text('Thu', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                          Text('Fri', style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                          Text('Sat', style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                          Text('Sun', style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 10, height: 10, color: AppColors.black),
              const SizedBox(width: 4),
              const Text('Exercise Count', style: TextStyle(fontSize: 10, color: AppColors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              Container(width: 10, height: 10, color: Colors.grey[300]),
              const SizedBox(width: 4),
              const Text('Weight', style: TextStyle(fontSize: 10, color: AppColors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityBar(double workoutFactor, double weightFactor, {bool isHighlighted = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FractionallySizedBox(
          heightFactor: workoutFactor,
          child: Container(
            width: 8,
            decoration: BoxDecoration(
              color: isHighlighted ? AppColors.black : Colors.grey[800],
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
            ),
          ),
        ),
        const SizedBox(width: 2),
        FractionallySizedBox(
          heightFactor: weightFactor,
          child: Container(
            width: 8,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(value: 1.0, strokeWidth: 20, color: Colors.grey[200]),
                CircularProgressIndicator(value: 0.9, strokeWidth: 20, color: Colors.grey[300]),
                CircularProgressIndicator(value: 0.8, strokeWidth: 20, color: Colors.grey[400]),
                CircularProgressIndicator(value: 0.7, strokeWidth: 20, color: Colors.grey[500]),
                CircularProgressIndicator(value: 0.55, strokeWidth: 20, color: Colors.grey[700]),
                CircularProgressIndicator(value: 0.4, strokeWidth: 20, color: Colors.grey[800]),
                const CircularProgressIndicator(value: 0.25, strokeWidth: 20, color: AppColors.black),
                const Text(
                  'Top 6',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPieLegend('Squats', '25%', AppColors.black),
                const SizedBox(height: 8),
                _buildPieLegend('Deadlifts', '15%', Colors.grey[800]!),
                const SizedBox(height: 8),
                _buildPieLegend('Bench Press', '15%', Colors.grey[700]!),
                const SizedBox(height: 8),
                _buildPieLegend('Pull Ups', '15%', Colors.grey[500]!),
                const SizedBox(height: 8),
                _buildPieLegend('OH Press', '10%', Colors.grey[400]!),
                const SizedBox(height: 8),
                _buildPieLegend('Barbell Row', '10%', Colors.grey[300]!),
                const SizedBox(height: 8),
                _buildPieLegend('Others', '10%', Colors.grey[200]!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieLegend(String title, String percent, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.black, width: 1),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        Text(
          percent,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildWaterGraph() {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildWaterBar(0.5),
                _buildWaterBar(0.8),
                _buildWaterBar(0.6),
                _buildWaterBar(1.0, isHighlighted: true),
                _buildWaterBar(0.4),
                _buildWaterBar(0.7),
                _buildWaterBar(0.9),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Mon', style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold)),
              Text('Tue', style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold)),
              Text('Wed', style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold)),
              Text('Thu', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)),
              Text('Fri', style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold)),
              Text('Sat', style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold)),
              Text('Sun', style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaterBar(double heightFactor, {bool isHighlighted = false}) {
    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: Container(
        width: 16,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.black, width: 2),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isHighlighted)
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightGraph() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: CustomPaint(
        painter: LineChartPainter(),
        child: Container(),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = AppColors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.16, size.height * 0.7),
      Offset(size.width * 0.33, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.6),
      Offset(size.width * 0.66, size.height * 0.4),
      Offset(size.width * 0.83, size.height * 0.45),
      Offset(size.width, size.height * 0.2),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);

    for (final point in points) {
      canvas.drawCircle(point, 5, dotPaint);
      canvas.drawCircle(point, 5, dotBorderPaint);
    }
    
    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 1;
      
    for (int i = 1; i < 4; i++) {
      canvas.drawLine(
        Offset(0, size.height * (i / 4)), 
        Offset(size.width, size.height * (i / 4)), 
        gridPaint
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

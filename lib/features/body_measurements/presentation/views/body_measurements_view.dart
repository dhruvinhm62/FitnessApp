import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../controllers/body_measurements_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/body_measurement_entry.dart';
import '../../../../core/widgets/custom_back_button.dart';
import 'log_measurement_bottom_sheet.dart';

class BodyMeasurementsView extends StatelessWidget {
  BodyMeasurementsView({super.key});

  final BodyMeasurementsController controller = Get.put(BodyMeasurementsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        toolbarHeight: 60,
        centerTitle: true,
        leading: const CustomBackButton(color: AppColors.white),
        title: const Text(
          'BODY MEASUREMENTS',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGraphWidget(),
            const SizedBox(height: 24),
            const Text(
              'History',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 16),
            _buildHistoryList(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8, top: 8),
          child: _buildLogButton(),
        ),
      ),
    );
  }


  Widget _buildHistoryList() {
    return Obx(() {
      if (controller.entries.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text('No measurements logged.', style: TextStyle(color: Colors.grey)),
          ),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.entries.length,
        itemBuilder: (context, index) {
          final entry = controller.entries[controller.entries.length - 1 - index];
          return _MeasurementCard(entry: entry);
        },
      );
    });
  }


  Widget _buildLogButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.bottomSheet(
            const LogMeasurementBottomSheet(),
            isScrollControlled: true,
          );
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text('+ LOG MEASUREMENT', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildGraphWidget() {
    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Container(
      height: 280,
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('50', style: TextStyle(color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('40', style: TextStyle(color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('30', style: TextStyle(color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('20', style: TextStyle(color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('10', style: TextStyle(color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: MultiLineChartPainter(
                                  labels.length,
                                  const [
                                    AppColors.black,      // Fat %
                                    Colors.redAccent,     // Chest
                                    Colors.blueAccent,    // Waist
                                    Colors.green,         // Hips
                                    Colors.orange,        // Arms
                                  ],
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: List.generate(labels.length, (index) {
                                  final tooltipKey = GlobalKey<TooltipState>();
                                  
                                  double hFat = (math.sin(index * 1.5 + 0) * 0.1) + 0.2 - (index * 0.02);
                                  double valFat = 50 - (hFat.clamp(0.1, 0.9) * 40);
                                  
                                  double hChest = (math.sin(index * 1.5 + 1) * 0.1) + 0.35 - (index * 0.02);
                                  double valChest = 50 - (hChest.clamp(0.1, 0.9) * 40);
                                  
                                  double hWaist = (math.sin(index * 1.5 + 2) * 0.1) + 0.5 - (index * 0.02);
                                  double valWaist = 50 - (hWaist.clamp(0.1, 0.9) * 40);
                                  
                                  double hHips = (math.sin(index * 1.5 + 3) * 0.1) + 0.65 - (index * 0.02);
                                  double valHips = 50 - (hHips.clamp(0.1, 0.9) * 40);
                                  
                                  double hArms = (math.sin(index * 1.5 + 4) * 0.1) + 0.8 - (index * 0.02);
                                  double valArms = 50 - (hArms.clamp(0.1, 0.9) * 40);

                                  String msg = 'Fat %: ${valFat.toStringAsFixed(1)}\n'
                                      'Chest: ${valChest.toStringAsFixed(1)}\n'
                                      'Waist: ${valWaist.toStringAsFixed(1)}\n'
                                      'Hips: ${valHips.toStringAsFixed(1)}\n'
                                      'Arms: ${valArms.toStringAsFixed(1)}';

                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        tooltipKey.currentState?.ensureTooltipVisible();
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          children: [
                                            FractionallySizedBox(
                                              heightFactor: 0.5,
                                              child: Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Tooltip(
                                                  key: tooltipKey,
                                                  message: msg,
                                                  triggerMode: TooltipTriggerMode.manual,
                                                  preferBelow: false,
                                                  verticalOffset: 10,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black87,
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  textStyle: const TextStyle(
                                                    color: AppColors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  child: const SizedBox(
                                                    width: 4,
                                                    height: 4,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(height: 1, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: labels.map((lbl) {
                          return Expanded(
                            child: Center(
                              child: Text(
                                lbl,
                                style: const TextStyle(
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildLegendItem(AppColors.black, 'Fat %'),
              _buildLegendItem(Colors.redAccent, 'Chest'),
              _buildLegendItem(Colors.blueAccent, 'Waist'),
              _buildLegendItem(Colors.green, 'Hips'),
              _buildLegendItem(Colors.orange, 'Arms'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _MeasurementCard extends StatefulWidget {
  final BodyMeasurementEntry entry;
  const _MeasurementCard({required this.entry});

  @override
  State<_MeasurementCard> createState() => _MeasurementCardState();
}

class _MeasurementCardState extends State<_MeasurementCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMMM d, yyyy').format(widget.entry.date),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.entry.bodyFat != null ? '${widget.entry.bodyFat}% Body Fat' : 'Measurements logged',
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.black,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.black, width: 2)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMetric('Chest', widget.entry.chest),
                  _buildMetric('Waist', widget.entry.waist),
                  _buildMetric('Hips', widget.entry.hips),
                  _buildMetric('Arms', widget.entry.arms),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, double? value) {
    if (value == null) return const SizedBox.shrink();
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class MultiLineChartPainter extends CustomPainter {
  final int pointsCount;
  final double horizontalPadding;
  final List<Color> lineColors;

  MultiLineChartPainter(this.pointsCount, this.lineColors, {this.horizontalPadding = 16.0});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 1;

    for (int i = 1; i < 4; i++) {
      canvas.drawLine(
        Offset(0, size.height * (i / 4)),
        Offset(size.width, size.height * (i / 4)),
        gridPaint,
      );
    }

    final double availableWidth = size.width - (horizontalPadding * 2);

    for (int l = 0; l < lineColors.length; l++) {
      final paint = Paint()
        ..color = lineColors[l]
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final dotPaint = Paint()
        ..color = AppColors.white
        ..style = PaintingStyle.fill;

      final dotBorderPaint = Paint()
        ..color = lineColors[l]
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      final List<Offset> points = [];
      for (int i = 0; i < pointsCount; i++) {
        double x = pointsCount > 1
            ? horizontalPadding + (availableWidth / (pointsCount - 1)) * i
            : size.width / 2;
            
        double baseHeight = 0.2 + (l * 0.15);
        double h = (math.sin(i * 1.5 + l) * 0.1) + baseHeight - (i * 0.02);
        
        points.add(Offset(x, size.height * h.clamp(0.1, 0.9)));
      }

      if (points.isNotEmpty) {
        final path = Path();
        path.moveTo(points[0].dx, points[0].dy);
        for (int i = 1; i < points.length; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }
        canvas.drawPath(path, paint);

        for (final point in points) {
          canvas.drawCircle(point, 4, dotPaint);
          canvas.drawCircle(point, 4, dotBorderPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant MultiLineChartPainter oldDelegate) {
    return oldDelegate.pointsCount != pointsCount || oldDelegate.lineColors != lineColors;
  }
}


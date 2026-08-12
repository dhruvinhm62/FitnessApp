import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
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
            _buildHistoryList(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 8),
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

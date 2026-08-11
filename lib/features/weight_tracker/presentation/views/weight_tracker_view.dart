import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/weight_tracker_controller.dart';
import '../../../../core/constants/app_colors.dart';
import 'weight_logging_bottom_sheet.dart';
import 'dart:math' as math;
import 'weight_history_view.dart';
import '../../../home/presentation/controllers/home_controller.dart';

class WeightTrackerView extends StatelessWidget {
  WeightTrackerView({super.key});

  final WeightTrackerController controller = Get.put(WeightTrackerController());

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
          'WEIGHT TRACKER',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppColors.white),
            onPressed: () => Get.to(() => WeightHistoryView()),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildMainWeightCard(context),
                    SizedBox(height: 4),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSectionHeader(
                            'WEIGHT & GOAL',
                            Icons.scale_outlined,
                            controller.weightFilter,
                            context,
                          ),
                          const SizedBox(height: 16),
                          _buildGraphWidget(controller.weightFilter),
                          const SizedBox(height: 32),
                          _buildSectionHeader(
                            'WEIGHT GRAPH',
                            Icons.show_chart,
                            controller.weightLineFilter,
                            context,
                          ),
                          const SizedBox(height: 16),
                          _buildWeightLineGraphWidget(controller.weightLineFilter),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _buildLogButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMainWeightCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 24, left: 20, right: 20),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          // Current Weight Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.scale_outlined,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'CURRENT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          controller.currentWeight.value.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                            letterSpacing: -1.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'lbs',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 10, color: Colors.grey),
                        const SizedBox(width: 4),
                        Obx(() => Text(
                          controller.history.isNotEmpty
                              ? DateFormat('MMM d').format(controller.history.first.timestamp).toUpperCase()
                              : 'TODAY',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 0.5,
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Goal Weight Card
          Expanded(
            child: GestureDetector(
              onTap: () => _showUpdateGoalBottomSheet(context),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.flag_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'GOAL',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.edit, size: 16, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            controller.goalWeight.value.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                              letterSpacing: -1.5,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'lbs',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 10, color: Colors.grey),
                          const SizedBox(width: 4),
                          Obx(() => Text(
                            DateFormat('MMM d').format(controller.lastGoalUpdated.value).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 0.5,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
     ),
    );
  }

  void _showUpdateGoalBottomSheet(BuildContext context) {
    Get.bottomSheet(
      WeightLoggingBottomSheet(
        title: 'UPDATE GOAL',
        initialWeight: controller.goalWeight.value,
        onSave: (weight) {
          controller.goalWeight.value = weight;
          controller.lastGoalUpdated.value = DateTime.now();
        },
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildSectionHeader(
    String title,
    IconData icon,
    ChartFilterState filterState,
    BuildContext context,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.black),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => _showTimePickerBottomSheet(context, filterState),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.tune, color: AppColors.black, size: 14),
                const SizedBox(width: 6),
                Obx(
                  () => Text(
                    filterState.formattedFilterText,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.black,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildWeightLineGraphWidget(ChartFilterState filterState) {
    return Container(
      height: 250,
      padding: const EdgeInsets.only(top: 20, right: 20, left: 10, bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '150 lbs',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '145 lbs',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '140 lbs',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '135 lbs',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    final labels = _getXAxisLabels(
                      filterState.filterMode.value,
                    );
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: LineChartPainter(labels.length),
                          ),
                        ),
                        Positioned.fill(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: List.generate(labels.length, (index) {
                              double h = (math.sin(index * 1.5) * 0.15) + 0.6 - (index * 0.05);
                              double val = 150 - (h.clamp(0.1, 0.9) * 15);
                              final tooltipKey = GlobalKey<TooltipState>();
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
                                          heightFactor: h.clamp(0.1, 0.9),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Tooltip(
                                              key: tooltipKey,
                                              message: '${val.toStringAsFixed(1)} lbs',
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
                                              child: const SizedBox(width: 4, height: 4),
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
                    );
                  }),
                ),
                const SizedBox(height: 4),
                Container(height: 1, color: Colors.grey[300]),
                const SizedBox(height: 8),
                Obx(() {
                  final labels = _getXAxisLabels(filterState.filterMode.value);
                  return Row(
                    children: labels
                        .map(
                          (lbl) => Expanded(
                            child: Text(
                              lbl,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildGraphWidget(ChartFilterState filterState) {
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '150 lbs',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '145 lbs',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '140 lbs',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '135 lbs',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Obx(() {
                          final labels = _getXAxisLabels(
                            filterState.filterMode.value,
                          );
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: List.generate(labels.length, (index) {
                              double actualFactor = (math.sin(index * 1.5) * 0.15) + 0.6 - (index * 0.05);
                              double goalFactor = 0.5;
                              double actualVal = 135 + (actualFactor.clamp(0.1, 1.0) * 15);
                              double goalVal = 135 + (goalFactor.clamp(0.1, 1.0) * 15);

                              final tooltipKey = GlobalKey<TooltipState>();
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    tooltipKey.currentState?.ensureTooltipVisible();
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    alignment: Alignment.bottomCenter,
                                    child: Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        _buildWeightBar(
                                          actualFactor.clamp(0.1, 1.0),
                                          goalFactor.clamp(0.1, 1.0),
                                        ),
                                        Tooltip(
                                          key: tooltipKey,
                                          message: 'Actual: ${actualVal.toStringAsFixed(1)} lbs\nGoal: ${goalVal.toStringAsFixed(1)} lbs',
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
                                          child: const SizedBox(width: 4, height: 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        }),
                      ),
                      const SizedBox(height: 4),
                      Container(height: 1, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      Obx(() {
                        final labels = _getXAxisLabels(filterState.filterMode.value);
                        return Row(
                          children: labels
                              .map(
                                (lbl) => Expanded(
                                  child: Text(
                                    lbl,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppColors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }),
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
              const Text(
                'Actual Weight',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Container(width: 10, height: 10, color: Colors.grey[300]),
              const SizedBox(width: 4),
              const Text(
                'Goal Weight',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeightBar(
    double actualFactor,
    double goalFactor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FractionallySizedBox(
          heightFactor: actualFactor,
          child: Container(
            width: 8,
            decoration: const BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 2),
        FractionallySizedBox(
          heightFactor: goalFactor,
          child: Container(
            width: 8,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Get.bottomSheet(
              WeightLoggingBottomSheet(
                title: 'LOG WEIGHT',
                initialWeight: controller.currentWeight.value,
                onSave: (weight) {
                  controller.logWeight(weight);
                },
              ),
              isScrollControlled: true,
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text('LOG WEIGHT'),
          ),
        ),
      ),
    );
  }

  List<String> _getXAxisLabels(TimeFilterMode mode) {
    switch (mode) {
      case TimeFilterMode.weekly:
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case TimeFilterMode.monthly:
        return ['Q1', 'Q2', 'Q3', 'Q4'];
      case TimeFilterMode.yearly:
        return ['Q1', 'Q2', 'Q3', 'Q4'];
      case TimeFilterMode.allTime:
        return ['2023', '2024', '2025', '2026'];
    }
  }

  void _showTimePickerBottomSheet(
    BuildContext context,
    ChartFilterState filterState,
  ) {
    TimeFilterMode tempMode = filterState.filterMode.value;
    int tempYear = filterState.selectedYear.value;
    int tempMonth = filterState.selectedMonth.value;
    int tempWeek = filterState.selectedWeekNumber.value > 4
        ? 4
        : filterState.selectedWeekNumber.value;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              padding: EdgeInsets.only(
                top: 12,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).padding.bottom + 8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Time Period',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: TimeFilterMode.values.map((mode) {
                      final isSelected = tempMode == mode;

                      String modeLabel = '';
                      switch (mode) {
                        case TimeFilterMode.weekly:
                          modeLabel = 'Weekly';
                          break;
                        case TimeFilterMode.monthly:
                          modeLabel = 'Monthly';
                          break;
                        case TimeFilterMode.yearly:
                          modeLabel = 'Yearly';
                          break;
                        case TimeFilterMode.allTime:
                          modeLabel = 'All Time';
                          break;
                      }

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              tempMode = mode;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: modeLabel == "Weekly" ? 0 : 8,
                            ),
                            height: 48,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.black
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.black
                                    : Colors.grey[300]!,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              modeLabel,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (tempMode != TimeFilterMode.allTime) ...[
                    const SizedBox(height: 16),
                    Builder(
                      builder: (context) {
                        if (tempMode == TimeFilterMode.weekly) {
                          return Row(
                            children: [
                              Expanded(
                                child: _buildLabeledDropdown(
                                  label: 'Year',
                                  value: tempYear,
                                  items: List.generate(
                                    10,
                                    (i) => DateTime.now().year - 5 + i,
                                  ),
                                  labelMapper: (val) => '$val',
                                  onChanged: (val) =>
                                      setState(() => tempYear = val!),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildLabeledDropdown(
                                  label: 'Month',
                                  value: tempMonth,
                                  items: List.generate(12, (i) => i + 1),
                                  labelMapper: (val) => _getMonthName(val),
                                  onChanged: (val) =>
                                      setState(() => tempMonth = val!),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildLabeledDropdown(
                                  label: 'Week',
                                  value: tempWeek,
                                  items: List.generate(4, (i) => i + 1),
                                  labelMapper: (val) => 'Week $val',
                                  onChanged: (val) =>
                                      setState(() => tempWeek = val!),
                                ),
                              ),
                            ],
                          );
                        } else if (tempMode == TimeFilterMode.monthly) {
                          return Row(
                            children: [
                              Expanded(
                                child: _buildLabeledDropdown(
                                  label: 'Year',
                                  value: tempYear,
                                  items: List.generate(
                                    10,
                                    (i) => DateTime.now().year - 5 + i,
                                  ),
                                  labelMapper: (val) => '$val',
                                  onChanged: (val) =>
                                      setState(() => tempYear = val!),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildLabeledDropdown(
                                  label: 'Month',
                                  value: tempMonth,
                                  items: List.generate(12, (i) => i + 1),
                                  labelMapper: (val) => _getMonthName(val),
                                  onChanged: (val) =>
                                      setState(() => tempMonth = val!),
                                ),
                              ),
                            ],
                          );
                        } else if (tempMode == TimeFilterMode.yearly) {
                          return Row(
                            children: [
                              Expanded(
                                child: _buildLabeledDropdown(
                                  label: 'Year',
                                  value: tempYear,
                                  items: List.generate(
                                    10,
                                    (i) => DateTime.now().year - 5 + i,
                                  ),
                                  labelMapper: (val) => '$val',
                                  onChanged: (val) =>
                                      setState(() => tempYear = val!),
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      filterState.filterMode.value = tempMode;
                      filterState.selectedYear.value = tempYear;
                      filterState.selectedMonth.value = tempMonth;
                      filterState.selectedWeekNumber.value = tempWeek;
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('APPLY'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLabeledDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) labelMapper,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 8),
        _buildDropdown(
          value: value,
          items: items,
          labelMapper: labelMapper,
          onChanged: onChanged,
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) labelMapper,
    required void Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.black),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: AppColors.black,
          ),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(labelMapper(item)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final int pointsCount;
  final double horizontalPadding;

  LineChartPainter(this.pointsCount, {this.horizontalPadding = 16.0});

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

    final List<Offset> points = [];
    final double segmentWidth = size.width / pointsCount;
    for (int i = 0; i < pointsCount; i++) {
      double x = (segmentWidth * i) + (segmentWidth / 2);
      double h = (math.sin(i * 1.5) * 0.15) + 0.6 - (i * 0.05);
      points.add(Offset(x, size.height * h.clamp(0.1, 0.9)));
    }

    // Draw grid lines
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

    // Draw lines between points
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
      canvas.drawCircle(point, 4, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

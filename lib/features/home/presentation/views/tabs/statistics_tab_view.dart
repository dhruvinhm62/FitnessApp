import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../controllers/home_controller.dart';

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
                      _buildSectionHeader(
                        'ACTIVITY',
                        Icons.bar_chart,
                        controller.activityFilter,
                        context,
                      ),
                      const SizedBox(height: 16),
                      _buildWeeklyActivityChart(controller, controller.activityFilter),
                      const SizedBox(height: 32),
                      _buildSectionHeader(
                        'TOP EXERCISES',
                        Icons.fitness_center,
                        controller.topExercisesFilter,
                        context,
                      ),
                      const SizedBox(height: 16),
                      TopExercisesSection(filterState: controller.topExercisesFilter),
                      const SizedBox(height: 32),
                      _buildSectionHeader(
                        'WATER INTAKE',
                        Icons.water_drop_outlined,
                        controller.waterFilter,
                        context,
                      ),
                      const SizedBox(height: 16),
                      _buildWaterGraph(controller, controller.waterFilter),
                      const SizedBox(height: 32),
                      _buildSectionHeader(
                        'WEIGHT TRACKER',
                        Icons.scale_outlined,
                        controller.weightFilter,
                        context,
                      ),
                      const SizedBox(height: 16),
                      _buildWeightGraph(controller.weightFilter),
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

  List<String> _getXAxisLabels(TimeFilterMode mode) {
    switch (mode) {
      case TimeFilterMode.weekly:
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case TimeFilterMode.monthly:
        return ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
      case TimeFilterMode.yearly:
        return ['Quarter 1', 'Quarter 2', 'Quarter 3', 'Quarter 4'];
      case TimeFilterMode.allTime:
        return ['2023', '2024', '2025', '2026'];
    }
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
                bottom: MediaQuery.of(context).padding.bottom + 20,
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
                  const SizedBox(height: 24
                  ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
                Icon(
                  Icons.monitor_heart_outlined,
                  size: 20,
                  color: AppColors.white,
                ),
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
                                    Icon(
                                      Icons.scale_outlined,
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
                                InkWell(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.add_circle_outline,
                                    color: AppColors.black,
                                    size: 20,
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
                                InkWell(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.add_circle_outline,
                                    color: AppColors.black,
                                    size: 20,
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
                                widthFactor:
                                    (controller.waterIntake.value /
                                            controller.waterGoal.value)
                                        .clamp(0.0, 1.0),
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

  Widget _buildWeeklyActivityChart(HomeController controller, ChartFilterState filterState) {
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
                    Text(
                      '10k',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '5k',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '0',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Container(width: 1, color: Colors.grey[300]),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Obx(() {
                          final labels = _getXAxisLabels(
                            filterState.filterMode.value,
                          );
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(labels.length, (index) {
                              double factor1 = (math.sin(index) + 1.2) * 0.4;
                              double factor2 = (math.cos(index) + 1.2) * 0.4;
                              return _buildActivityBar(
                                factor1.clamp(0.1, 1.0),
                                factor2.clamp(0.1, 1.0),
                              );
                            }),
                          );
                        }),
                      ),
                      Container(height: 1, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      Obx(() {
                        final labels = _getXAxisLabels(
                          filterState.filterMode.value,
                        );
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: labels
                              .map(
                                (lbl) => Text(
                                  lbl,
                                  style: const TextStyle(
                                    color: AppColors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
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
                'Exercise Count',
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
                'Weight',
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

  Widget _buildActivityBar(
    double workoutFactor,
    double weightFactor, {
    bool isHighlighted = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FractionallySizedBox(
          heightFactor: workoutFactor,
          child: Container(
            width: 8,
            decoration: BoxDecoration(
              color: isHighlighted ? AppColors.black : Colors.grey[800],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
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

  Widget _buildWaterGraph(HomeController controller, ChartFilterState filterState) {
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
                    Text('10L', style: TextStyle(color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('5L', style: TextStyle(color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('0L', style: TextStyle(color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Obx(() {
                          final labels = _getXAxisLabels(filterState.filterMode.value);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(labels.length, (index) {
                              double drank = (math.sin(index * 2) + 1.5) * 4;
                              return _buildMultiIndicatorWaterBar(drank, 5.0, 10.0);
                            }),
                          );
                        }),
                      ),
                      Container(height: 1, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      Obx(() {
                        final labels = _getXAxisLabels(filterState.filterMode.value);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: labels.map((lbl) => Text(lbl, style: const TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold, fontSize: 12))).toList(),
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
              const Text('Drank', style: TextStyle(fontSize: 10, color: AppColors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              Container(width: 10, height: 10, color: Colors.grey[200]),
              const SizedBox(width: 4),
              const Text('Empty', style: TextStyle(fontSize: 10, color: AppColors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              Container(width: 10, height: 10, color: Colors.blue[400]),
              const SizedBox(width: 4),
              const Text('Over Goal', style: TextStyle(fontSize: 10, color: AppColors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMultiIndicatorWaterBar(double drank, double goal, double maxAmount) {
    bool isOverGoal = drank > goal;
    double bottomAmount = isOverGoal ? goal : drank;
    double topAmount = isOverGoal ? (drank - goal) : (goal - drank);
    double remainingSpace = maxAmount - (bottomAmount + topAmount);
    if (remainingSpace < 0) remainingSpace = 0;
    
    Color bottomColor = AppColors.black;
    Color topColor = isOverGoal ? Colors.blue[400]! : Colors.grey[200]!;

    return SizedBox(
      width: 16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (remainingSpace > 0)
            Expanded(
              flex: (remainingSpace * 100).toInt(),
              child: const SizedBox(),
            ),
          if (topAmount > 0)
            Expanded(
              flex: (topAmount * 100).toInt(),
              child: Container(
                decoration: BoxDecoration(
                  color: topColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                ),
              ),
            ),
          if (bottomAmount > 0)
            Expanded(
              flex: (bottomAmount * 100).toInt(),
              child: Container(
                decoration: BoxDecoration(
                  color: bottomColor,
                  borderRadius: topAmount == 0 
                      ? const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))
                      : BorderRadius.zero,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeightGraph(ChartFilterState filterState) {
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
              Text('150 lbs', style: TextStyle(color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              Text('145 lbs', style: TextStyle(color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              Text('140 lbs', style: TextStyle(color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              Text('135 lbs', style: TextStyle(color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    final labels = _getXAxisLabels(filterState.filterMode.value);
                    return CustomPaint(
                      painter: LineChartPainter(labels.length),
                      child: Container(),
                    );
                  }),
                ),
                const SizedBox(height: 4),
                Container(height: 1, color: Colors.grey[300]),
                const SizedBox(height: 8),
                Obx(() {
                  final labels = _getXAxisLabels(filterState.filterMode.value);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: labels
                          .map((lbl) => Text(lbl,
                              style: const TextStyle(
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)))
                          .toList(),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
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
    final double availableWidth = size.width - (horizontalPadding * 2);
    for (int i = 0; i < pointsCount; i++) {
      double x = pointsCount > 1 
          ? horizontalPadding + (availableWidth / (pointsCount - 1)) * i 
          : size.width / 2;
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
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    return oldDelegate.pointsCount != pointsCount;
  }
}

class TopExercisesSection extends StatefulWidget {
  final ChartFilterState filterState;
  const TopExercisesSection({super.key, required this.filterState});

  @override
  State<TopExercisesSection> createState() => _TopExercisesSectionState();
}

class _TopExercisesSectionState extends State<TopExercisesSection> {
  int touchedIndex = -1;

  List<Map<String, dynamic>> _getData(TimeFilterMode mode) {
    double shift = 0;
    switch (mode) {
      case TimeFilterMode.weekly: shift = 0; break;
      case TimeFilterMode.monthly: shift = 5.0; break;
      case TimeFilterMode.yearly: shift = -5.0; break;
      case TimeFilterMode.allTime: shift = 2.0; break;
    }

    return [
      {'title': 'Squats', 'percent': (25.0 + shift).clamp(10.0, 40.0), 'color': AppColors.black},
      {'title': 'Deadlifts', 'percent': (15.0 - shift * 0.5).clamp(5.0, 30.0), 'color': Colors.grey[800]!},
      {'title': 'Bench', 'percent': (15.0 + shift * 0.5).clamp(5.0, 30.0), 'color': Colors.grey[700]!},
      {'title': 'Pull Ups', 'percent': (15.0 - shift * 0.2).clamp(5.0, 30.0), 'color': Colors.grey[500]!},
      {'title': 'OH Press', 'percent': (10.0 + shift * 0.2).clamp(5.0, 30.0), 'color': Colors.grey[400]!},
      {'title': 'Others', 'percent': 20.0, 'color': Colors.grey[300]!},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
      child: Obx(() {
        final currentData = _getData(widget.filterState.filterMode.value);
        return Column(
          children: [
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex =
                            pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: _showingSections(currentData),
                ),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutQuart,
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                Row(
                  children: currentData.sublist(0, 3).map((item) {
                    int index = currentData.indexOf(item);
                    return Expanded(child: _buildLegendItem(index, item));
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: currentData.sublist(3, 6).map((item) {
                    int index = currentData.indexOf(item);
                    return Expanded(child: _buildLegendItem(index, item));
                  }).toList(),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLegendItem(int index, Map<String, dynamic> item) {
    final isTouched = index == touchedIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          touchedIndex = isTouched ? -1 : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isTouched ? AppColors.black : Colors.transparent,
          border: Border.all(
            color: isTouched ? AppColors.black : Colors.grey[300]!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: isTouched
              ? [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: isTouched ? AppColors.white : item['color'],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                '${item['title']}',
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: isTouched ? FontWeight.bold : FontWeight.w600,
                  fontSize: 11,
                  color: isTouched ? AppColors.white : AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections(List<Map<String, dynamic>> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 75.0 : 65.0;

      return PieChartSectionData(
        color: item['color'],
        value: item['percent'],
        title: '${item['percent'].toInt()}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
          shadows: const [Shadow(color: Colors.black26, blurRadius: 2)],
        ),
      );
    }).toList();
  }
}

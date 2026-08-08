import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/exercise_tab_controller.dart';
import '../../../../../../core/constants/app_colors.dart';

class ExerciseFilterDialog extends StatefulWidget {
  const ExerciseFilterDialog({super.key});

  @override
  State<ExerciseFilterDialog> createState() => _ExerciseFilterDialogState();
}

class _ExerciseFilterDialogState extends State<ExerciseFilterDialog> {
  final ExerciseTabController controller = Get.find<ExerciseTabController>();

  late String _sortBy;
  late List<String> _selectedEquipment;
  late List<String> _selectedDifficulty;

  bool _sortExpanded = true;
  bool _equipmentExpanded = false;
  bool _difficultyExpanded = false;

  @override
  void initState() {
    super.initState();
    _sortBy = controller.sortBy.value;
    _selectedEquipment = List.from(controller.selectedEquipment);
    _selectedDifficulty = List.from(controller.selectedDifficulty);
  }

  void _applyFilters() {
    controller.sortBy.value = _sortBy;
    controller.selectedEquipment.assignAll(_selectedEquipment);
    controller.selectedDifficulty.assignAll(_selectedDifficulty);
    controller.applyFilters();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Container(
          width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FILTER & SORT',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.black),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildExpandableSection(
                      title: 'SORT BY',
                      isExpanded: _sortExpanded,
                      onTap: () {
                        setState(() {
                          _sortExpanded = !_sortExpanded;
                        });
                      },
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['A-Z', 'Z-A', 'Newest added', 'Oldest added']
                            .map((option) {
                              final isSelected = _sortBy == option;
                              return FilterChip(
                                label: Text(option),
                                selected: isSelected,
                                selectedColor: AppColors.black,
                                checkmarkColor: AppColors.white,
                                backgroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  side: const BorderSide(
                                    color: AppColors.black,
                                    width: 2,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _sortBy = option;
                                    });
                                  }
                                },
                              );
                            })
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildExpandableSection(
                      title: 'EQUIPMENT',
                      isExpanded: _equipmentExpanded,
                      onTap: () {
                        setState(() {
                          _equipmentExpanded = !_equipmentExpanded;
                        });
                      },
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.equipmentOptions.map((option) {
                          final isSelected = _selectedEquipment.contains(
                            option,
                          );
                          return FilterChip(
                            label: Text(option),
                            selected: isSelected,
                            selectedColor: AppColors.black,
                            checkmarkColor: AppColors.white,
                            backgroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(
                                color: AppColors.black,
                                width: 2,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedEquipment.add(option);
                                } else {
                                  _selectedEquipment.remove(option);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildExpandableSection(
                      title: 'DIFFICULTY',
                      isExpanded: _difficultyExpanded,
                      onTap: () {
                        setState(() {
                          _difficultyExpanded = !_difficultyExpanded;
                        });
                      },
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.difficultyOptions.map((option) {
                          final isSelected = _selectedDifficulty.contains(
                            option,
                          );
                          return FilterChip(
                            label: Text(option),
                            selected: isSelected,
                            selectedColor: AppColors.black,
                            checkmarkColor: AppColors.white,
                            backgroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(
                                color: AppColors.black,
                                width: 2,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedDifficulty.add(option);
                                } else {
                                  _selectedDifficulty.remove(option);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _applyFilters,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('APPLY FILTERS'),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
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
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.black,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.black,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: child,
                  )
                : const SizedBox(width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }
}

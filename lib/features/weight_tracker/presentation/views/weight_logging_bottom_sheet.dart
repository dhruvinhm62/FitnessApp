import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weight_tracker_controller.dart';
import '../../../../core/constants/app_colors.dart';

class WeightLoggingBottomSheet extends StatefulWidget {
  const WeightLoggingBottomSheet({super.key});

  @override
  State<WeightLoggingBottomSheet> createState() =>
      _WeightLoggingBottomSheetState();
}

class _WeightLoggingBottomSheetState extends State<WeightLoggingBottomSheet> {
  final WeightTrackerController controller =
      Get.find<WeightTrackerController>();
  late TextEditingController _textController;
  String _selectedUnit = 'lbs'; // Local state for the unit toggle

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: controller.currentWeight.value.toString(),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.black, width: 2)),
      ),
      padding: EdgeInsets.only(top: 24, left: 24, right: 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'LOG WEIGHT',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.black,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Unit Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildUnitToggle('lbs'),
                const SizedBox(width: 16),
                _buildUnitToggle('kg'),
              ],
            ),
            const SizedBox(height: 24),

            // Input Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: AppColors.black,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  Text(
                    _selectedUnit,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final double? newWeight = double.tryParse(
                    _textController.text,
                  );
                  if (newWeight != null) {
                    // If they entered kg, convert it to lbs to store it consistently,
                    // or just store it. Our system currently expects lbs.
                    double finalWeight = newWeight;
                    if (_selectedUnit == 'kg') {
                      finalWeight = newWeight * 2.20462; // Convert kg to lbs
                    }

                    controller.logWeight(
                      double.parse(finalWeight.toStringAsFixed(1)),
                    );
                    Get.back();
                  } else {
                    Get.snackbar(
                      'Invalid Input',
                      'Please enter a valid weight number',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                    );
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
      ),
    );
  }

  Widget _buildUnitToggle(String unit) {
    bool isSelected = _selectedUnit == unit;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUnit = unit;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : AppColors.white,
          border: Border.all(color: AppColors.black, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          unit.toUpperCase(),
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../onboarding/presentation/widgets/horizontal_ruler_slider.dart';

class WeightLoggingBottomSheet extends StatefulWidget {
  final String title;
  final double initialWeight;
  final Function(double) onSave;

  const WeightLoggingBottomSheet({
    super.key,
    required this.title,
    required this.initialWeight,
    required this.onSave,
  });

  @override
  State<WeightLoggingBottomSheet> createState() =>
      _WeightLoggingBottomSheetState();
}

class _WeightLoggingBottomSheetState extends State<WeightLoggingBottomSheet> {
  String _selectedUnit = 'lbs'; // Local state for the unit toggle
  late int _weightValue;

  @override
  void initState() {
    super.initState();
    _weightValue = widget.initialWeight.round();
  }

  @override
  Widget build(BuildContext context) {
    bool isKg = _selectedUnit == 'kg';
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                letterSpacing: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Unit Toggle
            Center(
              child: CupertinoSlidingSegmentedControl<String>(
                backgroundColor: Colors.grey[200]!,
                thumbColor: Colors.white,
                groupValue: _selectedUnit,
                children: {
                  'lbs': Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text(
                      'Pounds',
                      style: TextStyle(
                        color: _selectedUnit == 'lbs' ? Colors.black : Colors.grey[700],
                        fontWeight: _selectedUnit == 'lbs' ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  'kg': Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text(
                      'Kilograms',
                      style: TextStyle(
                        color: _selectedUnit == 'kg' ? Colors.black : Colors.grey[700],
                        fontWeight: _selectedUnit == 'kg' ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedUnit = value;
                      _weightValue = value == 'kg' ? (widget.initialWeight / 2.20462).round() : widget.initialWeight.round();
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 32),

            // Weight Display
            Text(
              '$_weightValue $_selectedUnit',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            // Weight Slider
            SizedBox(
              height: 100,
              child: HorizontalRulerSlider(
                key: ValueKey(_selectedUnit), // force rebuild on unit change
                min: isKg ? 30 : 60,
                max: isKg ? 200 : 400,
                initialValue: _weightValue,
                onChanged: (val) {
                  setState(() {
                    _weightValue = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  double finalWeight = _weightValue.toDouble();
                  if (_selectedUnit == 'kg') {
                    finalWeight = finalWeight * 2.20462; // Convert kg to lbs
                  }

                  widget.onSave(double.parse(finalWeight.toStringAsFixed(1)));
                  Get.back();
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
}

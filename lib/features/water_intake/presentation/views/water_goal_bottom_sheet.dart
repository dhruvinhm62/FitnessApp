import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';

class WaterGoalBottomSheet extends StatefulWidget {
  final double initialGoal;
  final Function(double) onSave;

  const WaterGoalBottomSheet({
    super.key,
    required this.initialGoal,
    required this.onSave,
  });

  @override
  State<WaterGoalBottomSheet> createState() => _WaterGoalBottomSheetState();
}

class _WaterGoalBottomSheetState extends State<WaterGoalBottomSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialGoal.toStringAsFixed(1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'UPDATE TARGET',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                letterSpacing: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Text Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: TextField(
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  suffixText: 'L',
                  suffixStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  double newGoal = double.tryParse(_controller.text) ?? widget.initialGoal;
                  widget.onSave(newGoal);
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

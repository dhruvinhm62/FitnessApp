import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/body_measurements_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/body_measurement_entry.dart';
import 'dart:math';

class LogMeasurementBottomSheet extends StatefulWidget {
  const LogMeasurementBottomSheet({super.key});

  @override
  State<LogMeasurementBottomSheet> createState() => _LogMeasurementBottomSheetState();
}

class _LogMeasurementBottomSheetState extends State<LogMeasurementBottomSheet> {
  final BodyMeasurementsController controller = Get.find<BodyMeasurementsController>();
  final _formKey = GlobalKey<FormState>();

  double? bodyFat;
  double? chest;
  double? waist;
  double? hips;
  double? arms;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Log Measurements',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Body Fat (%)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onSaved: (v) => bodyFat = double.tryParse(v ?? ''),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Chest', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onSaved: (v) => chest = double.tryParse(v ?? ''),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Waist', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onSaved: (v) => waist = double.tryParse(v ?? ''),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Hips', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onSaved: (v) => hips = double.tryParse(v ?? ''),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Arms', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onSaved: (v) => arms = double.tryParse(v ?? ''),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      controller.addEntry(
                        BodyMeasurementEntry(
                          id: Random().nextInt(10000).toString(),
                          date: DateTime.now(),
                          bodyFat: bodyFat,
                          chest: chest,
                          waist: waist,
                          hips: hips,
                          arms: arms,
                        ),
                      );
                      Get.back();
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('SAVE MEASUREMENTS', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

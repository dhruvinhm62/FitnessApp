import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nutrition_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/nutrition_models.dart';
import 'dart:math';

class LogMealBottomSheet extends StatefulWidget {
  const LogMealBottomSheet({super.key});

  @override
  State<LogMealBottomSheet> createState() => _LogMealBottomSheetState();
}

class _LogMealBottomSheetState extends State<LogMealBottomSheet> {
  final NutritionController controller = Get.find<NutritionController>();
  final _formKey = GlobalKey<FormState>();

  String name = '';
  int calories = 0;
  double protein = 0;
  double carbs = 0;
  double fats = 0;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Log Meal',
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
              decoration: const InputDecoration(labelText: 'Food Name'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onSaved: (v) => name = v!,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Calories (kcal)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => calories = int.tryParse(v!) ?? 0,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Protein (g)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => protein = double.tryParse(v!) ?? 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Carbs (g)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => carbs = double.tryParse(v!) ?? 0,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Fats (g)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => fats = double.tryParse(v!) ?? 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    controller.addMeal(
                      FoodItem(
                        id: Random().nextInt(10000).toString(),
                        name: name,
                        calories: calories,
                        protein: protein,
                        carbs: carbs,
                        fats: fats,
                      ),
                    );
                    Get.back();
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('SAVE MEAL'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

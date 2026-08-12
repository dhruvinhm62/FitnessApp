import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nutrition_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_back_button.dart';
import '../../domain/models/nutrition_models.dart';
import 'log_meal_bottom_sheet.dart';

class NutritionDashboardView extends StatelessWidget {
  NutritionDashboardView({super.key});

  final NutritionController controller = Get.put(NutritionController());

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
          'NUTRITION',
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
            _buildMacroOverview(context),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Meals',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Get.bottomSheet(
                      const LogMealBottomSheet(),
                      isScrollControlled: true,
                    );
                  },
                  icon: const Icon(Icons.add, color: AppColors.black),
                  label: const Text('Log Meal', style: TextStyle(color: AppColors.black)),
                )
              ],
            ),
            const SizedBox(height: 16),
            _buildMealList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroOverview(BuildContext context) {
    return Obx(() {
      final t = controller.target.value;
      return Container(
        padding: const EdgeInsets.all(20),
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daily Targets',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showEditLimitsDialog(context, t),
                  child: const Icon(Icons.edit, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildMacroRing('Calories', controller.consumedCalories.value.toDouble(), t.targetCalories.toDouble(), AppColors.black)),
                Expanded(child: _buildMacroRing('Protein', controller.consumedProtein.value, t.targetProtein, Colors.redAccent)),
                Expanded(child: _buildMacroRing('Carbs', controller.consumedCarbs.value, t.targetCarbs, Colors.blueAccent)),
                Expanded(child: _buildMacroRing('Fats', controller.consumedFats.value, t.targetFats, Colors.amber)),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMacroRing(String label, double current, double target, Color color) {
    double progress = (target > 0) ? (current / target).clamp(0.0, 1.0) : 0.0;
    return Column(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 5,
                backgroundColor: Colors.grey.shade200,
                color: color,
              ),
              Center(
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
        Text(
          '${current.toInt()}/${target.toInt()}${label == 'Calories' ? '' : 'g'}',
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildMealList() {
    return Obx(() {
      if (controller.consumedMeals.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.black, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Text(
              'No meals logged today.',
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.consumedMeals.length,
        itemBuilder: (context, index) {
          final meal = controller.consumedMeals[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.black, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ListTile(
              title: Text(meal.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${meal.calories} kcal • ${meal.protein}g P • ${meal.carbs}g C • ${meal.fats}g F'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => controller.removeMeal(meal.id),
              ),
            ),
          );
        },
      );
    });
  }

  void _showEditLimitsDialog(BuildContext context, DailyNutritionTarget currentTarget) {
    int cals = currentTarget.targetCalories;
    double protein = currentTarget.targetProtein;
    double carbs = currentTarget.targetCarbs;
    double fats = currentTarget.targetFats;

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppColors.black, width: 2),
        ),
        title: const Text('Edit Daily Limits', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.black)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: cals.toString(),
                decoration: const InputDecoration(labelText: 'Calories (kcal)'),
                keyboardType: TextInputType.number,
                onChanged: (v) => cals = int.tryParse(v) ?? cals,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: protein.toString(),
                decoration: const InputDecoration(labelText: 'Protein (g)'),
                keyboardType: TextInputType.number,
                onChanged: (v) => protein = double.tryParse(v) ?? protein,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: carbs.toString(),
                decoration: const InputDecoration(labelText: 'Carbs (g)'),
                keyboardType: TextInputType.number,
                onChanged: (v) => carbs = double.tryParse(v) ?? carbs,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: fats.toString(),
                decoration: const InputDecoration(labelText: 'Fats (g)'),
                keyboardType: TextInputType.number,
                onChanged: (v) => fats = double.tryParse(v) ?? fats,
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.target.value = DailyNutritionTarget(
                targetCalories: cals,
                targetProtein: protein,
                targetCarbs: carbs,
                targetFats: fats,
              );
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

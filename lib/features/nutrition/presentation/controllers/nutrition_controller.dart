import 'package:get/get.dart';
import '../../domain/models/nutrition_models.dart';

class NutritionController extends GetxController {
  var target = DailyNutritionTarget().obs;
  var consumedMeals = <FoodItem>[].obs;

  var consumedCalories = 0.obs;
  var consumedProtein = 0.0.obs;
  var consumedCarbs = 0.0.obs;
  var consumedFats = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // In a real app, load from local storage or API here.
  }

  void addMeal(FoodItem meal) {
    consumedMeals.add(meal);
    _calculateTotals();
  }

  void removeMeal(String id) {
    consumedMeals.removeWhere((item) => item.id == id);
    _calculateTotals();
  }

  void _calculateTotals() {
    int cals = 0;
    double protein = 0;
    double carbs = 0;
    double fats = 0;

    for (var meal in consumedMeals) {
      cals += meal.calories;
      protein += meal.protein;
      carbs += meal.carbs;
      fats += meal.fats;
    }

    consumedCalories.value = cals;
    consumedProtein.value = protein;
    consumedCarbs.value = carbs;
    consumedFats.value = fats;
  }
}

class FoodItem {
  final String id;
  final String name;
  final int calories;
  final double protein; // in grams
  final double carbs; // in grams
  final double fats; // in grams

  FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });
}

class DailyNutritionTarget {
  final int targetCalories;
  final double targetProtein;
  final double targetCarbs;
  final double targetFats;

  DailyNutritionTarget({
    this.targetCalories = 2000,
    this.targetProtein = 150.0,
    this.targetCarbs = 200.0,
    this.targetFats = 65.0,
  });
}

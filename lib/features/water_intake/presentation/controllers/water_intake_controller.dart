import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaterIntakeController extends GetxController {
  // Goal and current state
  final RxDouble dailyGoal = 5.0.obs;
  final RxDouble currentIntake = 0.0.obs;
  final RxInt streakDays = 1.obs;
  final RxList<double> history = <double>[].obs;
  final ScrollController historyScrollController = ScrollController();

  // Default cup sizes in Liters
  final List<Map<String, dynamic>> cupSizes = [
    {'name': 'Coffee', 'icon': '☕', 'size': 0.15},
    {'name': 'Glass', 'icon': '🥛', 'size': 0.20},
    {'name': 'Jar', 'icon': '🫙', 'size': 0.33},
    {'name': 'Cup', 'icon': '🥤', 'size': 0.35},
    {'name': 'Mug', 'icon': '🍺', 'size': 0.40},
    {'name': 'Pint', 'icon': '🍷', 'size': 0.50},
    {'name': 'Bottle', 'icon': '🍼', 'size': 0.60},
    {'name': 'Jug', 'icon': '🫖', 'size': 2.00},
    {'name': 'Custom', 'icon': '➕', 'size': 0.00},
  ];

  final RxDouble selectedCupSize = 0.4.obs;

  void addIntake(double amount) {
    currentIntake.value += amount;
    history.insert(0, amount); // Add to beginning of history
  }

  void selectCup(double size) {
    selectedCupSize.value = size;
  }

  @override
  void onClose() {
    historyScrollController.dispose();
    super.onClose();
  }
}

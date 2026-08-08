import 'package:get/get.dart';

class WeightLog {
  final double weight;
  final DateTime timestamp;

  WeightLog({required this.weight, required this.timestamp});
}

class WeightTrackerController extends GetxController {
  final RxDouble currentWeight = 154.0.obs;
  final RxDouble startWeight = 154.0.obs;
  final RxDouble goalWeight = 150.0.obs;
  
  // History of logged weights
  final RxList<WeightLog> history = <WeightLog>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    // Add some dummy history for the chart
    history.add(WeightLog(weight: 154.0, timestamp: DateTime.now().subtract(const Duration(days: 7))));
    history.add(WeightLog(weight: 155.2, timestamp: DateTime.now().subtract(const Duration(days: 6))));
    history.add(WeightLog(weight: 154.8, timestamp: DateTime.now().subtract(const Duration(days: 5))));
    history.add(WeightLog(weight: 153.5, timestamp: DateTime.now().subtract(const Duration(days: 4))));
    history.add(WeightLog(weight: 153.0, timestamp: DateTime.now().subtract(const Duration(days: 2))));
    history.add(WeightLog(weight: 154.0, timestamp: DateTime.now()));
  }

  void logWeight(double weight) {
    currentWeight.value = weight;
    history.insert(0, WeightLog(weight: weight, timestamp: DateTime.now()));
  }

  void deleteLog(int index) {
    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      // Update current weight to the most recent one if history is not empty
      if (history.isNotEmpty) {
        currentWeight.value = history.first.weight;
      }
    }
  }

  double get progressPercentage {
    if (startWeight.value - goalWeight.value == 0) return 0.0;
    double pct = (startWeight.value - currentWeight.value) / (startWeight.value - goalWeight.value);
    return pct.clamp(0.0, 1.0);
  }
}

import 'package:get/get.dart';
import '../../../home/presentation/controllers/home_controller.dart';

class WeightLog {
  final double weight;
  final DateTime timestamp;

  WeightLog({required this.weight, required this.timestamp});
}

class WeightTrackerController extends GetxController {
  final RxDouble currentWeight = 154.0.obs;
  final RxDouble startWeight = 154.0.obs;
  final RxDouble goalWeight = 150.0.obs;
  final Rx<DateTime> lastGoalUpdated = DateTime.now().obs;
  
  final weightFilter = ChartFilterState();
  final weightLineFilter = ChartFilterState();

  // History of logged weights
  final RxList<WeightLog> history = <WeightLog>[].obs;
  


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

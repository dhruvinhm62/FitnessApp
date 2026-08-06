import 'package:get/get.dart';

class SettingsController extends GetxController {
  var notificationsEnabled = true.obs;
  var hapticFeedback = true.obs;
  var keepAwake = false.obs;
  var useMetricUnits = true.obs;

  var exerciseLevel = 'Beginner'.obs;
  var workoutPlan = 'Home'.obs;
  var workoutDays = '3 Days'.obs;

  void toggleNotifications(bool value) => notificationsEnabled.value = value;
  void toggleHapticFeedback(bool value) => hapticFeedback.value = value;
  void toggleKeepAwake(bool value) => keepAwake.value = value;
  void setMetricUnits(bool value) => useMetricUnits.value = value;

  void setExerciseLevel(String level) {
    exerciseLevel.value = level;
  }

  void setWorkoutPlan(String plan) {
    workoutPlan.value = plan;
  }

  void setWorkoutDays(String days) {
    workoutDays.value = days;
  }
}

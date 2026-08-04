import 'package:fitness_app/core/routes/app_routes.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  // Navigation State
  final currentStep = 1.obs;

  // Step 1: Gender
  final selectedGender = ''.obs;

  // Step 2: DOB
  final dob = Rxn<DateTime>();

  // Step 3: Height
  final heightUnit = 'ft/in'.obs; // default first
  final heightCm = '150'.obs;
  final heightFt = '5'.obs;
  final heightIn = '9'.obs;

  // Step 4: Weight
  final weightUnit = 'lbs'.obs; // default first
  final weightValue = ''.obs;

  // Step 5: Experience
  final experienceLevel = 'Beginner'.obs;

  // Step 6: Workout Type
  final workoutType = 'Home'.obs;

  // Step 7: Workout Days
  final workoutDays = '3 Days'.obs;

  // Navigation Methods
  void nextToDob() => Get.toNamed(Routes.onboardingStep2);
  void nextToHeight() => Get.toNamed(Routes.onboardingStep3);
  void nextToWeight() => Get.toNamed(Routes.onboardingStep4);
  void nextToExperience() => Get.toNamed(Routes.onboardingStep5);
  void nextToWorkoutType() => Get.toNamed(Routes.onboardingStep6);
  void nextToWorkoutDays() => Get.toNamed(Routes.onboardingStep7);
  
  void finishOnboarding() {
    // In the future, this is where we'd submit all data to an API
    Get.offAllNamed(Routes.dashboard);
  }
}

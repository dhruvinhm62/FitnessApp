import 'package:get/get.dart';

class SignupController extends GetxController {
  void signup() {
    // Navigate to Onboarding upon successful wireframe signup
    Get.toNamed('/onboarding-step1');
  }
}

import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  void sendOtp() {
    Get.toNamed('/otp-verification');
  }
}

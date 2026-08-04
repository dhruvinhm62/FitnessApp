import 'package:get/get.dart';

class NewPasswordController extends GetxController {
  void resetPassword() {
    // Return to login after reset
    Get.offAllNamed('/login');
  }
}

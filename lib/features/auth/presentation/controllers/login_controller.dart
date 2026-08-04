import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class LoginController extends GetxController {
  void login() {
    // Navigate to Home upon successful wireframe login
    Get.offNamed(Routes.dashboard);
  }
}

import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Simulate loading/initialization time
    await Future.delayed(const Duration(seconds: 3));
    // Navigate to Login after splash
    Get.offNamed(Routes.login);
  }
}

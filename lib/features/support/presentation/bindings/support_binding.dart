import 'package:get/get.dart';
import 'package:fitness_app/features/support/presentation/controllers/support_controller.dart';

class SupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportController>(() => SupportController());
  }
}

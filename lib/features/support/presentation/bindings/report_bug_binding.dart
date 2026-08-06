import 'package:get/get.dart';
import 'package:fitness_app/features/support/presentation/controllers/report_bug_controller.dart';

class ReportBugBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportBugController>(() => ReportBugController());
  }
}

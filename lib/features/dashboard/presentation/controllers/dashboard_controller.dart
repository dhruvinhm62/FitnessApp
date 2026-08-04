import 'package:get/get.dart';

class DashboardController extends GetxController {
  final currentTab = 0.obs;

  void changeTab(int index) {
    currentTab.value = index;
  }
}

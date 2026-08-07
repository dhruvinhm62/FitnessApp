import 'package:get/get.dart';
import '../../../../core/utils/snackbar_util.dart';

class SubscriptionController extends GetxController {
  // 0: 1 Month, 1: 6 Months, 2: 12 Months
  final selectedPlanIndex = (-1).obs;

  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }

  void subscribe() {
    if (selectedPlanIndex.value != -1) {
      String planName = '';
      if (selectedPlanIndex.value == 0) planName = '1 Month';
      else if (selectedPlanIndex.value == 1) planName = '6 Months';
      else if (selectedPlanIndex.value == 2) planName = '12 Months';
      
      SnackbarUtil.showSuccess(
        title: 'Subscription',
        message: 'Successfully subscribed to $planName plan!',
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/water_intake_controller.dart';
import '../../../../core/constants/app_colors.dart';

class CupSelectionBottomSheet extends StatelessWidget {
  const CupSelectionBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WaterIntakeController controller = Get.find<WaterIntakeController>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: const Border(
          top: BorderSide(color: AppColors.black, width: 2),
          left: BorderSide(color: AppColors.black, width: 2),
          right: BorderSide(color: AppColors.black, width: 2),
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CUP SETTINGS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.black, width: 2),
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.black, size: 20),
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: controller.cupSizes.length,
            itemBuilder: (context, index) {
              final cup = controller.cupSizes[index];
              return Obx(() {
                final isSelected = controller.selectedCupSize.value == cup['size'] && cup['name'] != 'Custom';
                return GestureDetector(
                  onTap: () {
                    if (cup['name'] == 'Custom') {
                      _showCustomDialog(context, controller);
                    } else {
                      controller.selectCup(cup['size']);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.black : AppColors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.black, width: 2),
                      boxShadow: isSelected ? null : const [
                        BoxShadow(
                          color: AppColors.black,
                          offset: Offset(4, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cup['icon'], style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        Text(
                          cup['name'] == 'Custom' ? 'Custom' : '${cup['size']}L',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: isSelected ? AppColors.white : AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
          

          // Done Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: const Text('DONE'),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showCustomDialog(BuildContext context, WaterIntakeController controller) {
    final textController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppColors.black, width: 2),
        ),
        backgroundColor: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'CUSTOM DRINK',
                  style: TextStyle(
                    fontWeight: FontWeight.w900, 
                    fontSize: 20,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: textController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Amount is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Amount (Liters)',
                    hintText: 'e.g. 0.75',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.black, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.black, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.black, width: 2),
                    ),
                    labelStyle: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
                  ),
                  cursorColor: AppColors.black,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.black,
                          side: const BorderSide(color: AppColors.black, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('CANCEL'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final val = double.parse(textController.text);
                            controller.selectCup(val);
                            Get.back(); // close dialog
                            Get.back(); // close bottom sheet
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('SAVE'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

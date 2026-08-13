import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/water_intake_controller.dart';
import '../widgets/wave_progress_indicator.dart';
import 'cup_selection_bottom_sheet.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:fitness_app/core/widgets/custom_back_button.dart';

class DrinkLoggingView extends StatelessWidget {
  DrinkLoggingView({super.key});

  final WaterIntakeController controller = Get.find<WaterIntakeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: CustomBackButton(color: AppColors.white),
        title: const Text(
          'LOG DRINK',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tip Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.black, width: 2),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.black,
                      offset: Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(text: 'Drink '),
                            TextSpan(
                              text: '0.2-0.3L of water',
                              style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' each time to stay well-hydrated.'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // The Cup Visual
              Center(child: _buildCupVisual()),

              const Spacer(),

              // Liquid Type selector
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.black, width: 2),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.black,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.water_drop, color: AppColors.black, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'WATER',
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Amount Text with Edit Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Obx(
                    () => Text(
                      controller.selectedCupSize.value.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        color: AppColors.black,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'L',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      _showCupSettings(context);
                    },
                    child: const Icon(
                      Icons.edit,
                      color: AppColors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.addIntake(controller.selectedCupSize.value);
                        Get.back();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text('+ DRINK'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCupVisual() {
    return Container(
      width: 180,
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.black, width: 2),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(
              8,
              8,
            ), // A slightly larger shadow for the main visual element
            blurRadius: 0,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Water fill
          Obx(() {
            double maxMugSize = 1.0;
            double pct = controller.selectedCupSize.value / maxMugSize;
            pct = pct.clamp(0.1, 1.0);
            
            return Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: WaveProgressIndicator(percentage: pct),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showCupSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CupSelectionBottomSheet(),
    );
  }
}

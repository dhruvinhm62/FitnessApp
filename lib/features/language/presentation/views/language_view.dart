import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/features/language/presentation/controllers/language_controller.dart';
import 'package:fitness_app/core/widgets/custom_back_button.dart';

class LanguageView extends GetView<LanguageController> {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.black,
            pinned: true,
            elevation: 0,
            leading: CustomBackButton(color: AppColors.white),
            title: const Text(
              'LANGUAGE',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
                    child: Text(
                      'SELECT LANGUAGE',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        _buildLanguageOption('English'),
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
                        _buildLanguageOption('Spanish'),
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
                        _buildLanguageOption('French'),
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
                        _buildLanguageOption('Chinese'),
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
                        _buildLanguageOption('Hindi'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return Obx(() {
      final isSelected = controller.selectedLanguage.value == language;
      return GestureDetector(
        onTap: () => controller.setLanguage(language),
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.black : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.black : Colors.grey[400]!,
                    width: isSelected ? 0 : 1,
                    style: isSelected ? BorderStyle.none : BorderStyle.solid,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ],
          ),
        ),
      );
    });
  }
}

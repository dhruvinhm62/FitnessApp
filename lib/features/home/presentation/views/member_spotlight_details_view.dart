import 'package:fitness_app/core/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../controllers/home_controller.dart';

class MemberSpotlightDetailsView extends StatelessWidget {
  final MemberSpotlight spotlight;

  const MemberSpotlightDetailsView({super.key, required this.spotlight});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: CustomBackButton(color: AppColors.white),
        title: const Text(
          'MEMBER SPOTLIGHT',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Standard App Styled Image Container
              Container(
                height: 400,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.black,
                      offset: Offset(8, 8),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Image.network(
                        spotlight.beforeImageUrl,
                        fit: BoxFit.cover,
                        height: double.infinity,
                      ),
                    ),
                    Container(width: 2, color: AppColors.black),
                    Expanded(
                      child: Image.network(
                        spotlight.afterImageUrl,
                        fit: BoxFit.cover,
                        height: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Name Header
              Text(
                spotlight.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.black,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 24),
              
              // Content
              Text(
                spotlight.testimonial,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

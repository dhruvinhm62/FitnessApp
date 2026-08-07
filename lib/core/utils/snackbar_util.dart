import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';

class SnackbarUtil {
  static void showSuccess({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 4,
      duration: const Duration(seconds: 3),
    );
  }

  static void showError({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 4,
      duration: const Duration(seconds: 3),
    );
  }

  static void showInfo({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.black,
      colorText: AppColors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 4,
      duration: const Duration(seconds: 3),
    );
  }
}

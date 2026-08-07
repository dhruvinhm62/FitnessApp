import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import '../../../../core/utils/snackbar_util.dart';

class ReportBugController extends GetxController {
  final detailsController = TextEditingController();
  final attachments = <String>[].obs;

  @override
  void onClose() {
    detailsController.dispose();
    super.onClose();
  }

  void openAttachmentPicker() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.black),
                title: const Text(
                  'Camera',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                ),
                onTap: () {
                  Get.back();
                  // Mock camera action
                  attachments.add('camera_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
                },
              ),
              const Divider(height: 1, color: Color(0xFFE0E0E0)),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.black),
                title: const Text(
                  'Gallery',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                ),
                onTap: () {
                  Get.back();
                  // Mock gallery action
                  attachments.add('gallery_image_${DateTime.now().millisecondsSinceEpoch}.png');
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void submitBugReport() {
    // Mock submission
    SnackbarUtil.showSuccess(
      title: 'Success',
      message: 'Bug report submitted successfully.',
    );
    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
    });
  }
}

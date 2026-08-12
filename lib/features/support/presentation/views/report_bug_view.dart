import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/features/support/presentation/controllers/report_bug_controller.dart';
import 'package:fitness_app/core/widgets/custom_back_button.dart';

class ReportBugView extends GetView<ReportBugController> {
  const ReportBugView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: CustomBackButton(color: AppColors.white),
        title: const Text(
          'REPORT A BUG',
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
                border: Border(left: BorderSide(color: AppColors.black, width: 4)),
              ),
              child: const Text(
                "Welcome to the APPNAME beta! We'd love to get your feedback as we work through our first release and some initial bugs. If you notice anything off or not working, feel free to message us.",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.black,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'BUG DETAILS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: Colors.grey,
                ),
              ),
            ),
            TextField(
              controller: controller.detailsController,
              maxLines: 6,
              style: const TextStyle(fontSize: 15, color: AppColors.black),
              decoration: const InputDecoration(
                hintText: 'Please describe the issue in detail...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.all(16.0),
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'ATTACHMENTS (OPTIONAL)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: Colors.grey,
                ),
              ),
            ),
            Obx(() => Column(
                  children: controller.attachments
                      .map(
                        (attachment) => Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.image_outlined, color: AppColors.black, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  attachment,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.check_circle, color: Colors.green, size: 20),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                )),
            InkWell(
              onTap: controller.openAttachmentPicker,
              borderRadius: BorderRadius.circular(4),
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  color: Colors.grey[600]!,
                  strokeWidth: 1.5,
                  dashPattern: const [8, 4],
                  radius: const Radius.circular(4),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  color: Colors.grey[50],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_upload_outlined, color: AppColors.black, size: 36),
                      const SizedBox(height: 16),
                      const Text(
                        'Tap to upload images',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'JPG or PNG (max 5MB)',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.submitBugReport,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('SUBMIT'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

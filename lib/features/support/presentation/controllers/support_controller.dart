import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  final selectedSubject = 'General Inquiry'.obs;
  final List<String> subjects = [
    'General Inquiry',
    'Technical Support',
    'Billing',
    'Workout Programs',
    'Other'
  ];

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }

  void submitMessage() {
    if (formKey.currentState!.validate()) {
      // Simulate submission
      Get.snackbar(
        'Message Sent',
        'We have received your message and will get back to you within 24 hours.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Clear form
      firstNameController.clear();
      lastNameController.clear();
      emailController.clear();
      messageController.clear();
      selectedSubject.value = 'General Inquiry';
    }
  }
}

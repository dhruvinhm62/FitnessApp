import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/features/support/presentation/controllers/support_controller.dart';
import 'package:fitness_app/core/widgets/custom_back_button.dart';

class SupportView extends GetView<SupportController> {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: CustomBackButton(color: AppColors.white),
        title: const Text(
          'SUPPORT',
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'FREQUENTLY ASKED QUESTIONS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: Colors.grey,
                ),
              ),
            ),
            _buildFAQSection(),
            const SizedBox(height: 32),
            const Text(
              'Most of the answers to our most common questions are found in our FAQ.\n\nPlease note that we aim to respond to all inquiries within 24 hours.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'SEND A MESSAGE',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: Colors.grey,
                ),
              ),
            ),
            _buildContactForm(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      {'q': 'Are the workouts too easy?', 'a': 'Our workouts are designed to scale with your progress. If they feel too easy, consider increasing the weight or reducing rest times.'},
      {'q': 'Is there enough volume?', 'a': 'Yes, the programs are carefully structured to provide optimal volume for muscle growth and strength.'},
      {'q': 'How should I approach the deload?', 'a': 'Reduce your training volume and intensity by about 30-40% to allow your body to recover fully.'},
      {'q': 'Can I add additional exercises?', 'a': 'We recommend sticking to the prescribed program first. If you have extra energy, you may add 1-2 isolation movements.'},
      {'q': 'Which training split should I choose?', 'a': 'Choose a split that aligns with your schedule and recovery capacity. Consistency is more important than the specific split.'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: faqs.map((faq) {
          final isLast = faq == faqs.last;
          return Column(
            children: [
              Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  iconColor: AppColors.black,
                  collapsedIconColor: Colors.grey,
                  title: Text(
                    faq['q']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                      child: Text(
                        faq['a']!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast) const Divider(height: 1, color: AppColors.background),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactForm() {
    return Form(
      key: controller.formKey,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.firstNameController,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: controller.lastNameController,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email...',
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (v) {
                if (v!.isEmpty) return 'Required';
                if (!GetUtils.isEmail(v)) return 'Invalid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
                  initialValue: controller.selectedSubject.value,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  items: controller.subjects
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) controller.selectedSubject.value = v;
                  },
                )),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Message',
                fillColor: Colors.white,
                filled: true,
                alignLabelWithHint: true,
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.submitMessage,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('SEND MESSAGE'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

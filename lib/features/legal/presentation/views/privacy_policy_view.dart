import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitness_app/core/constants/app_colors.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'PRIVACY POLICY',
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
            const Text(
              'APPNAME LLC',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Last Updated: May 12, 2025',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. INTRODUCTION',
              'APPNAME LLC (“we,” “our,” or “us”) respects your privacy and is committed to protecting it through our compliance with this policy.\n\nThis Privacy Policy describes the types of information we may collect from you or that you may provide when you use our mobile application and website (collectively, our “Services”) and our practices for collecting, using, maintaining, protecting, and disclosing that information.\n\nThis policy applies to information we collect:\n\n• Through our mobile application\n• On our website\n• Through email and other electronic communications between you and our Services\n\nPlease read this policy carefully to understand our policies and practices regarding your information. If you do not agree with our policies and practices, do not download, register with, or use our Services. By downloading, registering with, or using our Services, you agree to this Privacy Policy.',
            ),
            _buildSection(
              '2. INFORMATION WE COLLECT AND HOW WE COLLECT IT',
              'Personal Information\nWe collect several types of information from and about users of our Services, including:\n\n• Identity Information: Your name, email address, and account credentials\n• Payment Information: When you purchase a subscription or make a one-time payment, your payment information is collected by our third-party payment processors (Stripe, Apple Pay, or Google Pay)\n• Profile Information: Age, height, weight, and fitness-related data that you choose to provide\n• Performance Data: Information related to workout performance and progress that you input into our Services\n• Usage Information: Information about how you access and use our Services\n• Device Information: Information about your mobile device or computer, including IP address, operating system, and browser type\n\nHow We Collect Information\nWe collect information:\n\n• Directly from you when you provide it to us\n• Automatically as you navigate through or use our Services\n• From third-party sources, such as payment processors and analytics providers\n\nCookies and Tracking Technologies\nWe use various technologies to collect information automatically, including:\n\n• Cookies\n• Web beacons\n• Analytics services (e.g., Google Analytics for Firebase)\n\nThese technologies help us analyze trends, administer the Services, track users’ movements around the Services, and gather demographic information about our user base as a whole.',
            ),
            _buildSection(
              '3. HOW WE USE YOUR INFORMATION',
              'We use information that we collect about you or that you provide to us:\n\n• To provide our Services and their contents to you\n• To process subscriptions and payments\n• To fulfill any other purpose for which you provide it\n• To create and maintain your account\n• To provide you with support and respond to your inquiries\n• To send you technical notices, updates, security alerts, and administrative messages\n• To personalize your experience and deliver content relevant to your interests\n• To measure and analyze the effectiveness of our Services\n• To monitor and analyze usage patterns and trends\n• In any other way we may describe when you provide the information\n• For any other purpose with your consent',
            ),
            _buildSection(
              '4. DISCLOSURE OF YOUR INFORMATION',
              'We may disclose personal information that we collect or you provide as described in this Privacy Policy:\n\n• To service providers and partners who perform functions on our behalf\n• To fulfill the purpose for which you provide it\n• For any other purpose disclosed by us when you provide the information\n• With your consent\n\nWe may also disclose your personal information:\n\n• To comply with any court order, law, or legal process\n• To enforce or apply our Terms of Use\n• If we believe disclosure is necessary to protect the rights, property, or safety of our company, our users, or others\n\nThird-Party Service Providers\nWe may share your personal information with the following categories of third-party service providers:\n\n• Payment processors (Stripe, Apple Pay, Google Pay)\n• Email service providers\n• Analytics providers (Google Analytics for Firebase)\n• App performance monitoring services\n• Cloud hosting providers',
            ),
            _buildSection(
              '5. YOUR CHOICES AND RIGHTS',
              'Accessing and Updating Your Information\nYou can review and change your personal information by logging into your account and visiting your profile settings page.\n\nOpting Out of Marketing Communications\nYou can opt out of receiving promotional emails from us by following the unsubscribe instructions provided in those emails. You may also opt out by contacting us directly.\n\nDo Not Track Signals\nWe currently do not respond to “Do Not Track” signals or other mechanisms that provide choice regarding the collection of information about your online activities over time and across third-party websites.\n\nCalifornia Residents’ Rights\nIf you are a California resident, you have certain rights regarding your personal information under the California Consumer Privacy Act (CCPA) and California Privacy Rights Act (CPRA), including:\n\n• The right to know what personal information we collect about you\n• The right to delete certain personal information we have collected\n• The right to opt-out of the sale or sharing of your personal information\n• The right to non-discrimination for exercising your privacy rights\n\nTo exercise these rights, please contact us using the information provided at the end of this Privacy Policy.\n\nDo Not Sell or Share My Personal Information: While we do not currently sell personal information in the traditional sense, California law defines “sell” and “share” broadly. You may opt out of certain sharing practices by clicking the “Do Not Sell or Share My Personal Information” link in the Settings section of our Services.\n\nVirginia Residents’ Rights\nIf you are a Virginia resident, you have certain rights under the Virginia Consumer Data Protection Act (VCDPA), including:\n\n• The right to confirm whether we are processing your personal data\n• The right to access your personal data\n• The right to correct inaccuracies in your personal data\n• The right to delete your personal data\n• The right to obtain a copy of your personal data\n• The right to opt out of the processing of personal data for targeted advertising, sale, or profiling\n\nTo exercise these rights, please contact us using the information provided at the end of this Privacy Policy.',
            ),
            _buildSection(
              '6. DATA SECURITY',
              'We have implemented measures designed to secure your personal information from accidental loss and from unauthorized access, use, alteration, and disclosure, including:\n\n• SSL/TLS encryption for data in transit\n• Encryption or hashing for passwords and other sensitive information at rest\n• Strict access controls\n• Regular software updates and security patches\n\nHowever, the transmission of information via the internet and mobile platforms is not completely secure. While we strive to protect your personal information, we cannot guarantee the security of your personal information transmitted through our Services.',
            ),
            _buildSection(
              '7. DATA RETENTION',
              'We will retain your personal information only for as long as reasonably necessary to fulfill the purposes for which it was collected, including for the purposes of satisfying any legal, regulatory, tax, accounting, or reporting requirements.\n\nIn some circumstances, we may anonymize your personal information so that it can no longer be associated with you, in which case we may use this information indefinitely without further notice to you.\n\nUpon account closure, we generally retain your personal information for 30-90 days after an account closes, unless certain records must be kept for legal, tax, or dispute-resolution reasons.',
            ),
            _buildSection(
              '8. CHILDREN’S PRIVACY',
              'Our Services are not intended for children under 18 years of age. We do not knowingly collect personal information from children under 18. If you are under 18, do not use or provide any information on our Services. If we learn we have collected or received personal information from a child under 18 without verification of parental consent, we will delete that information.',
            ),
            _buildSection(
              '9. INTERNATIONAL DATA TRANSFERS',
              'If you are accessing our Services from outside the United States, please be aware that your information may be transferred to, stored, and processed in the United States where our servers are located and our central database is operated. By using our Services, you consent to your information being transferred to the United States.',
            ),
            _buildSection(
              '10. CHANGES TO OUR PRIVACY POLICY',
              'We may update our Privacy Policy from time to time. If we make material changes, we will notify you by email or through a notice on our website or mobile application prior to the change becoming effective.',
            ),
            _buildSection(
              '11. CONTACT INFORMATION',
              'To ask questions or comment about this Privacy Policy and our privacy practices, you can contact us at:\n\nAPPNAME LLC\nEmail: admin@example.com',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.black,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/widgets/custom_back_button.dart';

class TermOfUseView extends StatelessWidget {
  const TermOfUseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: CustomBackButton(color: AppColors.white),
        title: const Text(
          'TERMS OF USE',
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
              'Last Updated: August 4, 2025',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. ACCEPTANCE OF TERMS',
              'Welcome to APPNAME LLC (“Company,” “we,” “our,” or “us”). These Terms of Use govern your access to and use of our mobile application, website, and services (collectively, the “Services”).\n\nPlease read these Terms carefully. By downloading, accessing, or using our Services, you agree to be bound by these Terms. If you do not agree to these Terms, do not access or use our Services.',
            ),
            _buildSection(
              '2. ELIGIBILITY',
              'By using our Services, you represent and warrant that you are at least 18 years of age and have the legal capacity to enter into these Terms. If you are using the Services on behalf of an entity, you represent and warrant that you have authority to bind that entity to these Terms.\n\nWhile we do not specifically market our Services to individuals under 18 years of age, we do not have specific safeguards in place to prevent minors from accessing our Services. If you are a parent or guardian and believe your child has accessed our Services, please contact us immediately.',
            ),
            _buildSection(
              '3. ACCOUNT REGISTRATION',
              '3.1 Account Creation\nTo access certain features of our Services, you may be required to register for an account. When registering, you must provide accurate and complete information and promptly update this information to keep it current.\n\n3.2 Account Responsibilities\nYou are responsible for:\n\n• Maintaining the confidentiality of your account credentials\n• All activities that occur under your account\n• Notifying us immediately of any unauthorized use of your account or any other breach of security\n\n3.3 One Account Per User\nYou may maintain only one active account with our Services. Multiple accounts for the same individual are not permitted.',
            ),
            _buildSection(
              '4. SUBSCRIPTION AND PAYMENT TERMS',
              '4.1 Subscription Options\nWe offer various subscription plans to access our Services. Details regarding the features, price, and billing cycle for each subscription option are available through our mobile application and website.\n\n4.2 Free Trials\nWe may, at our discretion, offer free trials to new users. Trial eligibility, duration, and features may vary. At the end of your trial period, your account will automatically convert to a paid subscription unless you cancel before the trial ends.\n\n4.3 Billing and Payment\nBy providing payment information, you authorize us to charge the subscription fee to your chosen payment method according to the billing cycle selected. Payment processing is handled by third-party payment processors (Stripe, Apple Pay, or Google Pay).\n\n4.4 Automatic Renewal\nSubscriptions automatically renew at the end of each billing period unless canceled before the renewal date. By subscribing, you authorize us to charge your payment method for the subscription fee each billing cycle until canceled.\n\n4.5 Price Changes\nWe reserve the right to adjust prices for our Services at any time. If we change pricing for a subscription plan, we will notify you in advance. Price changes for existing subscribers will take effect at the start of the next subscription period following the date of the price change.\n\n4.6 Cancellation\nYou may cancel your subscription at any time through your account settings or by contacting us. Upon cancellation, you will continue to have access to your subscription benefits until the end of your current billing cycle, at which point your subscription will not renew.\n\n4.7 Membership Pause\nOur Services may allow you to pause your membership for a specified period. During the pause period, you may not have access to certain features of the Services, and different terms may apply. Specific details and conditions regarding membership pausing will be provided within the Services.\n\n4.8 No Refunds\nAll subscription fees are non-refundable. Once payment is processed, we do not offer refunds for any portion of the subscription period. By purchasing a subscription, you acknowledge and agree that you will not receive a refund for any subscription fees already paid. If you no longer wish to use our Services, your remedy is to cancel your subscription to prevent future charges, as described in Section 4.6.',
            ),
            _buildSection(
              '5. CONTENT AND INTELLECTUAL PROPERTY',
              '5.1 Ownership of Services\nThe Services, including all content, features, functionality, software, text, displays, images, video, audio, and the design, selection, and arrangement thereof, are owned by the Company, its licensors, or other providers and are protected by copyright, trademark, and other intellectual property laws.\n\n5.2 License to Use Services\nSubject to these Terms, we grant you a limited, non-exclusive, non-transferable, and revocable license to access and use the Services for your personal, non-commercial use only.\n\n5.3 Program Availability and Downloaded Materials\nWhere assets are made available for download (including, but not limited to, training program PDFs, tracking spreadsheets, and other digital materials), these are provided as a convenience measure only. You are responsible for downloading such assets when they are available on the website or accessing them directly on the website during their availability period.\n\nAPPNAME releases a new program approximately every 4 weeks. Each program (“Program”) remains available on the website for a period of 7 days following the release of a new Program. This 7-day overlap period is provided to allow members time to transition between Programs.\n\nYou acknowledge and agree that:\n\n• If you fail to download or access these assets during their availability period, you will not have the option to access or request these materials at a later date;\n• The Company has no obligation to provide access to Programs or related materials after their availability period has ended;\n• The Company reserves the right to modify the availability period or release schedule at its discretion.\n\n5.4 Restrictions\nYou may not:\n\n• Reproduce, distribute, modify, create derivative works, publicly display, publicly perform, republish, download, store, transmit, sell, rent, or lease any content from our Services\n• Use any portion of the Services for commercial purposes\n• Attempt to decompile, reverse engineer, or disassemble any portion of the Services\n• Remove any copyright or other proprietary notices from the Services\n• Transfer the materials to another person or “mirror” the materials on any other server\n• Share your account credentials with others or allow others to access your account\n\n5.5 User Content\nYou retain ownership of any content you submit, post, or display on or through the Services (“User Content”). By providing User Content, you grant us a worldwide, perpetual, irrevocable, royalty-free license to use, reproduce, modify, adapt, publish, translate, distribute, display, and promote such User Content for any purpose related to our Services, marketing, advertising, and promotional activities.',
            ),
            _buildSection(
              '6. USER CONDUCT',
              '6.1 Prohibited Activities\nYou agree not to:\n\n• Use the Services in any way that violates any applicable law or regulation\n• Impersonate any person or entity, or falsely state or misrepresent your affiliation with a person or entity\n• Interfere with or disrupt the Services or servers or networks connected to the Services\n• Use the Services to transmit any computer viruses, malware, or any code designed to harm or alter a computer system\n• Attempt to gain unauthorized access to any parts of the Services\n• Use the Services to collect or store personal data about other users without their consent\n• Share account access or transfer your account to any other person\n• Use the Services in a manner that could damage, disable, overburden, or impair the site\n\n6.2 Fitness Advice\nAny fitness or exercise programs provided through our Services are for informational and educational purposes only. You should consult with a healthcare professional before beginning any exercise program.',
            ),
            _buildSection(
              '7. DISCLAIMER OF WARRANTIES',
              'THE SERVICES ARE PROVIDED ON AN “AS IS” AND “AS AVAILABLE” BASIS, WITHOUT ANY WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED.\n\nTO THE FULLEST EXTENT PROVIDED BY LAW, THE COMPANY HEREBY DISCLAIMS ALL WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED, STATUTORY, OR OTHERWISE, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, AND FITNESS FOR PARTICULAR PURPOSE.\n\nTHE COMPANY DOES NOT WARRANT THAT THE SERVICES WILL BE UNINTERRUPTED, TIMELY, SECURE, OR ERROR-FREE, OR THAT DEFECTS, IF ANY, WILL BE CORRECTED.',
            ),
            _buildSection(
              '8. LIMITATION OF LIABILITY',
              'TO THE FULLEST EXTENT PROVIDED BY LAW, IN NO EVENT WILL THE COMPANY, ITS AFFILIATES, OR THEIR LICENSORS, SERVICE PROVIDERS, EMPLOYEES, AGENTS, OFFICERS, OR DIRECTORS BE LIABLE FOR DAMAGES OF ANY KIND, UNDER ANY LEGAL THEORY, ARISING OUT OF OR IN CONNECTION WITH YOUR USE, OR INABILITY TO USE, THE SERVICES, INCLUDING ANY DIRECT, INDIRECT, SPECIAL, INCIDENTAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES.',
            ),
            _buildSection(
              '9. FITNESS AND HEALTH DISCLAIMER',
              'THE EXERCISE PROGRAMS AND FITNESS INFORMATION PROVIDED THROUGH OUR SERVICES ARE NOT MEDICAL ADVICE AND ARE NOT INTENDED TO BE A SUBSTITUTE FOR PROFESSIONAL MEDICAL ADVICE, DIAGNOSIS, OR TREATMENT. ALWAYS SEEK THE ADVICE OF YOUR PHYSICIAN OR OTHER QUALIFIED HEALTH PROVIDER WITH ANY QUESTIONS YOU MAY HAVE REGARDING A MEDICAL CONDITION OR BEFORE BEGINNING ANY EXERCISE PROGRAM.\n\nBY USING OUR SERVICES, YOU ACKNOWLEDGE AND AGREE THAT THERE ARE RISKS ASSOCIATED WITH PARTICIPATING IN FITNESS ACTIVITIES AND THAT THE COMPANY IS NOT RESPONSIBLE FOR ANY INJURIES OR HEALTH PROBLEMS YOU MAY EXPERIENCE AS A RESULT OF FOLLOWING THE FITNESS PROGRAMS OR ADVICE PROVIDED THROUGH OUR SERVICES.',
            ),
            _buildSection(
              '10. INDEMNIFICATION',
              'You agree to defend, indemnify, and hold harmless the Company, its affiliates, licensors, and service providers, and its and their respective officers, directors, employees, contractors, agents, licensors, suppliers, successors, and assigns from and against any claims, liabilities, damages, judgments, awards, losses, costs, expenses, or fees (including reasonable attorneys’ fees) arising out of or relating to your violation of these Terms or your use of the Services.',
            ),
            _buildSection(
              '11. MODIFICATION AND TERMINATION',
              '11.1 Modification of Services\nWe reserve the right to modify, suspend, or discontinue the Services (or any part or feature thereof) at any time, with or without notice. We will not be liable to you or to any third party for any modification, suspension, or discontinuance of the Services.\n\n11.2 Updates to Terms\nWe may revise and update these Terms from time to time at our sole discretion. All changes are effective immediately when we post them. Your continued use of the Services following the posting of revised Terms means that you accept and agree to the changes.\n\n11.3 Termination\nWe may terminate or suspend your account and access to the Services immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach these Terms.\n\nUpon termination, your right to use the Services will immediately cease. If you wish to terminate your account, you may simply discontinue using the Services or request account deletion through your account settings.',
            ),
            _buildSection(
              '12. GOVERNING LAW AND DISPUTE RESOLUTION',
              '12.1 Governing Law\nThese Terms and your use of the Services shall be governed by and construed in accordance with the laws of the State of California, without giving effect to any choice or conflict of law provision or rule.\n\n12.2 Venue\nAny legal suit, action, or proceeding arising out of, or related to, these Terms or the Services that is not subject to arbitration shall be instituted exclusively in the Superior Court of California, County of San Diego. You waive any and all objections to the exercise of jurisdiction over you by such court and to venue in such court.\n\n12.3 Dispute Resolution\nAny dispute arising from or relating to these Terms or your use of the Services will be resolved through binding arbitration in accordance with the Commercial Arbitration Rules of the American Arbitration Association (AAA), except that you may assert claims in small claims court if your claims qualify.\n\nThe arbitration will be conducted in San Diego, California, unless you and APPNAME LLC agree otherwise. Each party will be responsible for their own arbitration costs, but if you cannot afford to pay your arbitration costs, you may apply for a fee waiver under AAA rules.\n\nYou agree that any dispute resolution proceedings will be conducted only on an individual basis and not in a class, consolidated, or representative action. If for any reason this arbitration agreement is found unenforceable, you and APPNAME LLC agree to the exclusive jurisdiction of the Superior Court of California, County of San Diego.\n\nNotwithstanding the foregoing, you and APPNAME LLC agree that nothing herein shall be deemed to waive, preclude, or otherwise limit either party’s right to seek injunctive relief or other equitable remedies in a court of competent jurisdiction.',
            ),
            _buildSection(
              '13. MISCELLANEOUS',
              '13.1 Entire Agreement\nThese Terms, together with our Privacy Policy, constitute the sole and entire agreement between you and the Company regarding the Services and supersede all prior and contemporaneous understandings, agreements, representations, and warranties.\n\n13.2 Waiver\nNo waiver by the Company of any term or condition set out in these Terms shall be deemed a further or continuing waiver of such term or condition or a waiver of any other term or condition.\n\n13.3 Severability\nIf any provision of these Terms is held by a court or other tribunal of competent jurisdiction to be invalid, illegal, or unenforceable for any reason, such provision shall be eliminated or limited to the minimum extent such that the remaining provisions of the Terms will continue in full force and effect.\n\n13.4 Assignment\nThese Terms are personal to you and may not be assigned or transferred by you without our prior written consent. We may freely assign or transfer these Terms without restriction.\n\n13.5 Force Majeure\nWe will not be liable for any failure or delay in performing our obligations where such failure or delay results from any cause beyond our reasonable control, including, without limitation, acts of God, pandemic, epidemic, war, civil unrest, or natural disaster.',
            ),
            _buildSection(
              '14. CONTACT INFORMATION',
              'For questions about these Terms, please contact us at:\n\nAPPNAME LLC\nEmail: admin@example.com',
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

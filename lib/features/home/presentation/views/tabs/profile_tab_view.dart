import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:fitness_app/core/widgets/custom_back_button.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.black,
            elevation: 0,
            toolbarHeight: 60,
            automaticallyImplyLeading: false,
            centerTitle: true,
            leading: CustomBackButton(
              color: AppColors.white,
              onPressed: () {
                if (Get.isRegistered<DashboardController>()) {
                  Get.find<DashboardController>().changeTab(0);
                }
              },
            ),
            title: Text(
              'PROFILE',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 24,
                    bottom: 120,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel('Account Settings'),
                      _buildSettingsGroup([
                        _buildGroupItem(
                          icon: Icons.person_outline,
                          title: 'My profile',
                          isLast: false,
                          onTap: () => Get.toNamed(Routes.myProfile),
                        ),
                        _buildGroupItem(
                          icon: Icons.settings_outlined,
                          title: 'Setting',
                          isLast: false,
                          onTap: () => Get.toNamed(Routes.settings),
                        ),
                        _buildGroupItem(
                          icon: Icons.star_border,
                          title: 'Subscription',
                          isLast: false,
                          onTap: () => Get.toNamed(Routes.subscription),
                        ),
                        _buildGroupItem(
                          icon: Icons.language,
                          title: 'Language',
                          isLast: true,
                          onTap: () => Get.toNamed(Routes.language),
                        ),
                      ]),
                      _buildSectionLabel('Support & About'),
                      _buildSettingsGroup([
                        _buildGroupItem(
                          icon: Icons.bug_report_outlined,
                          title: 'Beta: report a bug',
                          isLast: false,
                          onTap: () => Get.toNamed(Routes.reportBug),
                        ),
                        _buildGroupItem(
                          icon: Icons.help_outline,
                          title: 'Support',
                          isLast: false,
                          onTap: () => Get.toNamed(Routes.support),
                        ),
                        _buildGroupItem(
                          icon: Icons.description_outlined,
                          title: 'Term of use',
                          isLast: false,
                          onTap: () => Get.toNamed(Routes.termsOfUse),
                        ),
                        _buildGroupItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy policy',
                          isLast: true,
                          onTap: () => Get.toNamed(Routes.privacyPolicy),
                        ),
                      ]),
                      _buildSectionLabel('Account Actions'),
                      _buildSettingsGroup([
                        _buildGroupItem(
                          icon: Icons.delete_outline,
                          title: 'Delete account',
                          isLast: false,
                          isDestructive: true,
                        ),
                        _buildGroupItem(
                          icon: Icons.logout,
                          title: 'Log out',
                          isLast: true,
                          isDestructive: true,
                          onTap: () => Get.offAllNamed(Routes.login),
                        ),
                      ], bottomPadding: 16),
                      const Center(
                        child: Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: AppColors.black,
      child: Container(
        height: 220,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
                image: const DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/300?img=11'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Alex Athlete',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'alex@athlete.com',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(
    List<Widget> children, {
    double bottomPadding = 26,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildGroupItem({
    required IconData icon,
    required String title,
    required bool isLast,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    final color = isDestructive ? Colors.redAccent : AppColors.black;
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(4),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
                if (!isDestructive)
                  const Icon(Icons.chevron_right, color: AppColors.grey),
              ],
            ),
          ),
          if (!isLast)
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
        ],
      ),
    );
  }
}

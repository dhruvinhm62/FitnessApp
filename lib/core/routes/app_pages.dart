import 'package:get/get.dart';
import '../../features/dashboard/presentation/views/dashboard_view.dart';
import '../../features/dashboard/presentation/controllers/dashboard_controller.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/home/presentation/controllers/home_controller.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import '../../features/splash/presentation/controllers/splash_controller.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/controllers/login_controller.dart';
import '../../features/auth/presentation/views/signup_view.dart';
import '../../features/auth/presentation/controllers/signup_controller.dart';
import '../../features/auth/presentation/views/forgot_password_view.dart';
import '../../features/auth/presentation/controllers/forgot_password_controller.dart';
import '../../features/auth/presentation/views/otp_verification_view.dart';
import '../../features/auth/presentation/controllers/otp_verification_controller.dart';
import '../../features/auth/presentation/views/new_password_view.dart';
import '../../features/auth/presentation/controllers/new_password_controller.dart';
import '../../features/onboarding/presentation/controllers/onboarding_controller.dart';
import '../../features/onboarding/presentation/views/step1_gender_view.dart';
import '../../features/onboarding/presentation/views/step2_dob_view.dart';
import '../../features/onboarding/presentation/views/step3_height_view.dart';
import '../../features/onboarding/presentation/views/step4_weight_view.dart';
import '../../features/onboarding/presentation/views/step5_experience_view.dart';
import '../../features/onboarding/presentation/views/step6_workout_type_view.dart';
import '../../features/onboarding/presentation/views/step7_workout_days_view.dart';
import '../../features/home/presentation/views/my_profile_view.dart';
import '../../features/settings/presentation/views/settings_view.dart';
import '../../features/settings/presentation/bindings/settings_binding.dart';
import '../../features/language/presentation/views/language_view.dart';
import '../../features/language/presentation/bindings/language_binding.dart';
import '../../features/support/presentation/views/report_bug_view.dart';
import '../../features/support/presentation/bindings/report_bug_binding.dart';
import '../../features/support/presentation/views/support_view.dart';
import '../../features/support/presentation/bindings/support_binding.dart';
import '../../features/legal/presentation/views/term_of_use_view.dart';
import '../../features/legal/presentation/views/privacy_policy_view.dart';
import '../../features/subscription/presentation/views/subscription_view.dart';
import '../../features/subscription/presentation/bindings/subscription_binding.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.put<SplashController>(SplashController());
      }),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignupView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SignupController>(() => SignupController());
      }),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
      }),
    ),
    GetPage(
      name: Routes.otpVerification,
      page: () => const OtpVerificationView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<OtpVerificationController>(() => OtpVerificationController());
      }),
    ),
    GetPage(
      name: Routes.newPassword,
      page: () => const NewPasswordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<NewPasswordController>(() => NewPasswordController());
      }),
    ),
    GetPage(
      name: Routes.onboardingStep1,
      page: () => const Step1GenderView(),
      binding: BindingsBuilder(() {
        Get.put<OnboardingController>(OnboardingController());
      }),
    ),
    GetPage(
      name: Routes.onboardingStep2,
      page: () => const Step2DobView(),
    ),
    GetPage(
      name: Routes.onboardingStep3,
      page: () => const Step3HeightView(),
    ),
    GetPage(
      name: Routes.onboardingStep4,
      page: () => const Step4WeightView(),
    ),
    GetPage(
      name: Routes.onboardingStep5,
      page: () => const Step5ExperienceView(),
    ),
    GetPage(
      name: Routes.onboardingStep6,
      page: () => const Step6WorkoutTypeView(),
    ),
    GetPage(
      name: Routes.onboardingStep7,
      page: () => const Step7WorkoutDaysView(),
    ),

    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DashboardController>(() => DashboardController());
        Get.lazyPut<HomeController>(() => HomeController());
      }),
    ),
    GetPage(
      name: Routes.myProfile,
      page: () => const MyProfileView(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.language,
      page: () => const LanguageView(),
      binding: LanguageBinding(),
    ),
    GetPage(
      name: Routes.reportBug,
      page: () => const ReportBugView(),
      binding: ReportBugBinding(),
    ),
    GetPage(
      name: Routes.support,
      page: () => const SupportView(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: Routes.termsOfUse,
      page: () => const TermOfUseView(),
    ),
    GetPage(
      name: Routes.privacyPolicy,
      page: () => const PrivacyPolicyView(),
    ),
    GetPage(
      name: Routes.subscription,
      page: () => const SubscriptionView(),
      binding: SubscriptionBinding(),
    ),
  ];
}

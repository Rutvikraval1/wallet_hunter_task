import 'package:get/get.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/otp_authentication_screen/otp_authentication_screen.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/interactive_family_tree_screen/interactive_family_tree_screen.dart';
import '../presentation/family_member_management_screen/family_member_management_screen.dart';
import '../presentation/family_head_registration_screen/family_head_registration_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String otpAuthenticationScreen = '/otp-authentication-screen';
  static const String familyHeadRegistrationScreen =
      '/family-head-registration-screen';
  static const String familyMemberManagementScreen =
      '/family-member-management-screen';
  static const String interactiveFamilyTreeScreen =
      '/interactive-family-tree-screen';
  static const String dashboardScreen = '/dashboard-screen';

  static List<GetPage> pages = [
    GetPage(
      name: initial,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: otpAuthenticationScreen,
      page: () =>  OtpAuthenticationScreen(),
    ),
    GetPage(
      name: familyHeadRegistrationScreen,
      page: () => const FamilyHeadRegistrationScreen(),
    ),
    GetPage(
      name: familyMemberManagementScreen,
      page: () => const FamilyMemberManagementScreen(),
    ),
    GetPage(
      name: interactiveFamilyTreeScreen,
      page: () => const InteractiveFamilyTreeScreen(),
    ),
    GetPage(
      name: dashboardScreen,
      page: () => const DashboardScreen(),
    ),
  ];

  // Keep legacy routes for backward compatibility
  // static Map<String, GetPageBuilder> routes = {
  //   initial: (context) => const SplashScreen(),
  //   splashScreen: (context) => const SplashScreen(),
  //   otpAuthenticationScreen: (context) => const OtpAuthenticationScreen(),
  //   familyHeadRegistrationScreen: (context) =>
  //       const FamilyHeadRegistrationScreen(),
  //   familyMemberManagementScreen: (context) =>
  //       const FamilyMemberManagementScreen(),
  //   interactiveFamilyTreeScreen: (context) =>
  //       const InteractiveFamilyTreeScreen(),
  //   dashboardScreen: (context) => const DashboardScreen(),
  // };
}

// routes.dart

import 'package:get/get.dart';
import 'package:voicly/controller/login_controller.dart';
import 'package:voicly/features/auth/auth_screen.dart';
import 'package:voicly/features/coin/coin_screen.dart';
import 'package:voicly/features/profile/profile_screen.dart';
import 'package:voicly/features/splash/splash_screen.dart';

import '../utils/local_storage.dart';

// ignore_for_file: constant_identifier_names
class AppRoutes {
  static const SPLASH = '/';
  static const ONBOARDING = '/onboarding';
  static const BOTTOM_BAR = '/bottom_bar';
  static const LOGIN = '/login';
  static const COIN = '/coin';
  static const PROFILE = '/profile';

  static String getInitialRoute() {
    final isFirstRun = LocalStorage.getFirstRun();
    if (isFirstRun) {
      return AppRoutes.SPLASH;
    } else {
      if (LocalStorage.getAccessToken().isNotEmpty) {
        return AppRoutes.SPLASH;
      }
      return AppRoutes.SPLASH;
    }
  }
}

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.SPLASH, page: () => const SplashScreen()),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => AuthScreen(),
      binding: BindingsBuilder.put(() => LoginController()),
    ),
    GetPage(name: AppRoutes.COIN, page: () => CoinScreen()),
    GetPage(name: AppRoutes.PROFILE, page: () => ProfileScreen()),
  ];
}

import 'package:flutter/material.dart';
import 'package:voicly_caller/features/splash/splash_screen.dart';
import 'core/constants/app_colors.dart';
import 'core/route/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // return GlobalLoaderOverlay(
    //   overlayWidgetBuilder: (_) => const Center(
    //     child: CircularProgressIndicator.adaptive(
    //       valueColor: AlwaysStoppedAnimation(AppColors.primary),
    //     ),
    //   ),
    //   child: GetMaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     defaultTransition: Transition.fadeIn,
    //     initialRoute: AppRoutes.getInitialRoute(),
    //     getPages: AppPages.pages,
    //   ),
    // );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),

      home: const SplashScreen(),
    );
  }
}

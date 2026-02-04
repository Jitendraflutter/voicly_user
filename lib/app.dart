
import 'package:flutter/material.dart';
import 'package:voicly/core/route/app_route.dart';
import 'package:voicly/features/splash/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: AppRoute.navigatorKey,
      home: SplashScreen()
    );
  }
}

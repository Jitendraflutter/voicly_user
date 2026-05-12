import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'controller/popup_controller.dart';
import 'core/route/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: ScreenUtilInit(
        designSize: Size(433, 964),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, _) {
          return GlobalLoaderOverlay(
            overlayWidgetBuilder: (_) => const Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              defaultTransition: Transition.fadeIn,
              initialRoute: AppRoutes.getInitialRoute(),
              getPages: AppPages.pages,
              initialBinding: BindingsBuilder(() {
                Get.put(PopupController());
              }),
            ),
          );
        },
      ),
    );
  }
}

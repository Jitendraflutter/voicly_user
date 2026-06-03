# App Flow and Routing

- **Entry Point**: `lib/main.dart` initializes Firebase and runs `App()` (`lib/app.dart`), which constructs a `GetMaterialApp` and configures ScreenUtil.
- **Routes Definition**: All routes and pages are centrally mapped in `lib/core/route/routes.dart` via `AppRoutes` and `AppPages`.
- **Initial Route Logic**:
  - `LocalStorage.getFirstRun()` checks if the user is launching the app for the very first time. If true, the route defaults to `SPLASH`.
  - `LocalStorage.getUid()` checks if the user is already authenticated. If true, the route goes to `HOME`.
  - Otherwise, it falls back to `SPLASH`.
- **Key Routes/Screens**:
  - `SPLASH`: `SplashScreen` + `SplashBinding`
  - `LOGIN`: `AuthScreen` + `LoginController`
  - `HOME`: `HomeScreen`
  - `CALL_SCREEN`: `CallView` + `CallBinding`
  - `VIDEO_CALL_SCREEN`: `VideoCallScreen`
  - `PROFILE`: `ProfileScreen`
  - `UPDATE_PROFILE`: `ProfileUpdateScreen`
  - `HISTORY`: `CallHistoryScreen`
  - `COIN`: `CoinScreen`

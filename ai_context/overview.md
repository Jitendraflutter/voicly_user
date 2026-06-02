# Architecture & Overview

**Voicly User App**
- A Flutter application using **GetX** for State Management, Routing, and Dependency Injection.
- Integrates closely with a custom core package `voicly_core_package` hosted on GitHub, which provides common utilities, models, UI colors, and strings (`package:core/core.dart`).
- **Backend Infrastructure**: Relies on Firebase suite (Auth, Firestore, Cloud Functions, Messaging, Storage, App Check).
- **Communication Module**: Uses Agora (`agora_rtc_engine`) for live audio and video calling features.
- **Monetization**: Razorpay integration for in-app coin purchases (`razorpay_flutter`).
- **Responsive UI Approach**: Fully depends on `flutter_screenutil` (`designSize: Size(433, 964)`). Hardcoded dimensions should be strictly avoided.
- **Push Notifications**: Uses `firebase_messaging` combined with `flutter_local_notifications` and `flutter_callkit_incoming` for handling incoming call notifications.

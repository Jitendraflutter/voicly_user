// Generated file — do not edit manually.
// Values sourced from android/app/src/google-services.json (com.voicly.app)

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS. '
          'Add GoogleService-Info.plist and regenerate via flutterfire configure.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCsIXIzQEr92hnZ69TBbM4-itolEsBm-KA',
    appId: '1:362367116949:android:1f84894cb64b2848365d9c',
    messagingSenderId: '362367116949',
    projectId: 'voicly-15ec0',
    storageBucket: 'voicly-15ec0.firebasestorage.app',
  );
}

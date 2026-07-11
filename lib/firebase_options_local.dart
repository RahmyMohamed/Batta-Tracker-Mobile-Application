// Replace these values from Firebase Console:
// Project Settings → Your apps → Web (or Android) → SDK setup and configuration
//
// 1. Create a project at https://console.firebase.google.com
// 2. Enable Authentication → Email/Password
// 3. Add a Web app (for Chrome) and/or Android app
// 4. Paste the config values below

import 'package:firebase_core/firebase_core.dart';

class FirebaseOptionsLocal {
  FirebaseOptionsLocal._();

  /// Web app config (used when running on Chrome / Edge)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDTGXIAerBrl1hLpMFUSjWXwYHkIvGjtMo',
    appId: '1:804729588528:web:80f31ccc7f1126f875d6f5',
    messagingSenderId: '804729588528',
    projectId: 'batta-tracker',
    authDomain: 'batta-tracker.firebaseapp.com',
    storageBucket: 'batta-tracker.firebasestorage.app',
    // இந்த ஒரு வரியை மட்டும் தான் நாம இப்போ புதுசா சேர்த்திருக்கோம்!
    databaseURL: 'https://batta-tracker-default-rtdb.firebaseio.com/', 
  );

  /// Android app config
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY', 
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: '804729588528',
    projectId: 'batta-tracker',
    storageBucket: 'batta-tracker.firebasestorage.app',
    databaseURL: 'https://batta-tracker-default-rtdb.firebaseio.com/',
  );

  /// iOS app config
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: '804729588528',
    projectId: 'batta-tracker',
    storageBucket: 'batta-tracker.firebasestorage.app',
    iosBundleId: 'com.example.batta_tracker',
    databaseURL: 'https://batta-tracker-default-rtdb.firebaseio.com/',
  );
}
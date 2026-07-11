import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'firebase_options_local.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptionsLocal.web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return FirebaseOptionsLocal.android;
      case TargetPlatform.iOS:
        return FirebaseOptionsLocal.ios;
      default:
        throw UnsupportedError('Platform not supported');
    }
  }

  /// Returns false when placeholder keys are still in firebase_options_local.dart
  static bool get isConfigured {
    final options = currentPlatform;
    return options.apiKey.isNotEmpty &&
        !options.apiKey.startsWith('YOUR_') &&
        options.appId.isNotEmpty &&
        !options.appId.startsWith('YOUR_') &&
        options.projectId.isNotEmpty &&
        !options.projectId.startsWith('YOUR_');
  }
}

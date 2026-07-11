import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'screens/shared/firebase_setup_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (false) { 
    runApp(
      MaterialApp(
        title: 'Batta Tracker',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        home: const FirebaseSetupScreen(),
      ),
    );
    return;
  }

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      rethrow;
    }
  }

  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(BattaTrackerApp(notificationService: notificationService));
}
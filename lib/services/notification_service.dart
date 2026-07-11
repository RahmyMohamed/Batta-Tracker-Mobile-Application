import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../core/constants/app_constants.dart';
import '../models/eta_model.dart';

/// Background message handler - must be top-level function.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handled when app is in background/terminated
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final Set<String> _notifiedStops = {};

  Future<void> initialize() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(initSettings);

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  Future<String?> getToken() => _messaging.getToken();

  Future<void> subscribeToRoute(String routeId) async {
    await _messaging.subscribeToTopic('route_$routeId');
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      showLocalNotification(
        title: notification.title ?? 'Batta Tracker',
        body: notification.body ?? '',
      );
    }
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'batta_tracker_channel',
      'Batta Tracker',
      channelDescription: 'Vehicle arrival notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  /// Check ETAs and notify passenger when vehicle is within threshold.
  Future<void> checkAndNotifyArrival({
    required List<EtaModel> etas,
    required String? selectedStopId,
  }) async {
    if (selectedStopId == null) return;

    final eta = etas.where((e) => e.stop.id == selectedStopId).firstOrNull;
    if (eta == null) return;

    if (eta.minutesAway <= AppConstants.notificationThresholdMinutes &&
        !_notifiedStops.contains(selectedStopId)) {
      _notifiedStops.add(selectedStopId);

      await showLocalNotification(
        title: 'Batta Lorry Approaching!',
        body:
            'Your vehicle is approximately ${eta.minutesAway} minutes away from ${eta.stop.name}.',
      );
    }

    if (eta.minutesAway > AppConstants.notificationThresholdMinutes + 5) {
      _notifiedStops.remove(selectedStopId);
    }
  }

  void resetNotifications() => _notifiedStops.clear();
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) return iterator.current;
    return null;
  }
}

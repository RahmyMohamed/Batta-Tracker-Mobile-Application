class AppConstants {
  AppConstants._();

  static const String appName = 'Batta Tracker';
  static const String defaultRouteId = 'kalpitiya_kandalkuliya';

  // Location refresh interval (seconds)
  static const int locationRefreshSeconds = 5;

  // Notification threshold (minutes before arrival)
  static const int notificationThresholdMinutes = 5;

  // Average speed for ETA calculation (km/h) - rural road estimate
  static const double averageSpeedKmh = 35.0;

  // Emergency contacts
  static const String emergencyPhone = '+94112345678';
  static const String emergencyPolice = '119';
  static const String emergencyAmbulance = '110';

  // Firestore collections
  static const String usersCollection = 'users';
  static const String driversCollection = 'drivers';
  static const String vehiclesCollection = 'vehicles';
  static const String routesCollection = 'routes';
  static const String stopsCollection = 'stops';
  static const String tripsCollection = 'trips';
  static const String ratingsCollection = 'ratings';
  static const String schedulesCollection = 'schedules';

  // Realtime Database paths
  static const String liveLocationsPath = 'live_locations';
  static const String activeTripsPath = 'active_trips';

  // Shared preferences keys
  static const String prefThemeMode = 'theme_mode';
  static const String prefLocale = 'locale';
  static const String prefSelectedStop = 'selected_stop';
  static const String prefCachedRoute = 'cached_route';
  static const String prefCachedSchedule = 'cached_schedule';
}

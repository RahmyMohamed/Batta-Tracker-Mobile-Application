import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/tracking_provider.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/connectivity_service.dart';
import 'services/live_location_service.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';
import 'services/route_service.dart';
import 'services/trip_service.dart';
import 'services/vehicle_service.dart';

class BattaTrackerApp extends StatelessWidget {
  final NotificationService notificationService;

  const BattaTrackerApp({
    super.key,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadTheme()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()..loadLocale()),
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
        ChangeNotifierProvider(
          create: (_) => TrackingProvider(
            liveLocationService: LiveLocationService(),
            locationService: LocationService(),
            routeService: RouteService(),
            tripService: TripService(),
            vehicleService: VehicleService(),
            notificationService: notificationService,
            connectivityService: ConnectivityService(),
          ),
        ),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, _) {
          return MaterialApp(
            title: 'Batta Tracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeProvider.themeMode,
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('si'),
              Locale('ta'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

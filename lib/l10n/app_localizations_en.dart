// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Batta Tracker';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Full Name';

  @override
  String get phone => 'Phone Number';

  @override
  String get passenger => 'Passenger';

  @override
  String get driver => 'Driver';

  @override
  String get liveMap => 'Live Map';

  @override
  String get nearbyVehicle => 'Nearby Vehicle';

  @override
  String get eta => 'Estimated Arrival';

  @override
  String get routeInfo => 'Route Information';

  @override
  String get schedule => 'Daily Schedule';

  @override
  String get vehicleDetails => 'Vehicle Details';

  @override
  String get startTrip => 'Start Trip';

  @override
  String get endTrip => 'End Trip';

  @override
  String get vehicleStatus => 'Vehicle Status';

  @override
  String get available => 'Available';

  @override
  String get full => 'Full';

  @override
  String get delayed => 'Delayed';

  @override
  String get outOfService => 'Out of Service';

  @override
  String get emergency => 'Emergency Contact';

  @override
  String get rateDriver => 'Rate Driver';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get settings => 'Settings';

  @override
  String get selectStop => 'Select Your Stop';

  @override
  String get noVehiclesNearby => 'No vehicles nearby';

  @override
  String get tripActive => 'Trip Active';

  @override
  String get tripInactive => 'No Active Trip';

  @override
  String minutesAway(int minutes) {
    return '$minutes min away';
  }

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get createAccount => 'Create Account';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get currentPassengers => 'Current Passengers';

  @override
  String get assignedRoute => 'Assigned Route';

  @override
  String get offlineMode => 'Offline Mode - Showing cached data';

  @override
  String get notifications => 'Notifications';

  @override
  String get submit => 'Submit';

  @override
  String get cancel => 'Cancel';

  @override
  String get english => 'English';

  @override
  String get sinhala => 'Sinhala';

  @override
  String get tamil => 'Tamil';
}

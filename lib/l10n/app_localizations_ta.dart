// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'பட்டா டிராக்கர்';

  @override
  String get login => 'உள்நுழை';

  @override
  String get register => 'பதிவு செய்';

  @override
  String get email => 'மின்னஞ்சல்';

  @override
  String get password => 'கடவுச்சொல்';

  @override
  String get name => 'முழு பெயர்';

  @override
  String get phone => 'தொலைபேசி எண்';

  @override
  String get passenger => 'பயணி';

  @override
  String get driver => 'ஓட்டுநர்';

  @override
  String get liveMap => 'நேரடி வரைபடம்';

  @override
  String get nearbyVehicle => 'அருகிலுள்ள வாகனம்';

  @override
  String get eta => 'மதிப்பிடப்பட்ட வருகை நேரம்';

  @override
  String get routeInfo => 'வழித்தட தகவல்';

  @override
  String get schedule => 'தினசரி அட்டவணை';

  @override
  String get vehicleDetails => 'வாகன விவரங்கள்';

  @override
  String get startTrip => 'பயணத்தைத் தொடங்கு';

  @override
  String get endTrip => 'பயணத்தை முடி';

  @override
  String get vehicleStatus => 'வாகன நிலை';

  @override
  String get available => 'கிடைக்கிறது';

  @override
  String get full => 'நிரம்பியது';

  @override
  String get delayed => 'தாமதம்';

  @override
  String get outOfService => 'சேவையில் இல்லை';

  @override
  String get emergency => 'அவசர தொடர்பு';

  @override
  String get rateDriver => 'ஓட்டுநரை மதிப்பிடு';

  @override
  String get darkMode => 'இருண்ட பயன்முறை';

  @override
  String get language => 'மொழி';

  @override
  String get logout => 'வெளியேறு';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get selectStop => 'உங்கள் நிறுத்தத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get noVehiclesNearby => 'அருகில் வாகனங்கள் இல்லை';

  @override
  String get tripActive => 'பயணம் செயலில்';

  @override
  String get tripInactive => 'செயலில் பயணம் இல்லை';

  @override
  String minutesAway(int minutes) {
    return '$minutes நிமிடம்';
  }

  @override
  String get welcomeBack => 'மீண்டும் வரவேற்கிறோம்';

  @override
  String get createAccount => 'கணக்கை உருவாக்கு';

  @override
  String get forgotPassword => 'கடவுச்சொல் மறந்துவிட்டதா?';

  @override
  String get currentPassengers => 'தற்போதைய பயணிகள்';

  @override
  String get assignedRoute => 'ஒதுக்கப்பட்ட வழி';

  @override
  String get offlineMode =>
      'ஆஃப்லைன் பயன்முறை - சேமிக்கப்பட்ட தரவு காட்டப்படுகிறது';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get submit => 'சமர்ப்பி';

  @override
  String get cancel => 'ரத்து செய்';

  @override
  String get english => 'ஆங்கிலம்';

  @override
  String get sinhala => 'சிங்களம்';

  @override
  String get tamil => 'தமிழ்';
}

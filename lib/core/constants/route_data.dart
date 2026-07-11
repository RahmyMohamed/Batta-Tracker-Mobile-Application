import '../../models/stop_model.dart';

/// Predefined route: Kalpitiya ↔ Kandalkuliya with intermediate stops.
class RouteData {
  RouteData._();

  static const String routeId = 'kalpitiya_kandalkuliya';
  static const String routeName = 'Kalpitiya – Kandalkuliya';
  static const String routeNameSi = 'කල්පිටිය – කන්දකුලිය';
  static const String routeNameTa = 'கல்பிட்டி – கண்டக்குளிய';

  static List<StopModel> get defaultStops => [
        const StopModel(
          id: 'stop_kalpitiya',
          name: 'Kalpitiya',
          nameSi: 'කල්පිටිය',
          nameTa: 'கல்பிட்டி',
          latitude: 8.2311,
          longitude: 79.7614,
          order: 0,
          isCustom: false,
        ),
        const StopModel(
          id: 'stop_palliwasalthurai',
          name: 'Palliwasalthurai',
          nameSi: 'පල්ලිවාසල්තුරෙයි',
          nameTa: 'பல்லிவாசல்துறை',
          latitude: 8.1985,
          longitude: 79.7480,
          order: 1,
          isCustom: false,
        ),
        const StopModel(
          id: 'stop_norochcholai',
          name: 'Norochcholai',
          nameSi: 'නොරොච්චොලෛ',
          nameTa: 'நொரோச்சோலை',
          latitude: 8.0167,
          longitude: 79.7167,
          order: 2,
          isCustom: false,
        ),
        const StopModel(
          id: 'stop_kandalkuliya',
          name: 'Kandalkuliya',
          nameSi: 'කන්දකුලිය',
          nameTa: 'கண்டக்குளிய',
          latitude: 8.2450,
          longitude: 79.7850,
          order: 3,
          isCustom: false,
        ),
      ];

  /// Daily schedule times (departure from Kalpitiya)
  static const List<String> dailyDepartures = [
    '06:00', '07:30', '09:00', '11:00',
    '13:00', '15:00', '17:00', '18:30',
  ];
}

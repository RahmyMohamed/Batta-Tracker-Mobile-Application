# Batta Tracker

GPS-Based Real-Time Batta Lorry Tracking Mobile Application for the **Kalpitiya–Kandalkuliya** route, Sri Lanka.

Built with **Flutter** + **Firebase** + **Google Maps**.

## Features

### Passenger
- Register / login
- Live Batta Lorry map with Google Maps
- ETA for every stop on the route
- Push notification when vehicle is ~5 minutes away
- Daily schedule viewer
- Vehicle details & driver rating
- Emergency SOS contact
- Dark mode & trilingual UI (English, Sinhala, Tamil)
- Offline route/schedule caching

### Driver
- Secure login
- Start / end trips
- Continuous GPS sharing (every 5 seconds)
- Vehicle status (Available, Full, Delayed, Out of Service)
- Passenger count management
- Assigned route view

## Route Stops

1. Kalpitiya
2. Palliwasalthurai
3. Norochcholai
4. Kandalkuliya
5. Custom stops (admin-managed via Firestore)

## Quick Start

```bash
# 1. Install Flutter: https://docs.flutter.dev/get-started/install
flutter doctor

# 2. Get dependencies
flutter pub get
flutter gen-l10n

# 3. Configure Firebase
dart pub global activate flutterfire_cli
flutterfire configure

# 4. Add Google Maps API key (see docs/DEPLOYMENT_GUIDE.md)

# 5. Run
flutter run
```

## Project Structure

```
lib/
├── core/          # Constants, theme, utilities
├── models/        # Data models
├── services/      # Firebase & device services
├── providers/     # State management (Provider)
├── screens/       # UI screens
├── widgets/       # Reusable components
└── l10n/          # Localization (EN, SI, TA)

docs/
├── ARCHITECTURE.md
├── DATABASE_SCHEMA.md
├── USE_CASE_DIAGRAM.md
├── CLASS_DIAGRAM.md
├── WIREFRAMES.md
└── DEPLOYMENT_GUIDE.md

firebase/
├── firestore.rules
├── database.rules.json
└── seed_data.json
```

## Documentation

| Document | Description |
|----------|-------------|
| [Architecture](docs/ARCHITECTURE.md) | System design & data flow |
| [Database Schema](docs/DATABASE_SCHEMA.md) | Firestore & Realtime DB structure |
| [Use Case Diagram](docs/USE_CASE_DIAGRAM.md) | Actor use cases |
| [Class Diagram](docs/CLASS_DIAGRAM.md) | Models, services, providers |
| [Wireframes](docs/WIREFRAMES.md) | UI/UX screen layouts |
| [Deployment Guide](docs/DEPLOYMENT_GUIDE.md) | Full setup & release instructions |

## Tech Stack

- Flutter 3.x / Material Design 3
- Firebase Auth, Firestore, Realtime Database, FCM
- Google Maps Flutter SDK
- Provider state management
- Geolocator for GPS

## License

Educational / project use.

# Batta Tracker — Deployment Guide

## Prerequisites

| Tool | Version |
|------|---------|
| Flutter SDK | ≥ 3.2.0 |
| Dart SDK | ≥ 3.2.0 |
| Android Studio | Latest |
| Xcode (macOS) | ≥ 15 (for iOS) |
| Node.js | ≥ 18 (for Firebase CLI) |
| Firebase CLI | ≥ 13 |
| Google Cloud account | For Maps API |

---

## Step 1: Install Flutter

```bash
# Download from https://docs.flutter.dev/get-started/install
flutter doctor
```

Ensure Android toolchain and (on macOS) Xcode are configured.

---

## Step 2: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create project: **batta-tracker**
3. Enable services:
   - **Authentication** → Email/Password
   - **Cloud Firestore**
   - **Realtime Database**
   - **Cloud Messaging**

---

## Step 3: Configure FlutterFire

```bash
cd "d:\Batta Traker"
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates `lib/firebase_options.dart` and platform config files.

---

## Step 4: Google Maps API

1. Open [Google Cloud Console](https://console.cloud.google.com)
2. Enable APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
3. Create API key with restrictions

**Android** — `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

**iOS** — `ios/Runner/AppDelegate.swift`:
```swift
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```

---

## Step 5: Deploy Firebase Rules

```bash
firebase login
firebase init

# Select: Firestore, Realtime Database
# Use existing rules from firebase/ folder

firebase deploy --only firestore:rules
firebase deploy --only database
```

Copy rules from:
- `firebase/firestore.rules`
- `firebase/database.rules.json`

---

## Step 6: Seed Database

### Firestore — Routes & Stops

In Firebase Console → Firestore, create:

**Collection: `routes`**
- Document: `kalpitiya_kandalkuliya`
- Subcollection `stops`: import from `firebase/seed_data.json`

**Collection: `schedules`**
- Document: `kalpitiya_kandalkuliya` with `departures` array

### Sample Vehicle (for testing)

**Collection: `vehicles`**
```json
{
  "plateNumber": "WP-ABC-1234",
  "driverId": "<DRIVER_UID>",
  "routeId": "kalpitiya_kandalkuliya",
  "status": "available",
  "capacity": 20,
  "currentPassengers": 0,
  "model": "Batta Lorry",
  "color": "Blue"
}
```

---

## Step 7: Install Dependencies & Run

```bash
cd "d:\Batta Traker"
flutter pub get
flutter gen-l10n
flutter run
```

### Build Release APK

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Build iOS (macOS only)

```bash
flutter build ios --release
# Open ios/Runner.xcworkspace in Xcode for signing
```

---

## Step 8: Push Notifications Setup

### Android

1. Download `google-services.json` from Firebase Console
2. Place in `android/app/google-services.json`
3. Add to `android/build.gradle` and `android/app/build.gradle` per FlutterFire docs

### iOS

1. Download `GoogleService-Info.plist`
2. Place in `ios/Runner/`
3. Enable Push Notifications capability in Xcode
4. Upload APNs key to Firebase Console → Project Settings → Cloud Messaging

---

## Step 9: Testing Checklist

| Test | Steps |
|------|-------|
| Passenger registration | Register as Passenger, verify Firestore user doc |
| Driver registration | Register as Driver, verify driver + user docs |
| Start trip | Driver starts trip, check Realtime DB `live_locations` |
| Live map | Passenger sees orange marker updating |
| ETA | Verify ETA cards show minutes per stop |
| Notification | Select stop, wait until ≤5 min ETA |
| Vehicle status | Driver changes status, verify Firestore update |
| Offline mode | Disable network, verify cached route/schedule |
| Dark mode | Toggle in Settings |
| Language | Switch EN / SI / TA |
| Emergency | Tap SOS, verify dial intents |

---

## Environment Variables Summary

| Variable | Location |
|----------|----------|
| Firebase API keys | `lib/firebase_options.dart` |
| Google Maps key | `AndroidManifest.xml`, `AppDelegate.swift` |
| FCM sender ID | Auto from `google-services.json` |

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Maps blank/grey | Verify API key and enabled Maps SDK |
| Location not updating | Check permissions in device settings |
| Firebase auth error | Ensure Email/Password enabled in Console |
| Realtime DB write denied | Deploy `database.rules.json` |
| FCM not received | Check notification permissions, APNs setup |

---

## Production Recommendations

1. Restrict Google Maps API key to app package/bundle ID
2. Enable Firebase App Check
3. Set up Firebase Crashlytics
4. Use Firebase Hosting for admin dashboard (future)
5. Configure Cloud Functions for server-side ETA (future enhancement)

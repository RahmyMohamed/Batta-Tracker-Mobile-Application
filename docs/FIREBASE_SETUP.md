# Firebase Setup (fix "api-key-not-valid" error)

This error means the app is still using placeholder Firebase keys.

## Quick fix (manual — ~5 minutes)

### 1. Create / open Firebase project

Go to [Firebase Console](https://console.firebase.google.com/) and create a project (e.g. `batta-tracker`).

### 2. Enable Email/Password sign-in

Firebase Console → **Authentication** → **Sign-in method** → **Email/Password** → Enable.

### 3. Register a Web app (for Chrome)

Project Settings (gear icon) → **Your apps** → **Add app** → **Web** (`</>`).

Copy the `firebaseConfig` object. It looks like:

```javascript
const firebaseConfig = {
  apiKey: "AIza...",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abc..."
};
```

### 4. Paste into the project

Open **`lib/firebase_options_local.dart`** and update the `web` section:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIza...',           // from firebaseConfig.apiKey
  appId: '1:...:web:...',      // from firebaseConfig.appId
  messagingSenderId: '...',    // from firebaseConfig.messagingSenderId
  projectId: 'your-project',   // from firebaseConfig.projectId
  authDomain: 'your-project.firebaseapp.com',
  storageBucket: 'your-project.appspot.com',
);
```

For **Android**, also add an Android app in Firebase (package name: `com.example.batta_tracker`) and fill the `android` section. Download `google-services.json` into `android/app/`.

### 5. Restart the app

```bash
# Stop the current run (q), then:
flutter run -d chrome
```

Hot reload is **not** enough — full restart required.

---

## Automatic setup (FlutterFire CLI)

```bash
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
```

Select your project and platforms (web, android). This overwrites `firebase_options_local.dart` / generates config files.

---

## Still failing?

| Issue | Fix |
|-------|-----|
| `api-key-not-valid` | Keys not saved or wrong app (use **Web** keys for Chrome) |
| `auth/operation-not-allowed` | Enable Email/Password in Authentication |
| `project-not-found` | Wrong `projectId` in config |

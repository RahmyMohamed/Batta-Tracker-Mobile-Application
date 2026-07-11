# Batta Tracker — UI/UX Wireframes

## Design Principles

- **Material Design 3** with green primary (rural transport identity)
- Large touch targets for outdoor/rural use
- High contrast for sunlight readability
- Trilingual labels (EN / SI / TA)
- Bottom navigation for primary flows

---

## 1. Splash Screen

```
┌────────────────────────────┐
│                            │
│         ┌──────┐           │
│         │  🚌  │           │
│         └──────┘           │
│                            │
│      Batta Tracker         │
│  Kalpitiya – Kandalkuliya  │
│                            │
│           ○ ○ ○            │
│                            │
└────────────────────────────┘
```

---

## 2. Login Screen

```
┌────────────────────────────┐
│                            │
│           🚌               │
│      Welcome Back          │
│  Sign in to track lorries  │
│                            │
│  ┌──────────────────────┐  │
│  │ 📧 Email             │  │
│  └──────────────────────┘  │
│  ┌──────────────────────┐  │
│  │ 🔒 Password          │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │       LOGIN          │  │
│  └──────────────────────┘  │
│                            │
│   Don't have an account?   │
│        Register            │
└────────────────────────────┘
```

---

## 3. Passenger Dashboard (Home Tab)

```
┌────────────────────────────┐
│ Batta Tracker    ⚙️  🚪   │
├────────────────────────────┤
│ ┌────────────────────────┐ │
│ │ Route: Kalpitiya –     │ │
│ │        Kandalkuliya    │ │
│ │ 4 stops                │ │
│ └────────────────────────┘ │
│                            │
│ ┌────────────────────────┐ │
│ │ 📍 Select Your Stop  ▼ │ │
│ └────────────────────────┘ │
│                            │
│ ┌────────────────────────┐ │
│ │ 🚌 Nearby Vehicle      │ │
│ │ 1 active vehicle  📡   │ │
│ └────────────────────────┘ │
│                            │
│ Estimated Arrival Times    │
│ ┌────────────────────────┐ │
│ │ ① Kalpitiya    5 min  │ │
│ ├────────────────────────┤ │
│ │ ② Palliwasa..  12 min │ │
│ ├────────────────────────┤ │
│ │ ③ Norochcholai 25 min │ │
│ └────────────────────────┘ │
│                     [SOS]  │
├────────────────────────────┤
│ 🏠  🗺️  📅  🚌           │
└────────────────────────────┘
```

---

## 4. Passenger Live Map Tab

```
┌────────────────────────────┐
│ Batta Tracker    ⚙️  🚪   │
├────────────────────────────┤
│                            │
│    🟢 Kalpitiya            │
│         ╲                  │
│          ╲  🟠 Lorry       │
│           ╲                │
│    🟢 Norochcholai         │
│         ╱                  │
│    🟢 Kandalkuliya         │
│                            │
│         [Google Map]       │
│                            │
├────────────────────────────┤
│ Kalpitiya  Palliwasa  Noro │
│   5 min      12 min   25m  │
├────────────────────────────┤
│ 🏠  🗺️  📅  🚌           │
└────────────────────────────┘
```

---

## 5. Driver Dashboard

```
┌────────────────────────────┐
│ Driver Dashboard  ⚙️  🚪  │
├────────────────────────────┤
│ ┌────────────────────────┐ │
│ │      📡 Trip Active    │ │
│ │ Sharing location /5s   │ │
│ └────────────────────────┘ │
│                            │
│ ┌────────────────────────┐ │
│ │     ⏹ END TRIP         │ │
│ └──────────────────────┘   │
│                            │
│ Vehicle Status             │
│ [Available][Full][Delayed] │
│                            │
│ ┌────────────────────────┐ │
│ │ Current Passengers     │ │
│ │    [−]   12   [+]      │ │
│ │    Capacity: 20        │ │
│ └────────────────────────┘ │
│                            │
│ ┌────────────────────────┐ │
│ │ 🛣 Assigned Route      │ │
│ │ Kalpitiya–Kandalkuliya │ │
│ │              4 stops → │ │
│ └────────────────────────┘ │
│                            │
│ ┌────────────────────────┐ │
│ │ 🚌 WP-ABC-1234        │ │
│ │ Batta Lorry  [Avail.] │ │
│ └────────────────────────┘ │
└────────────────────────────┘
```

---

## 6. Settings Screen

```
┌────────────────────────────┐
│ ← Settings                 │
├────────────────────────────┤
│ 🌙 Dark Mode        [═══]  │
├────────────────────────────┤
│ 🌐 Language                │
│   ○ English                │
│   ● Sinhala                │
│   ○ Tamil                  │
├────────────────────────────┤
│ ℹ️ About                   │
│ Batta Tracker v1.0.0       │
│ Kalpitiya – Kandalkuliya   │
└────────────────────────────┘
```

---

## 7. Emergency Dialog

```
┌────────────────────────────┐
│ 🚨 Emergency Contact       │
├────────────────────────────┤
│ 👮 Police          119  →  │
│ 🏥 Ambulance       110  →  │
│ 📞 Transport Hotline  →   │
├────────────────────────────┤
│                    Close   │
└────────────────────────────┘
```

---

## Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Primary Green | `#2E7D32` | App bar, buttons, route |
| Light Green | `#4CAF50` | Accents, active states |
| Accent Orange | `#FF8F00` | Vehicle markers, SOS, near-arrival |
| Error Red | `#D32F2F` | Emergency, end trip |
| Surface Light | `#F5F7FA` | Background |
| Surface Dark | `#121212` | Dark mode background |

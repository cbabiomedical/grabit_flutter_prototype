# GrabIt – Flutter Prototype App

**GrabIt** is a proximity-based smart vending mobile application built using **Flutter**, designed to integrate with a **Node.js + MySQL backend** and real-world **BLE beacons + vending machines**.

This repository contains the **full frontend prototype**, developed using a **Mock-first → Real API later strategy**, enabling:

- Parallel frontend & backend development
- Fast investor-ready demos
- Zero rewrites during final integration

---

## Key Features

- Secure User Authentication (Register, Verify OTP, Login)
- **User-Friendly Unique ID** (e.g., `GRB-A92F41`)
- Beacon-based proximity detection (mock + real-ready)
- Promotion delivery via push notifications
- Promotions displayed in-app
- QR-based vending session start
- Vending machine + backend completes purchase
- Loyalty points earned after each purchase
- Bottom Navigation with 5 main tabs
- Home + Map view
- Settings with Beacon toggle & Logout
- Full **Mock Backend Support**
- Switchable **Real Node.js API Integration**

---

## Tech Stack

### Frontend

- Flutter (Android-first)
- Dart
- Provider (State Management)
- BLE (Beacon scanning – mock & real)
- QR Scanning
- Secure Local Storage

### Backend (Final Target)

- Node.js
- MySQL 5.7
- Firebase Cloud Messaging (for push notifications)

> This repo uses a Mock API Service by default for full offline testing.
>

---

## Project Folder Structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── app_routes.dart
│   └── app_theme.dart
├── core/
│   ├── constants/
│   ├── storage/
│   ├── permissions/
│   └── utils/
├── models/
├── services/
│   ├── api_service.dart
│   ├── mock_api_service.dart
│   ├── auth_service.dart
│   ├── beacon_service.dart
│   ├── notification_service.dart
│   ├── qr_service.dart
│   └── device_service.dart
├── providers/
├── features/
│   ├── splash/
│   ├── auth/
│   ├── home/
│   ├── promotion/
│   ├── qr_scan/
│   ├── points/
│   └── settings/
└── widgets/

```

This follows **Clean Architecture**

Zero business logic in UI

No API logic in screens

Strict Provider + Service separation

---

## Mock Backend → Real Backend Switch

All backend access is routed through:

```
ApiService (Abstract)
   |
   |-- MockApiService   ← used during prototype
   |-- RealApiService   ← used during Node.js integration

```

Switch happens in **one place only**:

```dart
const bool useMockApi = true;

```

Change this to `false` when Node.js APIs are ready

**Zero code rewrite required**

---

## 👤 User Identity Rules

- Backend returns:

    ```
    userId = "88e1c9f2-bd92-4e..."
    
    ```

- App displays:

    ```
    GRB-BD92F2
    
    ```


Last 6 chars of real ID

Uppercase

Prefixed with `GRB-`

Never editable by user

---

## Bottom Navigation Tabs

After login, users see:

1. Home
2. Promotions
3. QR Scan
4. Points
5. Settings

Hidden during Splash/Login/Register

State preserved across tabs

---

## Promotion Flow (Final)

```
Beacon Detected
      ↓
Backend Reserves Promotion
      ↓
Push Notification Sent
      ↓
User Taps Notification
      ↓
Promotion Shown in App
      ↓
User Walks to Machine
      ↓
QR Scanned → Session Starts
      ↓
User Purchases on Machine
      ↓
Backend Finalizes Transaction
      ↓
Loyalty Points Updated

```

App **does NOT handle payments**

App **does NOT apply discounts**

App only **initiates session and displays promotions**

---

## Setup Instructions

```bash
flutter create grabit_flutter_app
cd grabit_flutter_app
flutter pub get
flutter run

```

Works fully with **Mock Backend**

No backend required to test entire user journey

---

## 6-Day Aggressive Prototype Plan

| Day | Module |
| --- | --- |
| Day 0 | Structure, Models, Mock Setup |
| Day 1 | Auth + User ID |
| Day 2 | Home + Map + Bottom Nav |
| Day 3 | Promotions + Points |
| Day 4 | Beacon + Settings |
| Day 5 | Notifications |
| Day 6 | QR + Session + Final Demo |

Each day has a **strict Exit Criteria Checklist**

No day is closed unless **100% complete**

---

## Security Principles

- Secure Storage for:
    - userId
    - authToken
    - deviceId
- All API calls require:

    ```
    Authorization: Bearer <token>
    
    ```

- No sensitive logic in frontend
- No price or discount calculation on mobile

---

## Development Rules (Zero-Rewrite Policy)

- No hardcoded API responses in UI
- No direct HTTP calls from widgets
- No navigation logic in providers
- Only Services talk to APIs
- Only Providers manage state
- Only Widgets render UI

---

## Testing Strategy

- Full end-to-end demo supported via Mock
- Beacon simulation supported
- QR simulation supported
- Notification simulation supported
- Session simulation supported

---

## Final Integration Phase (Later)

When backend is ready:

1. Implement `RealApiService`
2. Switch `useMockApi = false`
3. Point to:

    ```
    https://api.yourdomain.com
    
    ```

4. Test on:
    - Dev
    - Staging
    - Production

No UI changes required

No Provider changes required

---

## License

This project is a **private prototype** for internal evaluation, hardware integration, and investor demonstration.

---

## Status

- Mock-first architecture: Ready
- Parallel development enabled: Yes
- QR + Beacon + Notification flow: Supported
- Node.js backend compatibility: Guaranteed
- Zero rewrite integration: Enforced
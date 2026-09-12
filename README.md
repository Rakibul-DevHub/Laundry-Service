# Laundry Service

**Laundry Service** is a Flutter mobile app for on-demand laundry, dry cleaning, and related pickup/delivery services. One codebase serves three roles: **Guests** (customers), **Couriers** (riders), and **Agents** (service providers).

Package name: `drop_n_fresh`  
Android application ID: `com.dropnfresh.app`  
Version: `1.0.0+1`

---

## Overview

The app connects customers who need laundry and garment care with local agents and couriers who pick up, process, and return items.

| Role in the UI | Internal role | Who it is for |
| --- | --- | --- |
| Guest | `user` | Customers who order bags, book services, and track orders |
| Courier | `rider` | Drivers who accept pickup and delivery jobs |
| Agent | `provider` | Businesses that offer wash, fold, press, and dry-cleaning services |

Users sign in once. If a valid access token is still active, splash restores the session and opens the matching home for that role.

---

## Features

### Guest

- Email sign-up and sign-in with OTP verification
- Onboarding and saved delivery locations
- Order reusable bags, with address selection that does **not** change the account default location
- Browse nearby agents and book services (schedule, products, delivery method, checkout)
- Track orders and view order history
- In-app messages with agents
- Push notifications
- Profile, photo upload, password change, and account deletion
- Stripe-hosted checkout for bag and service payments

### Courier

- Identity verification (ID, driving license, selfie, vehicle)
- Online / offline status for job availability
- Incoming job requests with location and payout
- Job tracking, checkpoints, and completion flow
- Earnings, transactions, and withdrawals
- Stripe Connect onboarding for payouts

### Agent

- Business profile, documents, and business hours
- Create and manage services and product categories
- Incoming bookings: accept, process, and complete
- Order overview by status
- Earnings, transactions, and withdrawals
- Stripe Connect onboarding for payouts

### Shared

- Role-based routing and bottom navigation
- Secure token storage and session restore on splash
- Access-token refresh when the token is expired
- Support, Terms, Privacy, and About content from the API
- Google Maps for location picking
- Firebase Cloud Messaging for push notifications

---

## Tech stack

| Area | Choice |
| --- | --- |
| Framework | Flutter (Dart SDK `^3.9.2`) |
| State management | Riverpod |
| Navigation | GoRouter with public-route and role guards |
| Networking | Dio, interceptors, typed REST client |
| Local storage | `flutter_secure_storage` |
| Auth | JWT access + refresh tokens |
| Maps | Google Maps, Geolocator, Geocoding |
| Payments | Stripe Checkout / Stripe Connect |
| Push | Firebase Core, Firebase Messaging, local notifications |
| Media | Cached network images, SVG, video, image/file pickers |
| Other | QR, barcode scanner, WebView, HTML content, shimmer loaders |

---

## Architecture

The project is feature-first. Each feature typically includes screens, widgets, notifiers, state, models, and providers.

```text
lib/
├── main.dart                         # App entry, Firebase, ProviderScope
├── screens.dart                      # Screen exports
│
├── app/
│   ├── app.dart                      # Root MaterialApp
│   ├── api/                          # Dio client, endpoints, interceptors
│   ├── router/                       # GoRouter, route paths, role guards
│   ├── providers/                    # API client and storage providers
│   ├── theme/                        # Text styles and theming
│   └── toast/                        # In-app toasts
│
├── core/
│   ├── config/                       # Colors, sizes, strings, legal copy
│   ├── constants/                    # API base URL, media URL helpers
│   ├── storage/                      # Secure storage
│   ├── services/                     # Notifications
│   ├── utils/                        # Logger, validation, JWT helpers
│   └── extensions/
│
├── features/
│   ├── auth/
│   ├── bags/
│   ├── home/                         # Guest, Courier, Agent homes
│   ├── services/
│   ├── orders/
│   ├── jobs/
│   ├── earnings/
│   ├── message/
│   ├── notification/
│   ├── profile/
│   ├── location/
│   └── bottom_nav/
│
└── shared/
    ├── widgets/
    ├── enums/
    └── models/

```

---

## Getting Started

```bash
git clone <repository-url>
flutter pub get
flutter run

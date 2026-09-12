# Laundry Service

A comprehensive on-demand laundry & dry cleaning service platform built with Flutter. Connects users, service providers, and delivery riders in a seamless ecosystem.

---


## Features

### User App
- Place & track laundry orders
- Messaging with providers
- View order history
- Secure Stripe payment integration
- Location-based service selection

### Provider Dashboard
- Manage orders by status
- Accept/Reject orders with one tap
- Detailed pricing & customer info

### Rider App
- Available jobs with location & payout
- Accept/Remove jobs instantly
- Earnings tracking & history
- Stripe Connect for payouts

---


## Tech Stack

```yaml
Framework: Flutter 3.x
State Management: Riverpod
Navigation: GoRouter
Networking: Dio + Interceptors
Storage: flutter_secure_storage
UI: Custom widgets + Shimmer loading
API: REST + Socket.IO ready
Payments: Stripe Connect
```

---

## Project Structure

```yaml
  lib/
  ├── app/                     # App configuration, router, providers
  │   ├── api/                 # API client, interceptors
  │   ├── router/              # GoRouter configuration
  │   └── providers/           # Global providers
  ├── core/                    # Utils, extensions, config, storage
  │   ├── config/              # Colors, sizes, icons
  │   ├── extensions/          # Context extensions
  │   ├── storage/             # Secure storage service
  │   └── utils/               # Logger, exceptions
  ├── features/                # Feature modules
  │   ├── auth/                # Authentication
  │   ├── bookings/            # Order booking flow
  │   ├── orders/              # User order management
  │   ├── messaging/           # Chat system
  │   ├── earnings/            # Revenue tracking
  │   └── riders/              # Rider job management
  ├── shared/                  # Reusable widgets & components
  │   ├── widgets/             # Common UI components
  │   └── shimmer/             # Loading skeletons
  └── main.dart                # Entry point
  └── app.dart
```

## Getting Started

```bash
# Clone the repository
git clone https://github.com/sparktechagency/drop-n-fresh-app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

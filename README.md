# Flutter Feature Showcase

This is a small Flutter project I use to share some of the work I have done in a private application. I kept three parts that are useful for a code review: authentication, realtime chat, and in-app purchases.

The original API, Firebase project, store accounts, and business data are not included. The app uses local demo data, so it can be opened without any setup.

## Features

### Authentication

- Email and password validation
- Repository and data source layers
- Loading, error, signed-in, and signed-out states
- Dio interceptor for authenticated requests

### Realtime chat

- Messages delivered through a `Stream`
- Separate data source and repository
- Sending state and simulated incoming messages
- Controller subscription and cleanup

### In-app purchases

- Product loading
- Purchase and restore flows
- Purchase status stream
- `in_app_purchase` implementation for App Store and Google Play
- Local store implementation used by the demo

## Project Structure

```text
lib/
├── core/
│   ├── constants/
│   ├── di/
│   ├── error/
│   ├── network/
│   ├── theme/
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── chat/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── payment/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── app.dart
└── main.dart
```

Dependencies are registered in `lib/core/di/injection.dart`. The UI works with repository interfaces, while the data folder contains the concrete implementations.

## Run

```bash
flutter pub get
flutter run
```

Demo account:

```text
Email: demo@example.com
Password: password123
```

## Tests

```bash
flutter analyze
flutter test
```

The tests cover repository mapping, chat stream updates, app navigation, and the demo sign-in flow.

## Private Project Note

Before creating this repository, I removed the original Firebase files, API URLs, keys, package names, store product IDs, signing settings, and user data. `https://api.example.invalid` is only a placeholder and is never called by the demo.

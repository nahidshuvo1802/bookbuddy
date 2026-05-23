# BookBuddy 📚

A clean Flutter app for discovering books using the Google Books API. Built with Riverpod, Hive, and MVC architecture.

## Features

- Search books by title or author
- View book details (title, authors, description, publish date)
- Save favorites locally with Hive
- Infinite scroll pagination
- Pull to refresh
- App flavors (dev / prod)
- Graceful error handling with retry

## Tech Stack

| Concern | Library |
|---|---|
| State Management | flutter_riverpod |
| HTTP | http |
| Local Storage | hive_flutter |
| Image Caching | cached_network_image |

## Project Structure (MVC)

```
lib/
├── main_dev.dart              # Dev flavor entry point
├── main_prod.dart             # Prod flavor entry point
├── app.dart                   # MaterialApp root
├── config/
│   └── app_config.dart        # Flavor config (base URL, app name)
├── models/
│   └── book.dart              # Book model + Hive adapter
├── controllers/
│   ├── book_controller.dart   # Book list state (Riverpod)
│   └── favorite_controller.dart # Favorites state (Hive + Riverpod)
├── views/
│   ├── home_view.dart         # Book list screen
│   ├── book_detail_view.dart  # Book detail screen
│   └── widgets/
│       ├── book_card.dart     # Book list item
│       └── error_widget.dart  # Error/empty state
└── services/
    ├── api_client.dart        # HTTP wrapper with error handling
    └── api_url.dart           # API endpoint builder
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.10+)
- Android Studio / Xcode

### Install dependencies

```bash
flutter pub get
```

### Run the app

**Dev flavor:**
```bash
flutter run --flavor dev -t lib/main_dev.dart
```

**Prod flavor:**
```bash
flutter run --flavor prod -t lib/main_prod.dart
```

## Flavor Setup

The app uses **two flavors** — `dev` and `prod` — each with a different base URL and app name.

### How it works:

1. **Dart side**: Two entry points (`main_dev.dart`, `main_prod.dart`) each call `AppConfig.init()` with the flavor-specific `baseUrl` and `appName`.

2. **Android side**: `build.gradle.kts` defines `productFlavors` with different `applicationIdSuffix` and `resValue` for each flavor.

3. **Usage**: Run with `--flavor dev -t lib/main_dev.dart` or `--flavor prod -t lib/main_prod.dart`.

| Flavor | App Name | Base URL | App ID Suffix |
|---|---|---|---|
| dev | BookBuddy Dev | `https://www.googleapis.com/books/v1` | `.dev` |
| prod | BookBuddy | `https://www.googleapis.com/books/v1` | (none) |

> In a real project, the base URLs would differ (e.g., staging vs production server).

## State Management

**Riverpod** with `StateNotifier` pattern:

- `BookController` — manages book list, pagination, search, loading, and error states
- `FavoriteController` — manages favorites using Hive for persistence

Both expose their state through `StateNotifierProvider` and are consumed by views using `ConsumerWidget` / `ConsumerStatefulWidget`.

## API

Uses the [Google Books API](https://developers.google.com/books/docs/v1/using) — no API key required for basic volume searches.

**Endpoint:** `GET /volumes?q={query}&startIndex={index}&maxResults=20`

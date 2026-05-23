# BookBuddy 📚

A clean, modular Flutter application for discovering and favoriting books using the Google Books API. Designed with a robust separation of concerns using **Riverpod (State Management)**, **Hive (Local Database)**, and **Clean MVC Architecture**.

---

## Tech Stack & Architecture

- **State Management**: `flutter_riverpod` (StateNotifier pattern for predictable state flow)
- **Networking**: `http` with automated backoff retry logic (handles HTTP 429 rate limits)
- **Local Storage**: `hive_flutter` for persistent favorites storage without heavy code gen dependencies
- **Image Caching**: `cached_network_image` to handle cover image optimizations and connection issues

---

## Setup Instructions

### 1. Prerequisites
- **Flutter SDK**: Ensure you have Flutter installed (`>= 3.10.0`).
- **Android/iOS SDK**: Set up Android Studio or Xcode to compile.

### 2. Environment Variables (`.env`)
The app uses environment variables to authenticate API requests securely. Because the `.env` file contains sensitive API keys, it is ignored by Git.

**You must create a `.env` file in the root directory of the project** with the following variables:

```env
API_KEY_DEV=your_dev_google_books_api_key
API_KEY_PROD=your_prod_google_books_api_key
```

> **Note**: You can get an API key from the [Google Cloud Console](https://console.cloud.google.com/) by enabling the *Books API*.

### 3. Install Dependencies
Run the following command in the root folder to download the required packages:

```bash
flutter pub get
```

---

## How to Run the Project

Launch the application in debug mode on your connected device or emulator.

### Development Flavor
```bash
flutter run --flavor dev -t lib/main_dev.dart
```

### Production Flavor
```bash
flutter run --flavor prod -t lib/main_prod.dart
```

---

## How to Build the App

Compile a release build (APK / Bundle / IPA) for distribution.

### Build Android APK
- **Development Release**:
  ```bash
  flutter build apk --flavor dev -t lib/main_dev.dart
  ```
- **Production Release**:
  ```bash
  flutter build apk --flavor prod -t lib/main_prod.dart
  ```

### Build iOS Release
- **Development Release**:
  ```bash
  flutter build ipa --flavor dev -t lib/main_dev.dart
  ```
- **Production Release**:
  ```bash
  flutter build ipa --flavor prod -t lib/main_prod.dart
  ```

---

## Flavor Setup Explanation

The app leverages Flutter/Gradle flavor dimensions to decouple development and production configurations.

### Key Architecture Components:
1. **AppInitializer (`lib/config/app_initializer.dart`)**:
   Consolidates boot logic (Hive registry, `.env` parsing, bindings) and binds environment-specific API keys dynamically.
2. **Flavor Entry Points**:
   - `lib/main_dev.dart` runs the dev config and binds `API_KEY_DEV`.
   - `lib/main_prod.dart` runs the prod config and binds `API_KEY_PROD`.
3. **Android Configuration (`android/app/build.gradle.kts`)**:
   Defines the flavor dimensions and configuration overrides:
   - **`dev`**: App name is configured as **BookBuddy Dev** with application ID suffix `.dev`.
   - **`prod`**: App name is configured as **BookBuddy** with no suffix.

| Flavor | Application ID Suffix | Display Name | Config Key Used |
|---|---|---|---|
| **dev** | `.dev` | BookBuddy Dev | `API_KEY_DEV` |
| **prod** | (none) | BookBuddy | `API_KEY_PROD` |

---

## State Management Approach

State management is handled via **Riverpod** with a predictable unidirectional data flow matching clean MVC structures:

- **State Layer (`BookState`)**:
  Represents a single immutable snapshot of the books screen state (books list, paging indices, query string, loading states, and error strings).
- **Controller Layer (`BookController`)**:
  Manages request queuing, state changes, search debouncing, and pagination checks. It features request guards to prevent duplicate concurrent API requests on rapid scroll.
- **Favorites Layer (`FavoriteController`)**:
  Listens to Hive box updates and exposes favorites globally. When a book is favorited, state change notifications trigger atomic UI updates.

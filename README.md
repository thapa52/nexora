# Nexora

A modern, production-ready Flutter application built with
Clean Architecture and Riverpod state management.

> Currently under active development

---

## Features (Planned)

- Authentication — Secure login and registration flow
- Developer News Feed — Real-time stories from Hacker News API
- Bookmarking — Save and manage favorite stories offline
- Search & Filter — Find stories by keyword and category
- Dark / Light Theme — System-aware with manual toggle
- Offline Support — Read saved content without internet

---

## Tech Stack

| Category | Technology |
|---|---|
| Framework | Flutter 3.29.3 |
| State Management | Riverpod 2.6.1 |
| Navigation | GoRouter 17.0.0 |
| Networking | Dio 5.9.2 |
| Code Generation | Freezed 3.1.0 |
| Environment | flutter_dotenv 6.0.1 |
| Architecture | Clean Architecture |
| API | Hacker News API |

---

## Architecture

Nexora follows **Clean Architecture** principles:

```
Presentation Layer  →  UI, Screens, Widgets, Riverpod Providers
Domain Layer        →  Entities, Use Cases, Repository Interfaces
Data Layer          →  API, Local DB, Repository Implementations, DTOs
```

---

## Folder Structure

```
lib/
├── core/
│   ├── constants/          # App and API constants
│   ├── errors/             # Exceptions and Failure types
│   ├── extensions/         # Context and String extensions
│   ├── network/            # Dio client and interceptors
│   │   └── interceptors/   # Logging interceptor
│   ├── theme/              # Colors, text styles, app theme
│   └── utils/              # Validators, date formatter
├── features/
│   ├── auth/               # Authentication
│   │   ├── data/           # Datasources, models, repository impl
│   │   ├── domain/         # Entities, repository interface, use cases
│   │   └── presentation/  # Providers, screens, widgets
│   ├── news/               # Developer news feed
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── bookmarks/          # Saved stories
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/
│   ├── widgets/            # Reusable widgets
│   └── providers/          # Shared providers
├── router/                 # App navigation
└── main.dart
```

---

## Completed

- [x] Project setup and folder structure
- [x] Core constants (app + API)
- [x] Error handling (exceptions + Freezed failures)
- [x] Theme system (colors, text styles, light/dark theme)
- [x] Extensions (context + string)
- [x] Utilities (validators + date formatter)
- [x] Network layer (Dio client + logging interceptor)
- [x] Authentication feature
  - [x] Domain layer (UserEntity, AuthRepository, Use Cases)
  - [x] Data layer (UserModel, LocalDatasource, RepositoryImpl)
  - [x] Presentation layer (Riverpod providers, Login/Register screens)
  - [x] Navigation guards with GoRouter
  - [x] Session persistence with FlutterSecureStorage
  - [x] Form validation
- [x] News feed feature
  - [x] Domain layer (StoryEntity, NewsRepository, Use Cases)
  - [x] Data layer (StoryModel, RemoteDatasource, RepositoryImpl)
  - [x] Presentation layer (Riverpod providers, News Feed screen)
  - [x] Real Hacker News API integration
  - [x] Infinite scroll pagination
  - [x] Pull to refresh
  - [x] Category switching (Top, New, Best)
  - [x] Error handling with retry
- [x] Unit tests
  - [x] Validator tests
  - [x] Date formatter tests
  - [x] Auth use case tests (login, register, logout)
  - [x] News model and use case tests
- [ ] Bookmarks feature
- [ ] Shared widgets
- [ ] Theme switching

---

## Getting Started

### Prerequisites

- Flutter SDK 3.29.3
- Dart SDK 3.7.2

### Installation

```bash
# Clone the repository
git clone https://github.com/thapa52/nexora.git
cd nexora

# Create .env file (see .env.example)
cp .env.example .env

# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

---

## Testing

Unit tests are implemented for core utilities and feature use cases.
Widget and integration tests are planned for future implementation.

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/core/utils/validators_test.dart

# Run with verbose output
flutter test --reporter expanded
```

---

## Developer

**Pradeep Thapa**
Flutter Developer
[GitHub](https://github.com/thapa52)
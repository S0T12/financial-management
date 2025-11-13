# Development Guide

## Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code with Flutter extensions
- Git

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd financial-management
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code

The project uses code generation for Drift database, Riverpod, and JSON serialization:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

For continuous generation during development:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 4. Run the Application

```bash
# Run on connected device/emulator
flutter run

# Run in release mode
flutter run --release

# Run on specific device
flutter run -d <device-id>
```

### 5. Run Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/data/services/sms_parser_service_test.dart
```

## Code Generation

The project uses several code generators:

### Drift (Database)

Generates database code from table definitions:

- Input: `*_table.dart` files
- Output: `*.g.dart` files

### Riverpod

Generates providers:

- Input: Files with `@riverpod` annotations
- Output: `*.g.dart` files

### Freezed (Optional)

For immutable data classes:

- Input: Files with `@freezed` annotations
- Output: `*.freezed.dart` files

## Project Structure

```
lib/
├── core/                 # Core utilities and base classes
│   ├── constants/        # App-wide constants
│   ├── error/           # Error handling
│   ├── localization/    # i18n support
│   ├── theme/           # App theming
│   ├── usecases/        # Base use case class
│   └── utils/           # Utility functions
│
├── data/                # Data layer
│   ├── datasources/     # Database, SMS access
│   ├── models/          # Data models
│   ├── repositories/    # Repository implementations
│   └── services/        # Services (SMS parser, etc.)
│
├── domain/              # Domain layer
│   ├── entities/        # Business entities
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Business use cases
│
├── presentation/        # Presentation layer
│   ├── providers/       # Riverpod providers
│   ├── screens/         # Full-page screens
│   ├── viewmodels/      # ViewModels
│   └── widgets/         # Reusable widgets
│
└── main.dart           # App entry point
```

## Development Workflow

### 1. Creating a New Feature

#### Step 1: Domain Layer

```dart
// 1. Create entity in domain/entities/
class MyEntity {
  final String id;
  final String name;
  // ...
}

// 2. Create repository interface in domain/repositories/
abstract class MyRepository {
  Future<Either<Failure, MyEntity>> getEntity(String id);
}

// 3. Create use case in domain/usecases/
class GetEntity implements UseCase<MyEntity, String> {
  final MyRepository repository;

  GetEntity(this.repository);

  @override
  Future<Either<Failure, MyEntity>> call(String id) {
    return repository.getEntity(id);
  }
}
```

#### Step 2: Data Layer

```dart
// 1. Create table in data/datasources/local/tables/
class MyEntities extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  // ...
}

// 2. Implement repository in data/repositories/
class MyRepositoryImpl implements MyRepository {
  final AppDatabase database;

  MyRepositoryImpl(this.database);

  @override
  Future<Either<Failure, MyEntity>> getEntity(String id) async {
    // Implementation
  }
}
```

#### Step 3: Presentation Layer

```dart
// 1. Create ViewModel
class MyViewModel extends StateNotifier<MyState> {
  final GetEntity getEntity;

  MyViewModel(this.getEntity) : super(MyState.initial());

  Future<void> loadEntity(String id) async {
    // Load and update state
  }
}

// 2. Create provider
final myViewModelProvider = StateNotifierProvider<MyViewModel, MyState>((ref) {
  return MyViewModel(ref.watch(getEntityProvider));
});

// 3. Create screen
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myViewModelProvider);
    // Build UI
  }
}
```

### 2. Adding a New Database Table

1. Create table definition in `data/datasources/local/tables/`
2. Add table to `AppDatabase` in `app_database.dart`
3. Run code generation: `flutter pub run build_runner build --delete-conflicting-outputs`
4. Implement repository
5. Create use cases

### 3. Adding Localization

1. Add keys to `assets/localization/fa.json` and `en.json`
2. Use in UI: `context.tr('key')`

### 4. Running Code Analysis

```bash
# Analyze code
flutter analyze

# Check formatting
dart format --set-exit-if-changed .

# Fix formatting
dart format .
```

## Best Practices

### 1. State Management

- Use `StateNotifier` for complex state
- Use `Provider` for dependencies
- Keep ViewModels thin (delegate to use cases)

### 2. Error Handling

- Always use `Either<Failure, Success>` for operations that can fail
- Handle both success and error cases in UI
- Show user-friendly error messages

### 3. Database Operations

- Use transactions for multi-step operations
- Handle foreign key constraints properly
- Add proper indices for performance

### 4. UI/UX

- Support both RTL and LTR layouts
- Use Material 3 design guidelines
- Implement proper loading states
- Show meaningful error messages

### 5. Testing

- Write unit tests for use cases
- Test ViewModels thoroughly
- Add widget tests for complex UI
- Test SMS parser with real examples

## Common Issues

### Build Runner Issues

```bash
# Clear cache and regenerate
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Database Migration Issues

- Increment schema version in `app_database.dart`
- Implement migration in `onUpgrade` callback
- Test migration thoroughly

### SMS Permission Issues

- Request permission at runtime
- Handle permission denial gracefully
- Provide manual entry option

## Performance Optimization

1. **Database**

   - Add indices for frequently queried columns
   - Use batch operations for multiple inserts
   - Limit query results appropriately

2. **UI**

   - Use `const` constructors where possible
   - Implement proper list view recycling
   - Lazy load data when needed

3. **State Management**
   - Minimize state rebuilds
   - Use selector providers for specific data
   - Implement proper caching

## Debugging Tips

1. **Database Issues**

   ```bash
   # View database in device
   adb shell
   run-as com.example.financial_management
   cd app_flutter
   sqlite3 financial_management.db
   ```

2. **State Management**

   - Use Riverpod DevTools
   - Add logging in ViewModels
   - Check provider dependencies

3. **SMS Parsing**
   - Log raw SMS messages
   - Test with real bank SMS
   - Handle edge cases

## Release Build

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Drift Documentation](https://drift.simonbinder.eu)
- [Material Design 3](https://m3.material.io)

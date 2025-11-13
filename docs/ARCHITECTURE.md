# Architecture Overview

This document provides an overview of the application's architecture and design patterns.

## Clean Architecture

The application follows Clean Architecture principles with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────┐
│                   Presentation Layer                    │
│  (UI, ViewModels, Widgets, State Management)           │
│                                                         │
│  • Screens (Dashboard, Transactions, Reports)          │
│  • ViewModels with Riverpod                            │
│  • Reusable Widgets                                    │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                    Domain Layer                         │
│        (Business Logic, Entities, Use Cases)           │
│                                                         │
│  • Entities (Account, Transaction, Transfer)           │
│  • Repository Interfaces                               │
│  • Use Cases (Single Responsibility)                   │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                     Data Layer                          │
│   (Repository Implementations, Data Sources)           │
│                                                         │
│  • Local Database (Drift)                              │
│  • Repository Implementations                          │
│  • Data Models & Mapping                               │
└─────────────────────────────────────────────────────────┘
```

## Layers Explanation

### 1. Presentation Layer

- **Responsibility**: User interface and user interaction
- **Technologies**: Flutter widgets, Riverpod for state management
- **Components**:
  - Screens: Full-page views
  - ViewModels: Business logic for UI
  - Widgets: Reusable UI components

### 2. Domain Layer

- **Responsibility**: Core business logic (platform-independent)
- **Components**:
  - Entities: Core business objects
  - Repository Interfaces: Abstract data access
  - Use Cases: Single-purpose business operations

### 3. Data Layer

- **Responsibility**: Data persistence and external data sources
- **Technologies**: Drift (SQLite), SMS parsing
- **Components**:
  - Repository Implementations
  - Local Database (DAOs, Tables)
  - Services (SMS Parser)

## SOLID Principles

### Single Responsibility Principle (SRP)

- Each use case handles one business operation
- ViewModels manage state for specific screens
- Repositories handle data access for specific entities

### Open/Closed Principle (OCP)

- Repository interfaces allow different implementations
- Use cases are open for extension through composition

### Liskov Substitution Principle (LSP)

- Repository implementations can be swapped
- Mock implementations for testing

### Interface Segregation Principle (ISP)

- Separate repository interfaces for each entity type
- Small, focused use cases

### Dependency Inversion Principle (DIP)

- High-level modules depend on abstractions (interfaces)
- Dependency injection via get_it and Riverpod

## MVVM Pattern

### Model

- Domain entities (Account, Transaction, Transfer)
- Immutable data classes

### View

- Flutter widgets and screens
- Purely declarative (no business logic)

### ViewModel

- State management with Riverpod
- Coordinates use cases
- Transforms data for UI consumption
- Handles user actions

## State Management (Riverpod)

```dart
// Provider hierarchy
Provider (Singleton dependencies)
  ↓
StateNotifierProvider (ViewModels)
  ↓
ConsumerWidget/ConsumerStatefulWidget (UI)
```

## Data Flow

### Read Data Flow

```
User Action → ViewModel → Use Case → Repository → Database → Entity
    ↑                                                            ↓
    └────────────────── State Update ←──────────────────────────┘
```

### Write Data Flow

```
User Input → ViewModel → Use Case → Repository → Database
                  ↓
          Update UI State
```

## Dependency Injection

Using `get_it` and Riverpod providers:

1. **Database & Core Services**: Singleton providers
2. **Repositories**: Scoped providers (depend on database)
3. **Use Cases**: Scoped providers (depend on repositories)
4. **ViewModels**: StateNotifier providers (depend on use cases)

## Error Handling

Using `dartz` Either type:

```dart
Future<Either<Failure, Success>> operation() {
  // Left(Failure) for errors
  // Right(Success) for success
}
```

Benefits:

- Type-safe error handling
- Explicit error types
- Functional programming approach

## Testing Strategy

1. **Unit Tests**: Use cases, ViewModels, utilities
2. **Widget Tests**: UI components
3. **Integration Tests**: Database operations, SMS parsing

## File Structure

```
lib/
├── core/
│   ├── constants/
│   ├── error/
│   ├── localization/
│   ├── theme/
│   ├── usecases/
│   └── utils/
├── data/
│   ├── datasources/
│   │   └── local/
│   ├── models/
│   ├── repositories/
│   └── services/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── providers/
│   ├── screens/
│   ├── viewmodels/
│   └── widgets/
└── main.dart
```

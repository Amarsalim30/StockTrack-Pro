# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Flutter Clean Architecture Stock Management System** named "StockTrack-Pro" that follows Domain-Driven Design (DDD) principles. The application manages inventory, purchase orders, suppliers, stock takes, and reporting for business stock management.

## Architecture

The project follows **Clean Architecture** with clear separation of concerns:

### Layer Structure
- **Domain Layer** (`lib/domain/`): Pure business logic, entities, repositories (interfaces), and use cases
- **Data Layer** (`lib/data/`): Data sources (remote/local), models, mappers, and repository implementations
- **Presentation Layer** (`lib/presentation/`): UI components, view models, and state management

### Key Architectural Patterns
- **Repository Pattern**: Abstract data access through domain repositories
- **Mapper Pattern**: Convert between data models and domain entities using dedicated mappers
- **Use Case Pattern**: Encapsulate business logic in single-responsibility use cases
- **State Management**: Riverpod providers for dependency injection and state management

### Domain Structure
Main business domains include:
- **Auth**: User authentication and authorization
- **Catalog**: Products, categories, suppliers, BOMs
- **Stock**: Inventory management, adjustments, stock takes
- **Orders**: Purchase orders, returns, and items
- **Sales**: Sales orders, customers, returns
- **Reporting**: Stock reports, expiry reports, movement reports
- **Production**: Manufacturing orders and scrap records
- **Settings**: Application configuration and feature toggles

## Development Commands

### Essential Commands
```bash
# Install dependencies
flutter pub get

# Run code generation (for Freezed, JSON serialization, etc.)
flutter packages pub run build_runner build

# Run with clean generation (when models change)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run

# Run tests
flutter test

# Build for release
flutter build apk --release    # Android
flutter build ios --release    # iOS

# Analyze code
flutter analyze

# Format code
dart format lib/ test/
```

### Code Generation
This project uses code generation extensively:
- **Freezed**: For immutable data classes and union types
- **JSON Annotation**: For JSON serialization
- **Injectable**: For dependency injection
- Always run `build_runner` after modifying models or adding new dependencies

## Key Dependencies

### State Management & Architecture
- **flutter_riverpod**: Primary state management solution
- **get_it**: Service locator for dependency injection
- **injectable**: Code generation for dependency injection

### Network & Data
- **dio**: HTTP client
- **retrofit**: Type-safe API client generation
- **hive_flutter**: Local database/caching
- **firebase_core/firestore/auth**: Backend services

### UI & Navigation
- **go_router**: Declarative routing
- **flutter_lucide**: Icon library
- **cached_network_image**: Image caching

### Utilities
- **dartz**: Functional programming (Either, Option types)
- **freezed_annotation**: Immutable classes
- **mobile_scanner**: Barcode scanning

## Project Structure Conventions

### File Naming
- Use snake_case for file names
- Suffix view models with `_view_model.dart`
- Suffix states with `_state.dart`
- Suffix pages with `_page.dart`

### Model Organization
- **Entities**: Pure domain objects in `lib/domain/entities/`
- **Models**: Data transfer objects in `lib/data/models/`
- **Mappers**: Conversion logic in `lib/data/mappers/`

### Feature Organization
Each feature module contains:
```
lib/presentation/feature_name/
├── feature_page.dart          # Main UI
├── feature_view_model.dart    # Business logic
├── feature_state.dart         # State definitions
└── widgets/                   # Feature-specific widgets
```

## Development Guidelines

### State Management
- Use Riverpod providers for all state management
- Keep view models focused on presentation logic
- Delegate business logic to use cases
- Use `Either<Failure, Success>` pattern for error handling

### Error Handling
- Define failures in `lib/core/error/failures.dart`
- Use functional error handling with `dartz` Either type
- Create specific failure types for different error scenarios

### Testing
- Write unit tests for use cases and view models
- Use mock repositories for testing business logic
- Test error scenarios and edge cases

### Code Generation Commands
When adding new models or modifying existing ones:
1. Add necessary annotations (`@freezed`, `@JsonSerializable`)
2. Run: `flutter packages pub run build_runner build --delete-conflicting-outputs`
3. Commit generated files alongside source changes

### Firebase Integration
The app integrates with Firebase for:
- Authentication (`firebase_auth`)
- Data storage (`cloud_firestore`)
- File storage (`firebase_storage`)

Ensure Firebase configuration is properly set up before running the application.
# Firebase Test Data Sources

This directory contains Firebase-based data source implementations for testing purposes.

## Structure

- `auth/` - Firebase Authentication test implementations
- `firestore/` - Firestore database test implementations
- `storage/` - Firebase Storage test implementations
- `messaging/` - Firebase Cloud Messaging test implementations

## Usage

These test data sources are designed to work with Firebase Test SDK and can be used for:

- Unit testing
- Integration testing
- Local development with Firebase Emulator
- Mock data scenarios

## Setup

1. Configure Firebase Test SDK in your test environment
2. Initialize Firebase Emulator if needed
3. Import the appropriate test data source classes
4. Use dependency injection to replace production data sources with test implementations

## Example

```dart
// Example usage in tests
final testAuthDataSource = FirebaseAuthTestDataSource();
final testFirestoreDataSource = FirestoreTestDataSource();
```
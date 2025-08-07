# Project Architecture

## Project Structure

The `lib/` directory contains application features organized by domain.
Providers and services expose logic for state management and platform APIs.

## Authentication Flow

Users sign in with email and password through Firebase Auth. The `AuthService`
wraps the Firebase APIs and is exposed via Riverpod providers.

## Calendar Integration

Bookings are stored in Firestore and can be synchronized with external calendar
services using `CalendarService`.

## Testing Strategy

Unit and widget tests live in the `test/` directory. Firebase services are
mocked and a lightweight `FakeFirebaseFirestore` is provided for data tests.

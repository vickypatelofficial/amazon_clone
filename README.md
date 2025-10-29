# Amazon Clone - Flutter (Provider + Firestore)

This is a starter project scaffold for an Amazon-like e-commerce app built with Flutter, Provider for state management, and Firestore as the backend database.
Configuration in this zip is set for Firestore and Email/Password authentication (no Google Sign-In). Targets Android, iOS and Web (single codebase).

## How to run

1. Install Flutter SDK and ensure `flutter` is on PATH.
2. Extract this project.
3. Run `flutter pub get` in the project root.
4. Configure Firebase:
   - Create a Firebase project at https://console.firebase.google.com/
   - Add Android, iOS and Web apps and follow instructions.
   - Download `google-services.json` for Android and place in `android/app/`.
   - Download `GoogleService-Info.plist` for iOS and add to Xcode Runner target.
   - For web, add your config to `web/index.html` or use `flutterfire configure`.
   - Enable Email/Password authentication in Firebase Console.
   - Create Firestore collections: `products`, `users`, `carts` (optional).
5. Run:
   - `flutter run -d chrome` (web)
   - or `flutter run` (device/emulator)

## Project structure (lightweight starter)
- lib/
  - main.dart
  - app.dart
  - core/constants.dart
  - models/product_model.dart
  - services/auth_service.dart
  - services/product_service.dart
  - providers/{auth,product,cart}_provider.dart
  - screens/{auth,home,product,cart,categories,profile}
  - widgets/product_card.dart
  - utils/utils.dart

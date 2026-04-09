# Bloop Flutter Assessment

## Flutter Version
**Flutter 3.38.5 stable • Dart 3.10.4** 

## How to Run
1. Ensure Flutter SDK is installed and `flutter doctor` passes.
2. Run `flutter pub get`
3. Generate Freezed & JSON files: `dart run build_runner build --delete-conflicting-outputs`
4. Run on simulator or real device: `flutter run`

## Mocked/Simplified Parts
- **Firestore Fetch:** Mocked with `mockFetchCollections()` in `collection_provider.dart` and `mockFetchSection()` in `section_provider.dart` to spend that step up time on UI and architecture
- **Task 2:** most of the code is smiplified, focuses on bug fixing.

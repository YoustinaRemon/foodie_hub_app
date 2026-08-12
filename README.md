# FoodieHub

A professional, feature-rich recipe discovery and management application built with Flutter and Firebase. FoodieHub allows users to search for thousands of recipes using TheMealDB API, curate their own favorites, and even create and store custom recipes locally. 

## Features

- **Onboarding:** Smooth introduction to the app.
- **Authentication:** Secure Email/Password login and Google Sign-In via Firebase Auth.
- **Recipe Discovery:** Powered by TheMealDB to browse, search, and filter recipes by category.
- **Recipe of the Day:** Deterministic daily recipe caching using SharedPreferences.
- **Favorites (Firestore):** Instantly save and sync favorite API recipes to the cloud with optimistic UI updates.
- **Cookbook & Custom Recipes:** Create your own recipes with dynamic ingredient and instruction arrays, stored securely in your private Firestore collection.
- **Recipe Details:** Beautiful, unified detail view that seamlessly handles both API recipes (dynamically fetching full instructions if missing) and custom recipes, including YouTube launcher integration.
- **Push Notifications:** Firebase Cloud Messaging (FCM) integration handling foreground, background, and terminated states to deep-link directly to recipes.
- **Profile Page:** Real-time favorite recipe count and authenticated user information display.
- **Robust State Management:** Comprehensive loading, empty, and error boundaries protecting every async operation.

## Tech Stack

- **Framework:** Flutter (Dart)
- **Backend & Auth:** Firebase Authentication, Cloud Firestore, Firebase Cloud Messaging (FCM)
- **State Management:** Provider (`MultiProvider` architecture)
- **Local Storage:** SharedPreferences (for caching and onboarding state)
- **API:** TheMealDB via HTTP
- **UI/UX Packages:** 
  - `flutter_form_builder` / `form_builder_validators` (Robust form handling)
  - `cached_network_image` (Image optimization)
  - `image_picker` (Local ephemeral image selection)
  - `url_launcher` (YouTube deep-linking)

## Architecture

FoodieHub follows a strict feature-based architecture to ensure maintainability and separation of concerns.

```text
lib/
├── core/         # Shared widgets, theme, constants, and global services
├── features/     # Feature modules (Auth, Home, Discover, Cookbook, Profile, etc.)
│   ├── auth/     # Login, Register, Google Sign-in providers/screens
│   ├── cookbook/ # Custom recipes CRUD, Favorites management
│   ├── recipes/  # Unified recipe models and detail screens
│   └── ...
├── models/       # Shared data models (e.g., MealModel)
├── services/     # API services and exception handling
└── main.dart     # Entry point and MultiProvider setup
```

## Firebase Setup

To run this project yourself, you must configure a Firebase project:

1. **Create a Firebase Project** in the Firebase Console.
2. **Enable Authentication:** Turn on Email/Password and Google Sign-In.
3. **Enable Firestore:** Deploy the following rules to secure user data:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId}/favorites/{mealId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       match /users/{userId}/customRecipes/{recipeId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```
4. **Register Apps:** Add Android/iOS apps in the console and place your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the respective directories.

## TheMealDB API

All global recipes are fetched from the public [TheMealDB API](https://www.themealdb.com/api.php). FoodieHub supports searching by name, filtering by category, and fetching full recipe details dynamically on demand to optimize bandwidth.

## State Management

The app uses `Provider` for state management, specifically leveraging `ChangeNotifierProvider` for isolated feature states:
- `AuthProvider`: Manages current user session.
- `RecipeProvider`: Handles global meal API fetching, search, and Recipe of the Day caching.
- `FavoriteProvider`: Optimistically syncs favorites to Firestore.
- `CustomRecipeProvider`: Manages the user's private cookbook CRUD operations.
- `RecipeDetailsProvider`: Hydrates partial API models into full detail views automatically.

## Notifications

FoodieHub is configured to receive FCM Push Notifications.
- The app handles notifications gracefully across all app states (Terminated, Background, Foreground).
- Expects a data payload schema like: `{"type": "recipe_of_the_day", "recipeId": "52772"}`.
- Tapping the notification uses a global `navigatorKey` to instantly route the user to the `RecipeDetailsScreen` for that recipe.
- *Note:* Sending notifications requires the Firebase Console or a secure backend Admin SDK (not included in this client app).

## Known Limitations

- **Custom Recipe Images:** Because Firebase Storage is intentionally disabled in this project version, images attached to Custom Recipes use ephemeral session-local `File` paths. They will not persist across app restarts. 

## Running the Project

```bash
# Fetch dependencies
flutter pub get

# Run code generation (if modifying generated assets)
dart run build_runner build --delete-conflicting-outputs

# Verify code quality
flutter analyze

# Run the app
flutter run
```

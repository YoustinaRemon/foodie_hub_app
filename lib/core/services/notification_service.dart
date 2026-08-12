import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:foodie_hup/core/utils/navigator_key.dart';
import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/features/recipes/ui/recipe_details_screen.dart';
import 'dart:developer';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Required by Firebase Messaging to handle background messages properly.
  // The Firebase App is already initialized before this runs.
  log('Handling a background message: ${message.messageId}');
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // 1. Request Permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted FCM permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      log('User granted provisional FCM permission');
    } else {
      log('User declined or has not accepted FCM permission');
    }

    // 2. Fetch Token
    try {
      String? token = await _messaging.getToken();
      log('FCM Token: $token');
    } catch (e) {
      log('Failed to fetch FCM token: $e');
    }

    // 3. Listen to Token Refresh
    _messaging.onTokenRefresh.listen((newToken) {
      log('FCM Token Refreshed: $newToken');
    }).onError((err) {
      log('Error refreshing FCM token: $err');
    });

    // 4. Handle Background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 5. Handle Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Received foreground message: ${message.messageId}');
      if (message.notification != null) {
        log('Notification title: ${message.notification?.title}');
        log('Notification body: ${message.notification?.body}');
      }
      _handleMessagePayload(message.data, isForeground: true);
    });

    // 6. Handle Background App Tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Opened app from background tap: ${message.messageId}');
      _handleMessagePayload(message.data);
    });

    // 7. Handle Terminated App Tap (Initial Message)
    try {
      RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        log('App opened from terminated state via tap: ${initialMessage.messageId}');
        
        // Delay processing slightly to ensure the Navigator is mounted
        Future.delayed(const Duration(milliseconds: 500), () {
          _handleMessagePayload(initialMessage.data);
        });
      }
    } catch (e) {
      log('Error getting initial FCM message: $e');
    }
  }

  void _handleMessagePayload(Map<String, dynamic> data, {bool isForeground = false}) {
    if (data.isEmpty) return;

    final type = data['type'];
    final recipeId = data['recipeId'];

    if (type == 'recipe_of_the_day' && recipeId != null) {
      // In foreground, we might not want to instantly yank the user to the details screen,
      // but for this phase's simplicity, if required we navigate. If you prefer not to disrupt
      // the user during active use, we can return if isForeground == true.
      if (isForeground) {
        log('Recipe of the Day received in foreground. Silently ignoring auto-navigation.');
        return;
      }

      _navigateToRecipeDetails(recipeId);
    }
  }

  void _navigateToRecipeDetails(String recipeId) {
    if (navigatorKey.currentState != null) {
      // Construct a partial MealModel. RecipeDetailsProvider will seamlessly detect 
      // the missing fields (like instructions) and load the full API details natively!
      final partialMeal = MealModel(
        idMeal: recipeId,
        strMeal: 'Recipe of the Day', 
        ingredients: const [],
      );
      
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => RecipeDetailsScreen(sourceModel: partialMeal),
        ),
      );
    } else {
      log('Navigator state is not ready yet to route to recipe details.');
    }
  }
}

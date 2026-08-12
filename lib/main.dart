import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodie_hup/foodie_hup.dart';
import 'package:foodie_hup/features/auth/providers/auth_provider.dart';
import 'package:foodie_hup/features/recipes/providers/recipe_provider.dart';
import 'package:foodie_hup/features/discover/providers/discover_provider.dart';
import 'package:foodie_hup/features/cookbook/providers/favorite_provider.dart';
import 'package:foodie_hup/features/cookbook/providers/custom_recipe_provider.dart';
import 'package:foodie_hup/features/recipes/providers/recipe_details_provider.dart';
import 'package:foodie_hup/core/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final notificationService = NotificationService();
  await notificationService.init();

  final prefs = await SharedPreferences.getInstance();
  final bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

  FlutterNativeSplash.remove();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        ChangeNotifierProvider(create: (_) => DiscoverProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => CustomRecipeProvider()),
        ChangeNotifierProvider(create: (_) => RecipeDetailsProvider()),
      ],
      child: FoodieHup(onboardingCompleted: onboardingCompleted),
    ),
  );
}

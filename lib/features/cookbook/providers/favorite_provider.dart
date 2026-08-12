import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/features/cookbook/services/favorite_service.dart';
import 'package:foodie_hup/services/api_exceptions.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteService _favoriteService = FavoriteService();

  List<MealModel> _favorites = [];
  List<MealModel> get favorites => _favorites;

  Set<String> _favoriteIds = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  FavoriteProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        loadFavorites();
      } else {
        _clearState();
      }
    });
  }

  Future<void> loadFavorites() async {
    final uid = _uid;
    if (uid == null) {
      _clearState();
      return;
    }

    _setLoading(true);
    try {
      _favorites = await _favoriteService.getFavorites(uid);
      _favoriteIds = _favorites.map((m) => m.idMeal).toSet();
      _errorMessage = null;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred while loading favorites.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleFavorite(MealModel meal) async {
    final uid = _uid;
    if (uid == null) return; // User not authenticated

    final isFav = isFavorite(meal.idMeal);
    
    // Optimistic update
    if (isFav) {
      _favoriteIds.remove(meal.idMeal);
      _favorites.removeWhere((m) => m.idMeal == meal.idMeal);
    } else {
      _favoriteIds.add(meal.idMeal);
      _favorites.insert(0, meal);
    }
    notifyListeners();

    try {
      if (isFav) {
        await _favoriteService.removeFavorite(uid, meal.idMeal);
      } else {
        await _favoriteService.addFavorite(uid, meal);
      }
    } catch (e) {
      // Revert optimistic update on failure
      if (isFav) {
        _favoriteIds.add(meal.idMeal);
        _favorites.insert(0, meal); // Might lose exact order, but safe fallback
      } else {
        _favoriteIds.remove(meal.idMeal);
        _favorites.removeWhere((m) => m.idMeal == meal.idMeal);
      }
      _errorMessage = 'Failed to update favorites. Please try again.';
      notifyListeners();
    }
  }

  bool isFavorite(String mealId) {
    return _favoriteIds.contains(mealId);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearState() {
    _favorites = [];
    _favoriteIds = {};
    _errorMessage = null;
    notifyListeners();
  }
  
  // Call this when the user logs out
  void clearFavorites() {
    _clearState();
  }
}

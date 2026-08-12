import 'package:flutter/material.dart';
import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/features/cookbook/models/custom_recipe_model.dart';
import 'package:foodie_hup/features/recipes/models/unified_recipe_model.dart';
import 'package:foodie_hup/services/recipe_api_service.dart';

class RecipeDetailsProvider extends ChangeNotifier {
  final RecipeApiService _apiService = RecipeApiService();

  UnifiedRecipeModel? _recipe;
  UnifiedRecipeModel? get recipe => _recipe;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void loadRecipe(dynamic sourceModel) async {
    _isLoading = true;
    _errorMessage = null;
    _recipe = null;
    
    // Defer state update so it doesn't clash with build phase if called from initState
    Future.microtask(() {
      notifyListeners();
    });

    if (sourceModel is CustomRecipeModel) {
      _recipe = UnifiedRecipeModel.fromCustomRecipe(sourceModel);
      _isLoading = false;
      notifyListeners();
    } else if (sourceModel is MealModel) {
      // Check if we need to fetch full details
      if (sourceModel.strInstructions == null || sourceModel.strInstructions!.isEmpty) {
        try {
          final fullMeal = await _apiService.getMealDetails(sourceModel.idMeal);
          if (fullMeal != null) {
            _recipe = UnifiedRecipeModel.fromMealModel(fullMeal);
          } else {
            _errorMessage = "Recipe details not found.";
          }
        } catch (e) {
          _errorMessage = "Failed to load recipe details. Please check your connection.";
        }
      } else {
        // Already full
        _recipe = UnifiedRecipeModel.fromMealModel(sourceModel);
      }
      _isLoading = false;
      notifyListeners();
    } else {
      _errorMessage = "Invalid recipe format.";
      _isLoading = false;
      notifyListeners();
    }
  }
}

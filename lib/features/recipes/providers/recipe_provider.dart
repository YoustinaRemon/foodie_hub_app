import 'package:flutter/material.dart';
import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/services/recipe_api_service.dart';
import 'package:foodie_hup/services/api_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeProvider extends ChangeNotifier {
  final RecipeApiService _apiService = RecipeApiService();

  List<MealModel> _meals = [];
  List<MealModel> get meals => _meals;

  List<String> _categories = [];
  List<String> get categories => _categories;

  String _selectedCategory = 'All Recipes';
  String get selectedCategory => _selectedCategory;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  MealModel? _recipeOfTheDay;
  MealModel? get recipeOfTheDay => _recipeOfTheDay;

  bool _isRecipeOfDayLoading = false;
  bool get isRecipeOfDayLoading => _isRecipeOfDayLoading;

  String? _recipeOfDayError;
  String? get recipeOfDayError => _recipeOfDayError;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  RecipeProvider() {
    _init();
  }

  Future<void> _init() async {
    loadRecipeOfTheDay();
    await fetchCategories();
    await fetchPopularMeals();
  }

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await _apiService.getCategories();
      _categories = ['All Recipes', ...fetchedCategories];
      notifyListeners();
    } catch (e) {
      // Non-fatal, just leave categories empty
    }
  }

  Future<void> loadRecipeOfTheDay() async {
    _isRecipeOfDayLoading = true;
    _recipeOfDayError = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String().substring(0, 10);
      
      final cachedDate = prefs.getString('recipeOfDayDate');
      final cachedId = prefs.getString('recipeOfDayId');
      
      if (cachedDate == today && cachedId != null) {
        final meal = await _apiService.getMealDetails(cachedId);
        if (meal != null) {
          _recipeOfTheDay = meal;
          _isRecipeOfDayLoading = false;
          notifyListeners();
          return;
        }
      }
      
      // Fallback: fetch a deterministic recipe
      final popularMeals = await _apiService.getPopularMeals();
      if (popularMeals.isNotEmpty) {
        final now = DateTime.now();
        final dateKey = now.year * 10000 + now.month * 100 + now.day;
        final index = dateKey % popularMeals.length;
        _recipeOfTheDay = popularMeals[index];
        
        await prefs.setString('recipeOfDayDate', today);
        await prefs.setString('recipeOfDayId', _recipeOfTheDay!.idMeal);
      } else {
        _recipeOfDayError = "Unable to load today's recipe. Please try again.";
      }
    } catch (e) {
      _recipeOfDayError = "Unable to load today's recipe. Please try again.";
    } finally {
      _isRecipeOfDayLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectCategory(String category) async {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    
    if (category == 'All Recipes') {
      await fetchPopularMeals();
    } else {
      _setLoadingState();
      try {
        _meals = await _apiService.getMealsByCategory(category);
        _clearError();
      } on ApiException catch (e) {
        _setError(e.message);
      } catch (e) {
        _setError('An unexpected error occurred while fetching category meals.');
      }
    }
  }

  Future<void> fetchPopularMeals() async {
    _selectedCategory = 'All Recipes';
    _isSearching = false;
    _setLoadingState();
    try {
      _meals = await _apiService.getPopularMeals();
      _clearError();
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred while fetching popular meals.');
    }
  }

  Future<void> searchMeals(String query) async {
    if (query.trim().isEmpty) {
      _isSearching = false;
      await fetchPopularMeals();
      return;
    }
    _isSearching = true;
    _setLoadingState();
    try {
      _meals = await _apiService.searchMeals(query);
      _clearError();
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred while searching for meals.');
    }
  }

  void _setLoadingState() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  void _clearError() {
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _isLoading = false;
    _errorMessage = message;
    notifyListeners();
  }
}

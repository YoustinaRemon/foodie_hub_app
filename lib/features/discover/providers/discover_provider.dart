import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/services/recipe_api_service.dart';
import 'package:foodie_hup/services/api_exceptions.dart';

class DiscoverProvider extends ChangeNotifier {
  final RecipeApiService _apiService = RecipeApiService();

  List<MealModel> _meals = [];
  List<MealModel> get meals => _meals;

  List<String> _categories = [];
  List<String> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  bool _isVegetarian = false;
  bool get isVegetarian => _isVegetarian;

  DiscoverProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _isVegetarian = prefs.getBool('selectedDietaryFilter_vegetarian') ?? false;
    await fetchCategories();
    await _fetchData();
  }

  Future<void> setVegetarianFilter(bool value) async {
    if (_isVegetarian == value) return;
    _isVegetarian = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('selectedDietaryFilter_vegetarian', value);
    notifyListeners();
    await _fetchData();
  }

  Future<void> selectCategory(String category) async {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _searchQuery = ''; // Clear search when selecting category
    notifyListeners();
    await _fetchData();
  }

  Future<void> searchMeals(String query) async {
    _searchQuery = query.trim();
    _selectedCategory = 'All'; // Clear category when searching
    notifyListeners();
    await _fetchData();
  }

  Future<void> retry() async {
    await _fetchData();
  }

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await _apiService.getCategories();
      _categories = ['All', ...fetchedCategories];
      notifyListeners();
    } catch (e) {
      // Non-fatal, just leave categories empty
    }
  }

  Future<void> _fetchData() async {
    _setLoading(true);
    try {
      List<MealModel> results = [];

      if (_searchQuery.isNotEmpty) {
        results = await _apiService.searchMeals(_searchQuery);
        // TheMealDB search returns full details including strCategory.
        // We can confidently local-filter for Vegetarian.
        if (_isVegetarian) {
          results = results.where((meal) => meal.strCategory == 'Vegetarian').toList();
        }
      } else if (_selectedCategory != 'All') {
        // Category selected
        if (_isVegetarian && _selectedCategory != 'Vegetarian') {
          // It's impossible for a meal to be both "Beef" and "Vegetarian" 
          // because TheMealDB only assigns one category per meal.
          results = [];
        } else {
          results = await _apiService.getMealsByCategory(_selectedCategory);
        }
      } else {
        // No search, No Category selected ("All")
        if (_isVegetarian) {
          results = await _apiService.getMealsByCategory('Vegetarian');
        } else {
          // Default state: fetch a general list of meals
          results = await _apiService.searchMeals('');
        }
      }

      _meals = results;
      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred while fetching recipes.');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    if (value) _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _isLoading = false;
    _errorMessage = message;
    notifyListeners();
  }
}

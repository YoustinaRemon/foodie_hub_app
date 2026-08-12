import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:foodie_hup/features/cookbook/models/custom_recipe_model.dart';
import 'package:foodie_hup/features/cookbook/services/custom_recipe_service.dart';

class CustomRecipeProvider extends ChangeNotifier {
  final CustomRecipeService _service = CustomRecipeService();
  final ImagePicker _picker = ImagePicker();

  List<CustomRecipeModel> _myRecipes = [];
  List<CustomRecipeModel> get myRecipes => _myRecipes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  CustomRecipeProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        loadMyRecipes();
      } else {
        _myRecipes = [];
        notifyListeners();
      }
    });
  }

  Future<void> loadMyRecipes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _myRecipes = await _service.getUserRecipes(user.uid);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Unable to pick image. Please try again.";
      notifyListeners();
    }
  }

  void clearSelectedImage() {
    _selectedImage = null;
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<bool> createRecipe({
    required String title,
    required String description,
    required String category,
    required int preparationTime,
    required int servings,
    required List<CustomIngredient> ingredients,
    required List<String> instructions,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _errorMessage = "Please sign in before creating a recipe.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final recipeId = const Uuid().v4();
      final recipe = CustomRecipeModel(
        id: recipeId,
        userId: user.uid,
        title: title,
        description: description,
        category: category,
        preparationTime: preparationTime,
        servings: servings,
        ingredients: ingredients,
        instructions: instructions,
        // imageUrl is intentionally not populated for Firestore
      );

      await _service.createRecipe(user.uid, recipe);
      
      _myRecipes.insert(0, recipe);
      _successMessage = "Recipe created successfully!";
      _selectedImage = null; // Reset local session image
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateRecipe({
    required String recipeId,
    required String title,
    required String description,
    required String category,
    required int preparationTime,
    required int servings,
    required List<CustomIngredient> ingredients,
    required List<String> instructions,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _errorMessage = "Please sign in before updating a recipe.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final recipe = CustomRecipeModel(
        id: recipeId,
        userId: user.uid,
        title: title,
        description: description,
        category: category,
        preparationTime: preparationTime,
        servings: servings,
        ingredients: ingredients,
        instructions: instructions,
      );

      await _service.updateRecipe(user.uid, recipe);
      
      final index = _myRecipes.indexWhere((r) => r.id == recipeId);
      if (index != -1) {
        _myRecipes[index] = recipe;
      }
      
      _successMessage = "Recipe updated successfully!";
      _selectedImage = null; // Reset local session image
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteRecipe(String recipeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deleteRecipe(user.uid, recipeId);
      _myRecipes.removeWhere((r) => r.id == recipeId);
      _successMessage = "Recipe deleted successfully.";
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

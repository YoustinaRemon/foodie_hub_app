import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/features/cookbook/models/custom_recipe_model.dart';

class UnifiedRecipeModel {
  final String id;
  final String title;
  final String? imageUrl;
  final String? category;
  final String? area;
  final String? description;
  final int? preparationTime;
  final int? servings;
  final List<CustomIngredient> ingredients;
  final List<String> instructions;
  final String? youtubeUrl;
  final bool isCustom;
  final dynamic sourceModel;

  UnifiedRecipeModel({
    required this.id,
    required this.title,
    this.imageUrl,
    this.category,
    this.area,
    this.description,
    this.preparationTime,
    this.servings,
    required this.ingredients,
    required this.instructions,
    this.youtubeUrl,
    required this.isCustom,
    required this.sourceModel,
  });

  factory UnifiedRecipeModel.fromMealModel(MealModel meal) {
    final List<CustomIngredient> parsedIngredients = meal.ingredients.map(
      (ing) => CustomIngredient(name: ing.name, measure: ing.measure)
    ).toList();

    // Parse instructions into steps if possible, else just single step
    List<String> parsedInstructions = [];
    if (meal.strInstructions != null && meal.strInstructions!.isNotEmpty) {
      // Split by newlines, clean up, and filter empty
      parsedInstructions = meal.strInstructions!
          .split(RegExp(r'\r\n|\n|\r'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    return UnifiedRecipeModel(
      id: meal.idMeal,
      title: meal.strMeal,
      imageUrl: meal.strMealThumb,
      category: meal.strCategory,
      area: meal.strArea,
      description: null, // TheMealDB doesn't have a distinct description field
      preparationTime: null,
      servings: null,
      ingredients: parsedIngredients,
      instructions: parsedInstructions,
      youtubeUrl: meal.strYoutube,
      isCustom: false,
      sourceModel: meal,
    );
  }

  factory UnifiedRecipeModel.fromCustomRecipe(CustomRecipeModel customRecipe) {
    return UnifiedRecipeModel(
      id: customRecipe.id,
      title: customRecipe.title,
      imageUrl: customRecipe.imageUrl,
      category: customRecipe.category,
      area: null,
      description: customRecipe.description,
      preparationTime: customRecipe.preparationTime,
      servings: customRecipe.servings,
      ingredients: customRecipe.ingredients,
      instructions: customRecipe.instructions,
      youtubeUrl: null,
      isCustom: true,
      sourceModel: customRecipe,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/features/recipes/widgets/recipe_card.dart';

class CookbookRecipeGrid extends StatelessWidget {
  final List<MealModel> meals;

  const CookbookRecipeGrid({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 0.75, // Matches standard RecipeCard proportions
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return RecipeCard(meal: meals[index]);
        },
        childCount: meals.length,
      ),
    );
  }
}

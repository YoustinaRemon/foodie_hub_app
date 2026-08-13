import 'package:flutter/material.dart';
import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/features/recipes/widgets/recipe_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CookbookRecipeGrid extends StatelessWidget {
  final List<MealModel> meals;

  const CookbookRecipeGrid({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.0.h,
        crossAxisSpacing: 12.0.w,
        childAspectRatio: 0.78, // Matches standard RecipeCard proportions
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

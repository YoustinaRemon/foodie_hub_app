import 'package:flutter/material.dart';
import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/features/home/widgets/popular_recipe_card.dart';

class PopularRecipesSection extends StatelessWidget {
  final List<MealModel> meals;

  const PopularRecipesSection({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return SizedBox.shrink();
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: meals.length,
      itemBuilder: (context, index) {
        return PopularRecipeCard(meal: meals[index]);
      },
    );
  }
}

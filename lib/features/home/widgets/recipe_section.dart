import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/features/recipes/providers/recipe_provider.dart';
import 'package:foodie_hup/features/recipes/widgets/recipe_card.dart';
import 'package:foodie_hup/core/widgets/empty_state_widget.dart';
import 'package:foodie_hup/core/widgets/error_state_widget.dart';
import 'package:foodie_hup/core/widgets/loading_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RecipeSection extends StatelessWidget {
  const RecipeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Expanded(child: LoadingWidget());
        }

        if (provider.errorMessage != null) {
          return Expanded(
            child: ErrorStateWidget(
              errorMessage: provider.errorMessage!,
              onRetry: () => provider.fetchPopularMeals(),
            ),
          );
        }

        if (provider.meals.isEmpty) {
          return Expanded(
            child: EmptyStateWidget(
              message: 'No meals found. Try searching for something else!',
            ),
          );
        }

        // Horizontal List View for recipes
        return SizedBox(
          height: 250.h, // Constrained height for horizontal scrolling
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.meals.length,
            itemBuilder: (context, index) {
              final meal = provider.meals[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.0.w),
                child: SizedBox(
                  width: 180.w, // Fixed width to ensure cards look good horizontally
                  child: RecipeCard(meal: meal),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

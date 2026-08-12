import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/features/discover/providers/discover_provider.dart';
import 'package:foodie_hup/features/recipes/widgets/recipe_card.dart';
import 'package:foodie_hup/core/widgets/empty_state_widget.dart';
import 'package:foodie_hup/core/widgets/error_state_widget.dart';
import 'package:foodie_hup/core/widgets/loading_widget.dart';

class RecipeGrid extends StatelessWidget {
  const RecipeGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscoverProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: LoadingWidget());
        }

        if (provider.errorMessage != null) {
          return Center(
            child: ErrorStateWidget(
              errorMessage: provider.errorMessage!,
              onRetry: () => provider.retry(),
            ),
          );
        }

        if (provider.meals.isEmpty) {
          return const Center(
            child: EmptyStateWidget(
              message: 'No recipes found. Try adjusting your filters or search!',
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: provider.meals.length,
          itemBuilder: (context, index) {
            final meal = provider.meals[index];
            return RecipeCard(meal: meal);
          },
        );
      },
    );
  }
}

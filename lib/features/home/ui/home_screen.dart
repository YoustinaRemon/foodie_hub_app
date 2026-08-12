import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/core/widgets/search_bar.dart';
import 'package:foodie_hup/core/widgets/loading_widget.dart';
import 'package:foodie_hup/core/widgets/empty_state_widget.dart';
import 'package:foodie_hup/core/widgets/error_state_widget.dart';
import 'package:foodie_hup/features/recipes/providers/recipe_provider.dart';
import 'package:foodie_hup/features/home/widgets/home_header.dart';
import 'package:foodie_hup/features/home/widgets/home_category_chips.dart';
import 'package:foodie_hup/features/home/widgets/section_header.dart';
import 'package:foodie_hup/features/home/widgets/recipe_of_day_card.dart';
import 'package:foodie_hup/features/home/widgets/popular_recipes_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),

              CustomSearchBar(
                text: "What are you craving today?",
                onFieldSubmitted: (query) {
                  context.read<RecipeProvider>().searchMeals(query);
                },
              ),
              const SizedBox(height: 24),

              const HomeCategoryChips(),

              Consumer<RecipeProvider>(
                builder: (context, provider, child) {
                  if (provider.isRecipeOfDayLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(child: LoadingWidget()),
                    );
                  }

                  if (provider.recipeOfDayError != null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(
                        child: ErrorStateWidget(
                          errorMessage: provider.recipeOfDayError!,
                          onRetry: () => provider.loadRecipeOfTheDay(),
                        ),
                      ),
                    );
                  }

                  if (provider.recipeOfTheDay == null) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(
                        child: EmptyStateWidget(
                          message: 'No recipe of the day available.',
                        ),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        title: "Recipe of the Day",
                        icon: Icons.star,
                      ),
                      RecipeOfDayCard(meal: provider.recipeOfTheDay!),
                    ],
                  );
                },
              ),

              Consumer<RecipeProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Center(child: LoadingWidget()),
                    );
                  }

                  if (provider.errorMessage != null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: ErrorStateWidget(
                          errorMessage: provider.errorMessage!,
                          onRetry: () => provider.fetchPopularMeals(),
                        ),
                      ),
                    );
                  }

                  if (provider.meals.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: EmptyStateWidget(
                          message: 'No recipes found.',
                        ),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: provider.isSearching ? "Search Results" : "Popular Right Now",
                        actionText: "See all",
                      ),
                      PopularRecipesSection(meals: provider.meals),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/core/widgets/search_bar.dart';
import 'package:foodie_hup/features/discover/providers/discover_provider.dart';
import 'package:foodie_hup/features/discover/widgets/category_filter.dart';
import 'package:foodie_hup/features/discover/widgets/dietary_filter.dart';
import 'package:foodie_hup/features/discover/widgets/recipe_grid.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                "Discover",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: AppColors.secondMainColor,
                      fontSize: 32,
                    ),
              ),
              const SizedBox(height: 16),
              
              // Custom Search Bar (submitting triggers provider search)
              CustomSearchBar(
                text: "Search for a specific recipe...",
                onFieldSubmitted: (query) {
                  context.read<DiscoverProvider>().searchMeals(query);
                },
              ),
              const SizedBox(height: 16),
              
              const DietaryFilter(),
              const SizedBox(height: 16),
              
              Text(
                "Categories",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.secondMainColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              
              const CategoryFilter(),
              const SizedBox(height: 16),
              
              const Expanded(
                child: RecipeGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/features/discover/providers/discover_provider.dart';
import 'package:foodie_hup/features/recipes/widgets/recipe_card.dart';
import 'package:foodie_hup/core/widgets/empty_state_widget.dart';
import 'package:foodie_hup/core/widgets/error_state_widget.dart';
import 'package:foodie_hup/core/widgets/loading_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RecipeGrid extends StatelessWidget {
  const RecipeGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscoverProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: LoadingWidget());
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
          return Center(
            child: EmptyStateWidget(
              message: 'No recipes found. Try adjusting your filters or search!',
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.only(top: 8.0.h, bottom: 24.0.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.78,
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

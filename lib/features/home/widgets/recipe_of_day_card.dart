import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/features/cookbook/widgets/favorite_button.dart';
import 'package:foodie_hup/features/recipes/ui/recipe_details_screen.dart';
import 'package:foodie_hup/core/widgets/loading_widget.dart';

class RecipeOfDayCard extends StatelessWidget {
  final MealModel meal;

  const RecipeOfDayCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailsScreen(sourceModel: meal),
          ),
        );
      },
      child: Container(
        height: 300,
        margin: const EdgeInsets.only(bottom: 32.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.borderColor.withValues(alpha: 0.3),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            if (meal.strMealThumb?.isNotEmpty == true)
              CachedNetworkImage(
                imageUrl: meal.strMealThumb ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: LoadingWidget(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 50),
              )
            else
              const Icon(Icons.restaurant, size: 50, color: AppColors.contentColor),

            // Gradient Overlay for Text Readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),

            // Content Overlay
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Featured Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xff9E7036), // Brown featured badge from design
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "FEATURED",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Recipe Title
                  Text(
                    meal.strMeal,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Serif',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Metadata (Time/Difficulty) - simulated with Area if necessary, 
                  // but avoiding fake data. The API provides category/area.
                  Row(
                    children: [
                      if (meal.strCategory != null && meal.strCategory!.isNotEmpty) ...[
                        const Icon(Icons.schedule, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          meal.strCategory!,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(width: 16),
                      ],
                      if (meal.strArea != null && meal.strArea!.isNotEmpty) ...[
                        const Icon(Icons.restaurant_menu, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          meal.strArea!,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: FavoriteButton(meal: meal, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

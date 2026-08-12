import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/features/cookbook/providers/favorite_provider.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';

class FavoriteButton extends StatelessWidget {
  final MealModel meal;
  final double size;
  final Color? color;

  const FavoriteButton({
    super.key,
    required this.meal,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, provider, child) {
        final isFavorite = provider.isFavorite(meal.idMeal);
        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? AppColors.secondMainColor : (color ?? AppColors.contentColor),
            size: size,
          ),
          onPressed: () async {
            await provider.toggleFavorite(meal);
            if (provider.errorMessage != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(provider.errorMessage!)),
              );
            }
          },
        );
      },
    );
  }
}

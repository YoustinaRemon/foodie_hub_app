import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';

class EmptyCookbook extends StatelessWidget {
  const EmptyCookbook({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 80,
            color: AppColors.borderColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            "Your Cookbook is Empty",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.secondMainColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            "Save recipes you love and find them here later.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.contentColor,
                ),
          ),
        ],
      ),
    );
  }
}

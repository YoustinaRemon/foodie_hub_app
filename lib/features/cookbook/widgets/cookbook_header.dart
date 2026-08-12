import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';

class CookbookHeader extends StatelessWidget {
  const CookbookHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cookbook",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.secondMainColor,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Serif',
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your personal collection of saved recipes.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.contentColor,
                ),
          ),
        ],
      ),
    );
  }
}

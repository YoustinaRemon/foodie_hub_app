import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/features/discover/providers/discover_provider.dart';

class DietaryFilter extends StatelessWidget {
  const DietaryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscoverProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            const Icon(Icons.eco, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              'Vegetarian Only',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.contentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Switch(
              value: provider.isVegetarian,
              activeTrackColor: AppColors.secondMainColor,
              activeThumbColor: AppColors.mainColor,
              onChanged: (value) {
                provider.setVegetarianFilter(value);
              },
            ),
          ],
        );
      },
    );
  }
}

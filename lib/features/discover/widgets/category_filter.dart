import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/features/discover/providers/discover_provider.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscoverProvider>(
      builder: (context, provider, child) {
        if (provider.categories.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              final category = provider.categories[index];
              final isSelected = provider.selectedCategory == category;
              // If vegetarian mode is on, we visually disable other categories.
              final isDisabled =
                  provider.isVegetarian &&
                  category != 'Vegetarian' &&
                  category != 'All';

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                  label: Text(
                    category,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.mainColor
                          : isDisabled
                          ? Colors.grey
                          : AppColors.contentColor,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.secondMainColor,
                  backgroundColor: AppColors.contentColor.withValues(
                    alpha: 0.1,
                  ),
                  showCheckmark: false,
                  onSelected: isDisabled
                      ? null
                      : (selected) {
                          provider.selectCategory(category);
                        },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

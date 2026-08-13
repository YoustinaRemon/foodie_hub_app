import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/features/recipes/providers/recipe_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCategoryChips extends StatelessWidget {
  const HomeCategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, provider, child) {
        if (provider.categories.isEmpty) return SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.only(bottom: 16.0.h),
          child: SizedBox(
            height: 32.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: provider.categories.length,
              itemBuilder: (context, index) {
                final category = provider.categories[index];
                final isSelected = provider.selectedCategory == category;

                return Padding(
                  padding: EdgeInsets.only(right: 8.0.w),
                  child: ChoiceChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isSelected
                            ? AppColors.mainColor
                            : AppColors.contentColor,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.secondMainColor, // FoodieHub green
                    backgroundColor: AppColors.shadowColor,
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      side: BorderSide.none,
                    ),
                    onSelected: (selected) {
                      provider.selectCategory(category);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

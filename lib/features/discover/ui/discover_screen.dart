import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/core/widgets/search_bar.dart';
import 'package:foodie_hup/features/discover/providers/discover_provider.dart';
import 'package:foodie_hup/features/discover/widgets/category_filter.dart';
import 'package:foodie_hup/features/discover/widgets/dietary_filter.dart';
import 'package:foodie_hup/features/discover/widgets/recipe_grid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Text(
                "Discover",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColors.secondMainColor,
                  fontSize: 26.sp,
                ),
              ),
              SizedBox(height: 12.h),

              // Custom Search Bar (submitting triggers provider search)
              CustomSearchBar(
                text: "Search for a specific recipe...",
                onFieldSubmitted: (query) {
                  context.read<DiscoverProvider>().searchMeals(query);
                },
              ),
              SizedBox(height: 12.h),

              const DietaryFilter(),
              SizedBox(height: 12.h),

              Text(
                "Categories",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColors.secondMainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 8.h),

              const CategoryFilter(),
              SizedBox(height: 12.h),

              Expanded(child: RecipeGrid()),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/features/cookbook/widgets/favorite_button.dart';
import 'package:foodie_hup/features/recipes/ui/recipe_details_screen.dart';
import 'package:foodie_hup/core/widgets/loading_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PopularRecipeCard extends StatelessWidget {
  final MealModel meal;

  const PopularRecipeCard({super.key, required this.meal});

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
        margin: EdgeInsets.only(bottom: 12.0.h),
        padding: EdgeInsets.all(10.0.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox(
                width: 85.w,
                height: 85.h,
                child: (meal.strMealThumb?.isNotEmpty == true)
                    ? CachedNetworkImage(
                        imageUrl: meal.strMealThumb ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.borderColor.withValues(alpha: 0.3),
                          child: Center(
                            child: LoadingWidget(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.borderColor.withValues(alpha: 0.3),
                          child: Icon(Icons.broken_image, color: AppColors.contentColor),
                        ),
                      )
                    : Container(
                        color: AppColors.borderColor.withValues(alpha: 0.3),
                        child: Icon(Icons.restaurant, color: AppColors.contentColor),
                      ),
              ),
            ),
            SizedBox(width: 12.w),
            
            // Right Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.strMeal,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.contentColor,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Serif',
                        ),
                  ),
                  SizedBox(height: 4.h),
                  
                  // Description / Subtitle
                  // Using category and area as a descriptive text since full description isn't available
                  Text(
                    "${meal.strArea ?? ''} ${meal.strCategory ?? ''} recipe",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.contentColor.withValues(alpha: 0.7),
                        ),
                  ),
                  SizedBox(height: 8.h),
                  
                  // Metadata Row
                  Row(
                    children: [
                      Icon(Icons.restaurant_menu, size: 14.sp, color: AppColors.contentColor),
                      SizedBox(width: 4.w),
                      Text(
                        meal.strCategory ?? 'Meal',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.contentColor,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const Spacer(),
                      FavoriteButton(meal: meal, size: 18.sp),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

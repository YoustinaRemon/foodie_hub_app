import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/features/cookbook/widgets/favorite_button.dart';
import 'package:foodie_hup/features/recipes/ui/recipe_details_screen.dart';
import 'package:foodie_hup/core/widgets/loading_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
        height: 240.h,
        margin: EdgeInsets.only(bottom: 24.0.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
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
                placeholder: (context, url) => Center(
                  child: LoadingWidget(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.broken_image, size: 50.sp),
              )
            else
              Icon(Icons.restaurant, size: 50.sp, color: AppColors.contentColor),

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
                  stops: [0.4, 1.0],
                ),
              ),
            ),

            // Content Overlay
            Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Featured Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xff9E7036), // Brown featured badge from design
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "FEATURED",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Recipe Title
                  Text(
                    meal.strMeal,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Serif',
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Metadata (Time/Difficulty) - simulated with Area if necessary, 
                  // but avoiding fake data. The API provides category/area.
                  Row(
                    children: [
                      if (meal.strCategory != null && meal.strCategory!.isNotEmpty) ...[
                        Icon(Icons.schedule, color: Colors.white70, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          meal.strCategory!,
                          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                        ),
                        SizedBox(width: 16.w),
                      ],
                      if (meal.strArea != null && meal.strArea!.isNotEmpty) ...[
                        Icon(Icons.restaurant_menu, color: Colors.white70, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          meal.strArea!,
                          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16.h,
              right: 16.w,
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

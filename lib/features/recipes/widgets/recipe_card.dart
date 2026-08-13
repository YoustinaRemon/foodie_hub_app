import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/features/cookbook/widgets/favorite_button.dart';
import 'package:foodie_hup/features/recipes/ui/recipe_details_screen.dart';
import 'package:foodie_hup/core/widgets/loading_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RecipeCard extends StatelessWidget {
  final MealModel meal;

  const RecipeCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: AppColors.mainColor,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailsScreen(sourceModel: meal),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  meal.strMealThumb != null
                      ? CachedNetworkImage(
                          imageUrl: meal.strMealThumb!,
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
                          child: Icon(Icons.fastfood, color: AppColors.contentColor),
                        ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: FavoriteButton(meal: meal),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.strMeal,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondMainColor,
                          fontSize: 15.sp,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  if (meal.strCategory != null)
                    Text(
                      meal.strCategory!,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.contentColor,
                            fontSize: 12.sp,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

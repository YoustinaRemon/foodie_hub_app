import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/features/cookbook/models/custom_recipe_model.dart';
import 'package:foodie_hup/features/cookbook/providers/custom_recipe_provider.dart';
import 'package:foodie_hup/features/cookbook/ui/create_recipe_screen.dart';
import 'package:foodie_hup/features/recipes/ui/recipe_details_screen.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/core/widgets/loading_widget.dart';
import 'package:foodie_hup/core/widgets/error_state_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MyRecipesList extends StatelessWidget {
  const MyRecipesList({super.key});

  void _confirmDelete(BuildContext context, CustomRecipeModel recipe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Recipe?"),
        content: Text("This recipe will be permanently removed from your recipes."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: AppColors.contentColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CustomRecipeProvider>().deleteRecipe(recipe.id).then((success) {
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recipe deleted successfully.')),
                  );
                }
              });
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomRecipeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: LoadingWidget());
        }

        if (provider.errorMessage != null) {
          return Center(
            child: ErrorStateWidget(
              errorMessage: provider.errorMessage!,
              onRetry: () => provider.loadMyRecipes(),
            ),
          );
        }

        if (provider.myRecipes.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu_outlined,
                    size: 80.sp,
                    color: AppColors.borderColor.withValues(alpha: 0.5),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "No Custom Recipes Yet",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.secondMainColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Create your first recipe and it will appear here.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.contentColor,
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: provider.myRecipes.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final recipe = provider.myRecipes[index];
            return Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                leading: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.borderColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.fastfood, color: AppColors.contentColor),
                ),
                title: Text(
                  recipe.title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondMainColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  "${recipe.category} • ${recipe.preparationTime} mins",
                  style: TextStyle(color: AppColors.contentColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailsScreen(sourceModel: recipe),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: AppColors.contentColor),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateRecipeScreen(recipe: recipe),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _confirmDelete(context, recipe),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

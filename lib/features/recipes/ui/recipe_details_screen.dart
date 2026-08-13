import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/core/widgets/loading_widget.dart';
import 'package:foodie_hup/core/widgets/error_state_widget.dart';
import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/features/cookbook/widgets/favorite_button.dart';
import 'package:foodie_hup/features/recipes/providers/recipe_details_provider.dart';
import 'package:foodie_hup/features/recipes/models/unified_recipe_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final dynamic sourceModel; // Either MealModel or CustomRecipeModel

  const RecipeDetailsScreen({super.key, required this.sourceModel});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Load recipe when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeDetailsProvider>().loadRecipe(widget.sourceModel);
    });
  }

  Future<void> _launchYouTubeUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Consumer<RecipeDetailsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading || provider.recipe == null) {
            return Center(child: LoadingWidget());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: ErrorStateWidget(
                errorMessage: provider.errorMessage!,
                onRetry: () => provider.loadRecipe(widget.sourceModel),
              ),
            );
          }

          final recipe = provider.recipe!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0.h,
                pinned: true,
                backgroundColor: AppColors.mainColor,
                iconTheme: IconThemeData(color: AppColors.secondMainColor),
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeroImage(recipe),
                ),
                actions: [
                  if (!recipe.isCustom && recipe.sourceModel is MealModel)
                    Padding(
                      padding: EdgeInsets.only(right: 16.0.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: FavoriteButton(
                          meal: recipe.sourceModel as MealModel,
                        ),
                      ),
                    ),
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28.r),
                      topRight: Radius.circular(28.r),
                    ),
                  ),
                  transform: Matrix4.translationValues(0.0, -24.0, 0.0),
                  child: Padding(
                    padding: EdgeInsets.all(20.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleSection(recipe, context),
                        SizedBox(height: 20.h),
                        _buildMetadataSection(recipe, context),
                        SizedBox(height: 20.h),
                        if (recipe.description != null &&
                            recipe.description!.isNotEmpty) ...[
                          _buildDescriptionSection(recipe, context),
                          SizedBox(height: 20.h),
                        ],
                        _buildIngredientsSection(recipe, context),
                        SizedBox(height: 20.h),
                        _buildInstructionsSection(recipe, context),
                        SizedBox(height: 20.h),
                        if (recipe.youtubeUrl != null &&
                            recipe.youtubeUrl!.isNotEmpty)
                          _buildYouTubeButton(recipe.youtubeUrl!, context),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeroImage(UnifiedRecipeModel recipe) {
    if (recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: recipe.imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.borderColor.withValues(alpha: 0.3),
          child: Center(child: LoadingWidget()),
        ),
        errorWidget: (context, url, error) => _buildImagePlaceholder(),
      );
    } else {
      return _buildImagePlaceholder();
    }
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.borderColor.withValues(alpha: 0.3),
      child: Center(
        child: Icon(Icons.fastfood, size: 60.sp, color: AppColors.contentColor),
      ),
    );
  }

  Widget _buildTitleSection(UnifiedRecipeModel recipe, BuildContext context) {
    return Text(
      recipe.title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: AppColors.secondMainColor,
        fontWeight: FontWeight.bold,
        fontSize: 24.sp,
      ),
    );
  }

  Widget _buildMetadataSection(
    UnifiedRecipeModel recipe,
    BuildContext context,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (recipe.category != null && recipe.category!.isNotEmpty)
            _buildMetaChip(Icons.category, recipe.category!, context),
          if (recipe.area != null && recipe.area!.isNotEmpty) ...[
            SizedBox(width: 12.w),
            _buildMetaChip(Icons.public, recipe.area!, context),
          ],
          if (recipe.preparationTime != null) ...[
            SizedBox(width: 12.w),
            _buildMetaChip(
              Icons.timer,
              "${recipe.preparationTime} mins",
              context,
            ),
          ],
          if (recipe.servings != null) ...[
            SizedBox(width: 12.w),
            _buildMetaChip(
              Icons.people,
              "${recipe.servings} servings",
              context,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String label, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.secondMainColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: AppColors.secondMainColor),
          SizedBox(width: 6.w),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.secondMainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(
    UnifiedRecipeModel recipe,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.secondMainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          recipe.description!,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.contentColor,
            height: 1.5.h,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection(
    UnifiedRecipeModel recipe,
    BuildContext context,
  ) {
    if (recipe.ingredients.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ingredients",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.secondMainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.borderColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recipe.ingredients.length,
            separatorBuilder: (context, index) =>
                const Divider(color: AppColors.borderColor),
            itemBuilder: (context, index) {
              final ingredient = recipe.ingredients[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0.h),
                child: Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: AppColors.secondMainColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        ingredient.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.secondMainColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (ingredient.measure.isNotEmpty)
                      Text(
                        ingredient.measure,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.contentColor,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsSection(
    UnifiedRecipeModel recipe,
    BuildContext context,
  ) {
    if (recipe.instructions.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Instructions",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.secondMainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recipe.instructions.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    color: AppColors.secondMainColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      "${index + 1}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.0.h),
                    child: Text(
                      recipe.instructions[index],
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.contentColor,
                        height: 1.5.h,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildYouTubeButton(String url, BuildContext context) {
    return Center(
      child: OutlinedButton.icon(
        onPressed: () => _launchYouTubeUrl(url),
        icon: Icon(Icons.play_circle_fill, color: Colors.red),
        label: Text(
          "Watch on YouTube",
          style: TextStyle(
            color: AppColors.secondMainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        ),
      ),
    );
  }
}

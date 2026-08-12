import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/features/cookbook/providers/favorite_provider.dart';
import 'package:foodie_hup/features/cookbook/widgets/cookbook_header.dart';
import 'package:foodie_hup/features/cookbook/widgets/cookbook_recipe_grid.dart';
import 'package:foodie_hup/features/cookbook/widgets/empty_cookbook.dart';
import 'package:foodie_hup/features/cookbook/ui/create_recipe_screen.dart';
import 'package:foodie_hup/features/cookbook/widgets/my_recipes_list.dart';
import 'package:foodie_hup/core/widgets/loading_widget.dart';
import 'package:foodie_hup/core/widgets/error_state_widget.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';

class CookbookScreen extends StatelessWidget {
  const CookbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: CookbookHeader(),
              ),
              const TabBar(
                labelColor: AppColors.secondMainColor,
                unselectedLabelColor: AppColors.contentColor,
                indicatorColor: AppColors.mainColor,
                tabs: [
                  Tab(text: "Favorites"),
                  Tab(text: "My Recipes"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Favorites Tab
                    Consumer<FavoriteProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading) {
                          return const Center(child: LoadingWidget());
                        } else if (provider.errorMessage != null) {
                          return Center(
                            child: ErrorStateWidget(
                              errorMessage: provider.errorMessage!,
                              onRetry: () => provider.loadFavorites(),
                            ),
                          );
                        } else if (provider.favorites.isEmpty) {
                          return const EmptyCookbook();
                        } else {
                          return CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                sliver: CookbookRecipeGrid(meals: provider.favorites),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    // My Recipes Tab
                    const MyRecipesList(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateRecipeScreen()),
          );
        },
        backgroundColor: AppColors.secondMainColor,
        child: const Icon(Icons.add, color: AppColors.mainColor),
      ),
      ),
    );
  }
}

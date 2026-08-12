import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/features/auth/providers/auth_provider.dart';
import 'package:foodie_hup/features/cookbook/providers/favorite_provider.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/core/widgets/app_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.contentColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AuthProvider>().logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthProvider>().currentUser;
    final displayName = currentUser?.displayName;
    final displayString = (displayName != null && displayName.isNotEmpty) ? displayName : 'User';
    final email = currentUser?.email ?? 'No email available';
    final photoURL = currentUser?.photoURL;
    
    // Watch FavoriteProvider to stay reactive
    final favoriteProvider = context.watch<FavoriteProvider>();
    final favoritesCount = favoriteProvider.favorites.length;

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: AppColors.mainColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                backgroundColor: AppColors.borderColor.withValues(alpha: 0.3),
                radius: 50,
                backgroundImage: (photoURL != null && photoURL.isNotEmpty) ? NetworkImage(photoURL) : null,
                child: (photoURL != null && photoURL.isNotEmpty)
                    ? null
                    : const Icon(Icons.person, color: AppColors.contentColor, size: 50),
              ),
              const SizedBox(height: 16),
              
              // Name
              Text(
                displayString,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.secondMainColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              
              // Email
              Text(
                email,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.contentColor,
                    ),
              ),
              const SizedBox(height: 32),

              // Statistics Section
              Card(
                color: Colors.white,
                elevation: 2,
                shadowColor: AppColors.shadowColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.favorite, color: AppColors.secondMainColor, size: 32),
                          const SizedBox(height: 8),
                          if (favoriteProvider.isLoading)
                            const SizedBox(
                              width: 20, 
                              height: 20, 
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.mainColor)
                            )
                          else
                            Text(
                              "$favoritesCount",
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: AppColors.secondMainColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            "Favorite Recipes",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.contentColor,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Actions
              AppButton(
                text: "Logout",
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

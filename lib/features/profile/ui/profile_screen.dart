import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/features/auth/providers/auth_provider.dart';
import 'package:foodie_hup/features/cookbook/providers/favorite_provider.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/core/widgets/app_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: AppColors.contentColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AuthProvider>().logout();
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
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
        title: Text("Profile", style: TextStyle(color: AppColors.mainColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                backgroundColor: AppColors.borderColor.withValues(alpha: 0.3),
                radius: 40.r,
                backgroundImage: (photoURL != null && photoURL.isNotEmpty) ? NetworkImage(photoURL) : null,
                child: (photoURL != null && photoURL.isNotEmpty)
                    ? null
                    : Icon(Icons.person, color: AppColors.contentColor, size: 40.sp),
              ),
              SizedBox(height: 12.h),
              
              // Name
              Text(
                displayString,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.secondMainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                    ),
              ),
              SizedBox(height: 4.h),
              
              // Email
              Text(
                email,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.contentColor,
                    ),
              ),
              SizedBox(height: 24.h),

              // Statistics Section
              Card(
                color: Colors.white,
                elevation: 2,
                shadowColor: AppColors.shadowColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.favorite, color: AppColors.secondMainColor, size: 28.sp),
                          SizedBox(height: 8.h),
                          if (favoriteProvider.isLoading)
                            SizedBox(
                              width: 20.w, 
                              height: 20.h, 
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
                          SizedBox(height: 4.h),
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
              SizedBox(height: 32.h),

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

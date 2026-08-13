import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/features/auth/providers/auth_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
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
    final displayString = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : 'User';
    final photoURL = currentUser?.photoURL;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.borderColor.withValues(alpha: 0.3),
            radius: 18.r,
            backgroundImage: (photoURL != null && photoURL.isNotEmpty)
                ? NetworkImage(photoURL)
                : null,
            child: (photoURL != null && photoURL.isNotEmpty)
                ? null
                : Icon(Icons.person, color: AppColors.contentColor),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, $displayString",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.contentColor,
                  ),
                ),
                Text(
                  "FoodieHub",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.secondMainColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              size: 22.sp,
              color: AppColors.secondMainColor,
            ),
            onPressed: () {
              // Future notification logic
            },
          ),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: AppColors.contentColor,
              size: 20.sp,
            ),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }
}

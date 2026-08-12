import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/features/auth/providers/auth_provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
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
    final displayString = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : 'User';
    final photoURL = currentUser?.photoURL;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.borderColor.withValues(alpha: 0.3),
            radius: 22,
            backgroundImage: (photoURL != null && photoURL.isNotEmpty)
                ? NetworkImage(photoURL)
                : null,
            child: (photoURL != null && photoURL.isNotEmpty)
                ? null
                : const Icon(Icons.person, color: AppColors.contentColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good morning, $displayString.",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.contentColor),
              ),
              Text(
                "FoodieHub",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.secondMainColor,
                  fontWeight: FontWeight.w900,
                  fontFamily:
                      'Serif', // Placeholder for the elegant serif font in reference
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: AppColors.shadowColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: AppColors.secondMainColor,
              ),
              onPressed: () {
                // Future notification logic
              },
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: AppColors.contentColor,
              size: 20,
            ),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }
}

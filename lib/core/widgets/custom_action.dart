import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';

class CustomAction extends StatelessWidget {
  const CustomAction({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.contentColor.withValues(alpha: .1),
      child: Icon(
        Icons.notifications_outlined,
        color: AppColors.secondMainColor,
      ),
    );
  }
}

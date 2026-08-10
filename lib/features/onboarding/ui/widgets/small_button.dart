import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';

class SmallButton extends StatelessWidget {
  final void Function()? onTap;
  const SmallButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 116,
        decoration: BoxDecoration(
          color: AppColors.secondMainColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Start",
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: AppColors.mainColor),
            ),
            SizedBox(width: 6),
            Icon(Icons.arrow_forward, color: AppColors.mainColor, size: 18),
          ],
        ),
      ),
    );
  }
}

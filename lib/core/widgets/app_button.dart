import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final Color? color;
  final String text;
  final void Function()? onTap;
  final TextStyle? style;
  final BoxBorder? border;
  const AppButton({
    super.key,
    this.color,
    required this.text,
    this.onTap,
    this.style,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 360,
        height: 60,
        decoration: BoxDecoration(
          border: border,
          color: color ?? AppColors.secondMainColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            text,
            style:
                style ??
                Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.mainColor,
                  fontSize: 18,
                ),
          ),
        ),
      ),
    );
  }
}

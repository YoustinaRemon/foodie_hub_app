import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/gen/assets.gen.dart';

class GoogleButton extends StatelessWidget {
  final Color? color;
  final void Function()? onTap;

  const GoogleButton({super.key, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 360,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.icons.googleLogo, width: 22, height: 22),

            const SizedBox(width: 10),

            Text(
              'Continue with Google',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

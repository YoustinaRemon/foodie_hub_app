import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/gen/assets.gen.dart';

class StackPhotos extends StatelessWidget {
  const StackPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 342,
        height: 390,
        child: Stack(
          children: [
            Positioned(
              top: 20,
              right: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Assets.images.stack1.image(
                  width: 256.5,
                  height: 256.5,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Positioned(
              bottom: 20,
              left: 20,
              child: ClipRRect(
                child: Assets.images.stack2.image(
                  width: 170,
                  height: 228,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Positioned(
              top: 170,
              left: 150,
              child: Container(
                width: 70,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.circleBehindHerat.withValues(alpha: .9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.favorite,
                    color: AppColors.heartColor,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

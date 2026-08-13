import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/features/discover/providers/discover_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class DietaryFilter extends StatelessWidget {
  const DietaryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscoverProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Icon(Icons.eco, color: Colors.green, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Vegetarian Only',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.contentColor,
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
              ),
            ),
            const Spacer(),
            Switch(
              value: provider.isVegetarian,
              activeTrackColor: AppColors.secondMainColor,
              activeThumbColor: AppColors.mainColor,
              onChanged: (value) {
                provider.setVegetarianFilter(value);
              },
            ),
          ],
        );
      },
    );
  }
}

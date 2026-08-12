import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final String text;
  final ValueChanged<String>? onFieldSubmitted;

  const CustomSearchBar({super.key, required this.text, this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },

      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search_outlined),
        fillColor: AppColors.shadowColor,
        filled: true,
        hint: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: AppColors.contentColor.withValues(alpha: .5),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

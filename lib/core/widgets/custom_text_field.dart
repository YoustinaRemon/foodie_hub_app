import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final bool isPassword;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  const CustomTextField({
    super.key,
    required this.text,
    this.keyboardType,
    this.isPassword = false,
    this.prefixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isobscure = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.isPassword && isobscure,
      keyboardType: widget.keyboardType,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },

      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? InkWell(
                onTap: () {
                  setState(() {
                    isobscure = !isobscure;
                  });
                },
                child: isobscure
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              )
            : null,
        prefixIcon: widget.prefixIcon,
        fillColor: AppColors.mainColor,
        filled: true,
        hint: Text(
          widget.text,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: AppColors.contentColor.withValues(alpha: .5),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
      ),
    );
  }
}

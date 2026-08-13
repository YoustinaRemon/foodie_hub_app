import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';

import 'package:foodie_hup/features/cookbook/models/custom_recipe_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class IngredientListEditor extends StatefulWidget {
  final List<CustomIngredient>? initialIngredients;

  const IngredientListEditor({super.key, this.initialIngredients});

  @override
  State<IngredientListEditor> createState() => IngredientListEditorState();
}

class IngredientListEditorState extends State<IngredientListEditor> {
  late List<int> _ingredientKeys;
  late int _nextKey;

  @override
  void initState() {
    super.initState();
    if (widget.initialIngredients != null && widget.initialIngredients!.isNotEmpty) {
      _ingredientKeys = List.generate(widget.initialIngredients!.length, (index) => index);
      _nextKey = widget.initialIngredients!.length;
    } else {
      _ingredientKeys = [0];
      _nextKey = 1;
    }
  }

  void addIngredient() {
    setState(() {
      _ingredientKeys.add(_nextKey++);
    });
  }

  void removeIngredient(int key) {
    if (_ingredientKeys.length > 1) {
      setState(() {
        _ingredientKeys.remove(key);
      });
    }
  }

  List<Map<String, String>> getIngredients(GlobalKey<FormBuilderState> formKey) {
    final List<Map<String, String>> ingredients = [];
    for (final key in _ingredientKeys) {
      final name = formKey.currentState?.fields['ingredient_name_$key']?.value as String?;
      final measure = formKey.currentState?.fields['ingredient_measure_$key']?.value as String?;
      
      if (name != null && name.trim().isNotEmpty) {
        ingredients.add({
          'name': name.trim(),
          'measure': measure?.trim() ?? '',
        });
      }
    }
    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ingredients",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.secondMainColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: addIngredient,
              icon: Icon(Icons.add, color: AppColors.mainColor),
              label: Text(
                "Add",
                style: TextStyle(color: AppColors.mainColor),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.secondMainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ..._ingredientKeys.asMap().entries.map((entry) {
          final index = entry.key;
          final key = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: 12.0.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: FormBuilderTextField(
                    name: 'ingredient_name_$key',
                    initialValue: (widget.initialIngredients != null && index < widget.initialIngredients!.length) 
                        ? widget.initialIngredients![index].name 
                        : null,
                    decoration: InputDecoration(
                      hintText: "Name (e.g. Chicken)",
                      filled: true,
                      fillColor: AppColors.mainColor,
                      hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.contentColor.withValues(alpha: .5),
                          ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: AppColors.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: AppColors.borderColor),
                      ),
                    ),
                    validator: FormBuilderValidators.required(errorText: 'Required'),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 1,
                  child: FormBuilderTextField(
                    name: 'ingredient_measure_$key',
                    initialValue: (widget.initialIngredients != null && index < widget.initialIngredients!.length) 
                        ? widget.initialIngredients![index].measure 
                        : null,
                    decoration: InputDecoration(
                      hintText: "Qty",
                      filled: true,
                      fillColor: AppColors.mainColor,
                      hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.contentColor.withValues(alpha: .5),
                          ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: AppColors.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: AppColors.borderColor),
                      ),
                    ),
                  ),
                ),
                if (_ingredientKeys.length > 1)
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () => removeIngredient(key),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

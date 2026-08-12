import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/features/cookbook/providers/custom_recipe_provider.dart';

class RecipeImagePicker extends StatelessWidget {
  const RecipeImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomRecipeProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => provider.pickImage(),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.borderColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: provider.selectedImage != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        provider.selectedImage!,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => provider.clearSelectedImage(),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        size: 48,
                        color: AppColors.contentColor.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Tap to add a photo (Optional)",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.contentColor.withValues(alpha: 0.8),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Available for this session only",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.contentColor.withValues(alpha: 0.5),
                            ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

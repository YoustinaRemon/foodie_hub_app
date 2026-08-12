import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/core/widgets/app_button.dart';
import 'package:foodie_hup/core/widgets/loading_widget.dart';
import 'package:foodie_hup/features/cookbook/providers/custom_recipe_provider.dart';
import 'package:foodie_hup/features/cookbook/models/custom_recipe_model.dart';
import 'package:foodie_hup/features/cookbook/widgets/ingredient_list_editor.dart';
import 'package:foodie_hup/features/cookbook/widgets/instruction_list_editor.dart';
import 'package:foodie_hup/features/cookbook/widgets/recipe_image_picker.dart';

class CreateRecipeScreen extends StatefulWidget {
  final CustomRecipeModel? recipe;

  const CreateRecipeScreen({super.key, this.recipe});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<IngredientListEditorState> _ingredientListKey = GlobalKey();
  final GlobalKey<InstructionListEditorState> _instructionListKey = GlobalKey();

  InputDecoration _customInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.mainColor,
      hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: AppColors.contentColor.withValues(alpha: .5),
          ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
    );
  }

  void _submitForm() async {
    final provider = context.read<CustomRecipeProvider>();
    
    // Validate main form fields
    final isFormValid = _formKey.currentState?.saveAndValidate() ?? false;
    
    // Extract dynamic lists
    final ingredients = _ingredientListKey.currentState?.getIngredients(_formKey) ?? [];
    final instructions = _instructionListKey.currentState?.getInstructions(_formKey) ?? [];

    if (!isFormValid) return;

    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one ingredient.')),
      );
      return;
    }

    if (instructions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one instruction.')),
      );
      return;
    }

    final formData = _formKey.currentState!.value;

    bool success;
    if (widget.recipe == null) {
      success = await provider.createRecipe(
        title: formData['title'],
        description: formData['description'],
        category: formData['category'],
        preparationTime: int.tryParse(formData['preparationTime'].toString()) ?? 0,
        servings: int.tryParse(formData['servings'].toString()) ?? 0,
        ingredients: ingredients.map((i) => CustomIngredient(name: i['name']!, measure: i['measure']!)).toList(),
        instructions: instructions,
      );
    } else {
      success = await provider.updateRecipe(
        recipeId: widget.recipe!.id,
        title: formData['title'],
        description: formData['description'],
        category: formData['category'],
        preparationTime: int.tryParse(formData['preparationTime'].toString()) ?? 0,
        servings: int.tryParse(formData['servings'].toString()) ?? 0,
        ingredients: ingredients.map((i) => CustomIngredient(name: i['name']!, measure: i['measure']!)).toList(),
        instructions: instructions,
      );
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.successMessage ?? (widget.recipe == null ? 'Recipe created!' : 'Recipe updated!'))),
      );
      Navigator.pop(context);
    } else if (mounted && provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipe == null ? "Create Recipe" : "Edit Recipe",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.secondMainColor,
                fontWeight: FontWeight.w900,
                fontFamily: 'Serif',
              ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.contentColor),
      ),
      body: SafeArea(
        child: Consumer<CustomRecipeProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RecipeImagePicker(),
                        const SizedBox(height: 24),
                        
                        Text(
                          "Basic Information",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.secondMainColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        
                        FormBuilderTextField(
                          name: 'title',
                          initialValue: widget.recipe?.title,
                          decoration: _customInputDecoration('Recipe Name'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(3),
                          ]),
                        ),
                        const SizedBox(height: 16),
                        
                        FormBuilderTextField(
                          name: 'description',
                          initialValue: widget.recipe?.description,
                          maxLines: 3,
                          decoration: _customInputDecoration('Description'),
                          validator: FormBuilderValidators.required(),
                        ),
                        const SizedBox(height: 16),
                        
                        FormBuilderDropdown<String>(
                          name: 'category',
                          initialValue: widget.recipe?.category,
                          decoration: _customInputDecoration('Category'),
                          validator: FormBuilderValidators.required(),
                          items: const [
                            DropdownMenuItem(value: 'Breakfast', child: Text('Breakfast')),
                            DropdownMenuItem(value: 'Lunch', child: Text('Lunch')),
                            DropdownMenuItem(value: 'Dinner', child: Text('Dinner')),
                            DropdownMenuItem(value: 'Dessert', child: Text('Dessert')),
                            DropdownMenuItem(value: 'Snack', child: Text('Snack')),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'preparationTime',
                                initialValue: widget.recipe?.preparationTime.toString(),
                                keyboardType: TextInputType.number,
                                decoration: _customInputDecoration('Prep Time (mins)'),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.numeric(),
                                  FormBuilderValidators.min(1),
                                ]),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'servings',
                                initialValue: widget.recipe?.servings.toString(),
                                keyboardType: TextInputType.number,
                                decoration: _customInputDecoration('Servings'),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.numeric(),
                                  FormBuilderValidators.min(1),
                                ]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        
                        IngredientListEditor(key: _ingredientListKey, initialIngredients: widget.recipe?.ingredients),
                        const SizedBox(height: 32),
                        
                        InstructionListEditor(key: _instructionListKey, initialInstructions: widget.recipe?.instructions),
                        const SizedBox(height: 48),
                        
                        Center(
                          child: AppButton(
                            text: widget.recipe == null ? "Publish Recipe" : "Save Changes",
                            onTap: provider.isLoading ? null : _submitForm,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                
                if (provider.isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(
                      child: LoadingWidget(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

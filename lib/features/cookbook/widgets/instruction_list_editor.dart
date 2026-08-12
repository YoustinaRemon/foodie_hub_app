import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';

class InstructionListEditor extends StatefulWidget {
  final List<String>? initialInstructions;

  const InstructionListEditor({super.key, this.initialInstructions});

  @override
  State<InstructionListEditor> createState() => InstructionListEditorState();
}

class InstructionListEditorState extends State<InstructionListEditor> {
  late List<int> _instructionKeys;
  late int _nextKey;

  @override
  void initState() {
    super.initState();
    if (widget.initialInstructions != null && widget.initialInstructions!.isNotEmpty) {
      _instructionKeys = List.generate(widget.initialInstructions!.length, (index) => index);
      _nextKey = widget.initialInstructions!.length;
    } else {
      _instructionKeys = [0];
      _nextKey = 1;
    }
  }

  void addInstruction() {
    setState(() {
      _instructionKeys.add(_nextKey++);
    });
  }

  void removeInstruction(int key) {
    if (_instructionKeys.length > 1) {
      setState(() {
        _instructionKeys.remove(key);
      });
    }
  }

  List<String> getInstructions(GlobalKey<FormBuilderState> formKey) {
    final List<String> instructions = [];
    for (final key in _instructionKeys) {
      final step = formKey.currentState?.fields['instruction_step_$key']?.value as String?;
      if (step != null && step.trim().isNotEmpty) {
        instructions.add(step.trim());
      }
    }
    return instructions;
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
              "Instructions",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.secondMainColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: addInstruction,
              icon: const Icon(Icons.add, color: AppColors.mainColor),
              label: const Text(
                "Add",
                style: TextStyle(color: AppColors.mainColor),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.secondMainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._instructionKeys.asMap().entries.map((entry) {
          final index = entry.key;
          final key = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: 'instruction_step_$key',
                    initialValue: (widget.initialInstructions != null && index < widget.initialInstructions!.length)
                        ? widget.initialInstructions![index]
                        : null,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Step ${index + 1}",
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
                    ),
                    validator: FormBuilderValidators.required(errorText: 'Required'),
                  ),
                ),
                if (_instructionKeys.length > 1)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () => removeInstruction(key),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

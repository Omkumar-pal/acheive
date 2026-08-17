import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_card.dart';

class ReflectionPromptCard extends StatelessWidget {
  final String question;
  final String hint;
  final TextEditingController controller;
  final Function(String) onSave;

  const ReflectionPromptCard({
    super.key,
    required this.question,
    required this.hint,
    required this.controller,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AppleCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note_outlined,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(question, style: AppTypography.bodyStrong),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 3,
            onChanged: onSave,
            style: AppTypography.body.copyWith(fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  AppTypography.bodyMuted.copyWith(fontSize: 14),
              filled: true,
              fillColor: AppColors.canvasParchment,
              border: OutlineInputBorder(
                borderRadius: AppRadius.roundedSm,
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}

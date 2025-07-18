import 'package:flutter/material.dart';
import 'package:portaria_flutter/shared/auth/presentation/theme/app_colors.dart';

class FuncDisponiveisText extends StatelessWidget {
  final String text;

  const FuncDisponiveisText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

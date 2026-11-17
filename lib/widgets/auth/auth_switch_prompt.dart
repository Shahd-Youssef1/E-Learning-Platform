import 'package:flutter/material.dart';
import 'auth_colors.dart';

class AuthSwitchPrompt extends StatelessWidget {
  final String promptText;
  final String actionText;
  final VoidCallback onTap;

  const AuthSwitchPrompt({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          promptText,
          style: const TextStyle(
            color: AuthColors.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: 'Cairo',
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              color: AuthColors.purpleGlow,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ],
    );
  }
}

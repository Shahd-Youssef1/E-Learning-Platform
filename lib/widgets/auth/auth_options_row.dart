import 'package:flutter/material.dart';
import 'auth_colors.dart';

class AuthOptionsRow extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onForgotPasswordTap;

  const AuthOptionsRow({
    super.key,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onForgotPasswordTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: "تذكرني ☑"
        GestureDetector(
          onTap: () => onRememberMeChanged(!rememberMe),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: rememberMe ? AuthColors.purpleGlow : Colors.transparent,
                  border: Border.all(
                    color: rememberMe ? AuthColors.purpleGlow : AuthColors.textDim,
                    width: 1.5,
                  ),
                ),
                child: rememberMe
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 8),
              const Text(
                'تذكرني',
                style: TextStyle(
                  color: AuthColors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),

        // Right: "نسيت كلمة المرور؟"
        GestureDetector(
          onTap: onForgotPasswordTap,
          child: const Text(
            'نسيت كلمة المرور؟',
            style: TextStyle(
              color: AuthColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ],
    );
  }
}

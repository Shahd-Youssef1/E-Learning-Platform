import 'package:flutter/material.dart';
import 'auth_colors.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final TextInputType keyboardType;
  final IconData? suffixIcon;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AuthColors.fieldBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AuthColors.fieldBorder,
          width: 1.2,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        keyboardType: keyboardType,
        textAlign: TextAlign.end,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: AuthColors.purpleGlow,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AuthColors.textMuted,
            fontSize: 15,
          ),
          border: InputBorder.none,
          prefixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AuthColors.textDim,
                    size: 20,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: AuthColors.textDim, size: 20)
              : null,
        ),
      ),
    );
  }
}

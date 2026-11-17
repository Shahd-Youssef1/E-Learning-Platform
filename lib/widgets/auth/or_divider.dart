import 'package:flutter/material.dart';
import 'auth_colors.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: Divider(
            color: AuthColors.fieldBorder,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'أو',
            style: TextStyle(
              color: AuthColors.textDim,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AuthColors.fieldBorder,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

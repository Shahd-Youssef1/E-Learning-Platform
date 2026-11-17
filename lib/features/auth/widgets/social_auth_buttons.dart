import 'package:flutter/material.dart';
import 'auth_colors.dart';

class SocialAuthButtons extends StatelessWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;

  const SocialAuthButtons({
    super.key,
    required this.onGoogleTap,
    required this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Google Button
        Expanded(
          child: _buildSocialCard(
            onTap: onGoogleTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGoogleIcon(),
                const SizedBox(width: 8),
                const Text(
                  'Google',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Apple Button with Real Apple Logo
        Expanded(
          child: _buildSocialCard(
            onTap: onAppleTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Apple',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                // Real Apple Logo
                Icon(Icons.apple, color: Colors.white, size: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialCard({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AuthColors.fieldBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AuthColors.fieldBorder,
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return const Text(
      'G',
      style: TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w800,
        fontFamily: 'Roboto',
      ),
    );
  }
}

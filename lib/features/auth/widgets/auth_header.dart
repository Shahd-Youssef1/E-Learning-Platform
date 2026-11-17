import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_colors.dart';
import 'auth_colors.dart';

class AuthHeader extends StatelessWidget {
  final String subtitle;
  final double logoSize;
  final TextStyle? subtitleStyle;

  const AuthHeader({
    super.key,
    required this.subtitle,
    this.logoSize = 96,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Logo with glowing gradient border
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(logoSize * 0.29),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AuthColors.pinkAccent,
                AuthColors.purpleGlow,
                AppColors.primary,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AuthColors.purpleGlow.withValues(alpha: 0.35),
                blurRadius: 28,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(2.5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(logoSize * 0.26),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2E175B),
                  Color(0xFF1E103D),
                ],
              ),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: -0.05,
                    child: Icon(
                      Icons.school_rounded,
                      size: logoSize * 0.52,
                      color: const Color(0xFF38354A),
                    ),
                  ),
                  Text(
                    '🎓',
                    style: TextStyle(
                      fontSize: logoSize * 0.46,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Brand Name (EduFlow)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Edu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'Flow',
              style: TextStyle(
                color: Color(0xFFD8B4FE),
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Subtitle (Enhanced Typography)
        Text(
          subtitle,
          style: subtitleStyle ??
              GoogleFonts.amiri(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD4C8FA),
                letterSpacing: 0.3,
                height: 1.4,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'auth_colors.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AuthScaffold({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.bgBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AuthColors.bgTop,
              AuthColors.bgMid,
              AuthColors.bgBottom,
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

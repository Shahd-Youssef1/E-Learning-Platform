import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../navigation/screens/main_navigation.dart';
import '../services/auth_service.dart';
import '../widgets/auth_widgets.dart';
import 'register_screen.dart';

class LoginInScreen extends StatefulWidget {
  const LoginInScreen({super.key});

  @override
  State<LoginInScreen> createState() => _LoginInScreenState();
}

class _LoginInScreenState extends State<LoginInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = true;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        backgroundColor: isError ? AppColors.danger : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('يرجى إدخال البريد الإلكتروني وكلمة المرور');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.signInWithEmail(
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (response.user != null) {
        _showSnackBar('تم تسجيل الدخول بنجاح!', isError: false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      }
    } catch (e) {
      _showSnackBar(AuthService.parseAuthError(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleOAuth(Future<bool> Function() authMethod, String provider) async {
    try {
      await authMethod();
    } catch (e) {
      _showSnackBar('تعذر الاتصال بـ $provider: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),

          // Header (Logo + EduFlow + Subtitle)
          const AuthHeader(subtitle: 'تعلم اليوم، انطلق لمستقبلك'),

          const SizedBox(height: 36),

          // Email Field
          AuthTextField(
            controller: _emailController,
            hintText: 'البريد الإلكتروني',
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 16),

          // Password Field
          AuthTextField(
            controller: _passwordController,
            hintText: 'كلمة المرور',
            isPassword: true,
            obscureText: _obscurePassword,
            onToggleVisibility: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),

          const SizedBox(height: 14),

          // Options Row: [تذكرني ☑] & [نسيت كلمة المرور؟]
          AuthOptionsRow(
            rememberMe: _rememberMe,
            onRememberMeChanged: (val) => setState(() => _rememberMe = val),
            onForgotPasswordTap: () {
              ForgotPasswordDialog.show(
                context,
                initialEmail: _emailController.text.trim(),
                onNotify: _showSnackBar,
              );
            },
          ),

          const SizedBox(height: 24),

          // Login Button
          AuthButton(
            text: 'تسجيل الدخول',
            onTap: _handleLogin,
            isLoading: _isLoading,
          ),

          const SizedBox(height: 26),

          // "أو" Divider
          const OrDivider(),

          const SizedBox(height: 24),

          // Social Auth Buttons (Google & Apple with real Apple Logo)
          SocialAuthButtons(
            onGoogleTap: () => _handleOAuth(AuthService.signInWithGoogle, 'Google'),
            onAppleTap: () => _handleOAuth(AuthService.signInWithApple, 'Apple'),
          ),

          const SizedBox(height: 32),

          // Bottom Prompt: "ليس لديك حساب؟ أنشئ حساباً"
          AuthSwitchPrompt(
            promptText: 'ليس لديك حساب؟ ',
            actionText: 'أنشئ حساباً',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              );
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

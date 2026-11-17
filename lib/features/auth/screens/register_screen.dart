import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../navigation/screens/main_navigation.dart';
import '../services/auth_service.dart';
import '../widgets/auth_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('يرجى ملء جميع الحقول المطلوبة');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showSnackBar('يرجى إدخال بريد إلكتروني صالح');
      return;
    }

    if (password.length < 6) {
      _showSnackBar('كلمة المرور يجب أن لا تقل عن 6 أحرف');
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('كلمتا المرور غير متطابقتين');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.signUpWithEmail(
        email: email,
        password: password,
        fullName: name,
      );

      if (!mounted) return;

      if (response.user != null) {
        if (response.session != null) {
          _showSnackBar('تم إنشاء الحساب بنجاح!', isError: false);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigation()),
            (route) => false,
          );
        } else {
          _showSuccessDialog();
        }
      }
    } catch (e) {
      _showSnackBar(AuthService.parseAuthError(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AuthColors.fieldBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AuthColors.fieldBorder),
        ),
        title: const Text(
          'تم إنشاء الحساب بنجاح! 🎉',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        content: const Text(
          'تم إرسال رسالة تأكيد إلى بريدك الإلكتروني. يرجى تفعيل حسابك ثم تسجيل الدخول.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AuthColors.textMuted,
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AuthColors.purpleGlow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'العودة لتسجيل الدخول',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
          const SizedBox(height: 8),

          // Header with Logo
          const AuthHeader(
            subtitle: 'إنشاء حساب جديد',
            logoSize: 80,
          ),

          const SizedBox(height: 28),

          // Full Name Field
          AuthTextField(
            controller: _nameController,
            hintText: 'الاسم الكامل',
            suffixIcon: Icons.person_outline_rounded,
          ),

          const SizedBox(height: 14),

          // Email Field
          AuthTextField(
            controller: _emailController,
            hintText: 'البريد الإلكتروني',
            suffixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 14),

          // Password Field
          AuthTextField(
            controller: _passwordController,
            hintText: 'كلمة المرور (6 أحرف أو أكثر)',
            suffixIcon: Icons.lock_outline_rounded,
            isPassword: true,
            obscureText: _obscurePassword,
            onToggleVisibility: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),

          const SizedBox(height: 14),

          // Confirm Password Field
          AuthTextField(
            controller: _confirmPasswordController,
            hintText: 'تأكيد كلمة المرور',
            suffixIcon: Icons.lock_clock_outlined,
            isPassword: true,
            obscureText: _obscureConfirmPassword,
            onToggleVisibility: () {
              setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
            },
          ),

          const SizedBox(height: 24),

          // Sign Up Button
          AuthButton(
            text: 'إنشاء الحساب',
            onTap: _handleRegister,
            isLoading: _isLoading,
          ),

          const SizedBox(height: 22),

          // "أو" Divider
          const OrDivider(),

          const SizedBox(height: 20),

          // Social Auth Buttons
          SocialAuthButtons(
            onGoogleTap: () => _handleOAuth(AuthService.signInWithGoogle, 'Google'),
            onAppleTap: () => _handleOAuth(AuthService.signInWithApple, 'Apple'),
          ),

          const SizedBox(height: 24),

          // Return to Login: "لديك حساب بالفعل؟ تسجيل الدخول"
          AuthSwitchPrompt(
            promptText: 'لديك حساب بالفعل؟ ',
            actionText: 'تسجيل الدخول',
            onTap: () => Navigator.of(context).pop(),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

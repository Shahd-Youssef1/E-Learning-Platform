import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_colors.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final String initialEmail;
  final void Function(String message, {bool isError}) onNotify;

  const ForgotPasswordDialog({
    super.key,
    this.initialEmail = '',
    required this.onNotify,
  });

  static Future<void> show(
    BuildContext context, {
    String initialEmail = '',
    required void Function(String message, {bool isError}) onNotify,
  }) {
    return showDialog(
      context: context,
      builder: (_) => ForgotPasswordDialog(
        initialEmail: initialEmail,
        onNotify: onNotify,
      ),
    );
  }

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  late final TextEditingController _resetEmailController;
  bool _isResetting = false;

  @override
  void initState() {
    super.initState();
    _resetEmailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _resetEmailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetLink() async {
    final email = _resetEmailController.text.trim();
    if (email.isEmpty) {
      widget.onNotify('يرجى كتابة البريد الإلكتروني', isError: true);
      return;
    }

    setState(() => _isResetting = true);
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        redirectTo: kIsWeb ? null : 'io.supabase.eduflow://login-callback/',
      );
      if (mounted) Navigator.of(context).pop();
      widget.onNotify(
        'تم إرسال رابط استعادة كلمة المرور إلى $email',
        isError: false,
      );
    } on AuthException catch (e) {
      widget.onNotify(e.message, isError: true);
    } catch (e) {
      widget.onNotify('حدث خطأ: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isResetting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AuthColors.fieldBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AuthColors.fieldBorder),
      ),
      title: const Text(
        'استعادة كلمة المرور',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'أدخل بريدك الإلكتروني المسجل وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AuthColors.textMuted,
              fontSize: 13,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: AuthColors.bgBottom,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AuthColors.fieldBorder),
            ),
            child: TextField(
              controller: _resetEmailController,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              cursorColor: AuthColors.purpleGlow,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                hintText: 'name@example.com',
                hintStyle: TextStyle(color: AuthColors.textDim, fontSize: 14),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.email_outlined, color: AuthColors.textDim, size: 20),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'إلغاء',
            style: TextStyle(color: AuthColors.textMuted, fontFamily: 'Cairo'),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AuthColors.purpleGlow,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: _isResetting ? null : _handleSendResetLink,
          child: _isResetting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'إرسال الرابط',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
        ),
      ],
    );
  }
}

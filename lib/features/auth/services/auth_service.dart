import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final SupabaseClient _client = Supabase.instance.client;

  /// Current signed in user
  static User? get currentUser => _client.auth.currentUser;

  /// Sign in with email and password
  static Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  /// Sign up with email, password, and optional full name
  static Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    return await _client.auth.signUp(
      email: email.trim(),
      password: password.trim(),
      data: fullName != null && fullName.isNotEmpty
          ? {'full_name': fullName.trim()}
          : null,
    );
  }

  /// Send password recovery link to email
  static Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(
      email.trim(),
      redirectTo: kIsWeb ? null : 'io.supabase.eduflow://login-callback/',
    );
  }

  /// Sign in via Google OAuth
  static Future<bool> signInWithGoogle() async {
    return await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? null : 'io.supabase.eduflow://login-callback/',
    );
  }

  /// Sign in via Apple OAuth
  static Future<bool> signInWithApple() async {
    return await _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: kIsWeb ? null : 'io.supabase.eduflow://login-callback/',
    );
  }

  /// Sign out current user
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Convert Supabase auth exceptions to friendly Arabic messages
  static String parseAuthError(Object error) {
    if (error is AuthException) {
      final msg = error.message.toLowerCase();
      if (msg.contains('invalid login credentials')) {
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      }
      if (msg.contains('user already registered')) {
        return 'هذا البريد الإلكتروني مسجل بالفعل';
      }
      if (msg.contains('email not confirmed')) {
        return 'يرجى تأكيد بريدك الإلكتروني أولاً لتسجيل الدخول';
      }
      if (msg.contains('network') || msg.contains('connection')) {
        return 'تعذر الاتصال بالخادم، يرجى التحقق من اتصال الإنترنت';
      }
      return error.message;
    }
    return 'حدث خطأ غير متوقع: $error';
  }
}

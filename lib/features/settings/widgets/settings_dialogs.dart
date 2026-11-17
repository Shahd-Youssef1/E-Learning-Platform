import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import 'settings_strings.dart';

class SettingsDialogs {
  /// Base bottom sheet style supporting dark and light themes and RTL/LTR
  static Future<T?> _showSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isDark = true,
    bool isArabic = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF140F28) : AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(
                color: isDark ? const Color(0xFF251C42) : AppColors.border,
                width: 1.5,
              ),
            ),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF20173A) : AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }

  /// 1. Language Selection Sheet (Arabic & English only)
  static Future<String?> showLanguageSheet(
    BuildContext context, {
    required String currentLanguage,
    bool isDark = true,
    bool isArabic = true,
  }) {
    final s = SettingsStrings(isArabic: isArabic);
    final languages = [
      ('العربية', isArabic ? 'العربية (الافتراضية)' : 'Arabic (Default)'),
      ('English', isArabic ? 'الإنجليزية' : 'English'),
    ];

    return _showSheet<String>(
      context: context,
      isDark: isDark,
      isArabic: isArabic,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sheetTitle(s.chooseLanguage, isDark),
          const SizedBox(height: 16),
          ...languages.map((lang) {
            final isSelected = lang.$1 == currentLanguage;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : (isDark ? const Color(0xFF151028) : AppColors.background),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? AppColors.primary : (isDark ? const Color(0xFF251C42) : AppColors.border),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  title: Text(
                    lang.$1,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : (isDark ? Colors.white : AppColors.textPrimary),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  subtitle: Text(
                    lang.$2,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  leading: Icon(
                    Icons.language_rounded,
                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                      : null,
                  onTap: () => Navigator.pop(context, lang.$1),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 2. Edit Profile Sheet
  static Future<void> showEditProfileSheet(
    BuildContext context, {
    bool isDark = true,
    bool isArabic = true,
  }) {
    final s = SettingsStrings(isArabic: isArabic);
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    return _showSheet(
      context: context,
      isDark: isDark,
      isArabic: isArabic,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sheetTitle(s.editProfile, isDark),
          const SizedBox(height: 20),
          _textField(
            label: s.fullName,
            hint: isArabic ? 'أدخل اسمك الكامل' : 'Enter your full name',
            controller: nameCtrl,
            icon: Icons.person_outline_rounded,
            isDark: isDark,
          ),
          const SizedBox(height: 14),
          _textField(
            label: s.emailAddress,
            hint: isArabic ? 'أدخل بريدك الإلكتروني' : 'Enter your email',
            controller: emailCtrl,
            icon: Icons.email_outlined,
            isDark: isDark,
          ),
          const SizedBox(height: 24),
          _primaryButton(
            text: s.saveChanges,
            onPressed: () {
              Navigator.pop(context);
              _showToast(context, s.changesSaved, isDark: isDark, color: AppColors.success);
            },
          ),
        ],
      ),
    );
  }

  /// 3. Privacy & Security Sheet
  static Future<void> showPrivacySheet(
    BuildContext context, {
    bool isDark = true,
    bool isArabic = true,
  }) {
    final s = SettingsStrings(isArabic: isArabic);

    return _showSheet(
      context: context,
      isDark: isDark,
      isArabic: isArabic,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sheetTitle(s.privacySecurity, isDark),
          const SizedBox(height: 18),
          _cardTile(
            icon: Icons.key_rounded,
            iconColor: AppColors.info,
            title: s.changePassword,
            subtitle: s.passwordSubtitle,
            isDark: isDark,
            isArabic: isArabic,
            onTap: () {
              Navigator.pop(context);
              _showToast(context, s.passwordResetSent, isDark: isDark);
            },
          ),
          const SizedBox(height: 12),
          _cardTile(
            icon: Icons.delete_forever_rounded,
            iconColor: AppColors.danger,
            textColor: AppColors.danger,
            title: s.deleteAccount,
            subtitle: isArabic ? 'حذف كافة بيانات الحساب نهائياً' : 'Permanently remove all your account data',
            isDark: isDark,
            isArabic: isArabic,
            onTap: () {
              Navigator.pop(context);
              _confirmDelete(context, isDark: isDark, isArabic: isArabic);
            },
          ),
        ],
      ),
    );
  }

  /// 4. Subscription & Payment Sheet
  static Future<void> showSubscriptionSheet(
    BuildContext context, {
    bool isDark = true,
    bool isArabic = true,
  }) {
    final s = SettingsStrings(isArabic: isArabic);

    return _showSheet(
      context: context,
      isDark: isDark,
      isArabic: isArabic,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sheetTitle(s.subscriptionPayment, isDark),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151028) : AppColors.background,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? const Color(0xFF251C42) : AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.credit_card_outlined, size: 36, color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  isArabic ? 'لا توجد اشتراكات نشطة حالياً' : 'No Active Subscriptions',
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isArabic
                      ? 'ستتم إضافة وتفعيل خطط الاشتراك وطرق الدفع تلقائياً فور إتاحتها.'
                      : 'Subscription plans and payment methods will be automatically added here once available.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    height: 1.5,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _primaryButton(
            text: isArabic ? 'حسناً' : 'Close',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// 5. Help Center Sheet
  static Future<void> showHelpCenterSheet(
    BuildContext context, {
    bool isDark = true,
    bool isArabic = true,
  }) {
    final s = SettingsStrings(isArabic: isArabic);

    return _showSheet(
      context: context,
      isDark: isDark,
      isArabic: isArabic,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sheetTitle(s.helpCenterTitle, isDark),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151028) : AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? const Color(0xFF251C42) : AppColors.border),
            ),
            child: TextField(
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.textPrimary,
                fontFamily: 'Cairo',
              ),
              decoration: InputDecoration(
                hintText: s.searchFaq,
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                icon: const Icon(Icons.search, color: AppColors.textMuted),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _faqTile(s.faq1Q, s.faq1A, isDark),
          _faqTile(s.faq2Q, s.faq2A, isDark),
          _faqTile(s.faq3Q, s.faq3A, isDark),
        ],
      ),
    );
  }

  /// 6. Contact Us Sheet
  static Future<void> showContactSheet(
    BuildContext context, {
    bool isDark = true,
    bool isArabic = true,
  }) {
    final s = SettingsStrings(isArabic: isArabic);

    return _showSheet(
      context: context,
      isDark: isDark,
      isArabic: isArabic,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sheetTitle(s.contactUsTitle, isDark),
          const SizedBox(height: 10),
          Text(
            s.contactUsSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 13, fontFamily: 'Cairo'),
          ),
          const SizedBox(height: 18),
          _cardTile(
            icon: Icons.chat_bubble_rounded,
            iconColor: AppColors.info,
            title: s.liveChat,
            isDark: isDark,
            isArabic: isArabic,
            onTap: () {
              Navigator.pop(context);
              _showToast(context, s.liveChatConnecting, isDark: isDark);
            },
          ),
          const SizedBox(height: 10),
          _cardTile(
            icon: Icons.email_rounded,
            iconColor: AppColors.warning,
            title: s.emailSupport,
            isDark: isDark,
            isArabic: isArabic,
            onTap: () {
              Navigator.pop(context);
              _showToast(context, s.emailCopied, isDark: isDark);
            },
          ),
          const SizedBox(height: 10),
          _cardTile(
            icon: Icons.phone_in_talk_rounded,
            iconColor: AppColors.success,
            title: s.whatsappSupport,
            isDark: isDark,
            isArabic: isArabic,
            onTap: () {
              Navigator.pop(context);
              _showToast(context, s.openingWhatsapp, isDark: isDark);
            },
          ),
        ],
      ),
    );
  }

  /// 7. Interactive Rate App Dialog
  static Future<void> showRateAppDialog(
    BuildContext context, {
    bool isDark = true,
    bool isArabic = true,
  }) {
    final s = SettingsStrings(isArabic: isArabic);
    int rating = 5;
    final feedbackCtrl = TextEditingController();

    return showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final textCol = isDark ? Colors.white : AppColors.textPrimary;
          final borderCol = isDark ? const Color(0xFF251C42) : AppColors.border;

          return Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: AlertDialog(
              backgroundColor: isDark ? const Color(0xFF16112C) : AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: BorderSide(color: borderCol),
              ),
              title: Column(
                children: [
                  Text(
                    s.rateAppTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textCol, fontSize: 19, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.rateAppSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5, fontFamily: 'Cairo'),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      final star = i + 1;
                      return IconButton(
                        iconSize: 34,
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        onPressed: () => setDialogState(() => rating = star),
                        icon: Icon(
                          star <= rating ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: star <= rating ? const Color(0xFFFBBF24) : AppColors.textMuted,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    s.sentimentText(rating),
                    style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Cairo'),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF151028) : AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderCol),
                    ),
                    child: TextField(
                      controller: feedbackCtrl,
                      maxLines: 3,
                      style: TextStyle(color: textCol, fontSize: 13, fontFamily: 'Cairo'),
                      decoration: InputDecoration(
                        hintText: s.feedbackHint,
                        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: Text(s.later, style: const TextStyle(color: AppColors.textMuted, fontFamily: 'Cairo')),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogCtx);
                    _showToast(context, s.ratingSubmitted(rating), isDark: isDark);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(s.submitRating, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Reusable UI Helpers ---

  static Widget _sheetTitle(String text, bool isDark) => Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: isDark ? Colors.white : AppColors.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: 'Cairo',
    ),
  );

  static Widget _primaryButton({required String text, required VoidCallback onPressed}) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
    ),
    child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
  );

  static Widget _textField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required bool isDark,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF151028) : AppColors.background,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: isDark ? const Color(0xFF251C42) : AppColors.border),
    ),
    child: TextField(
      controller: controller,
      style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary, fontFamily: 'Cairo'),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        icon: Icon(icon, color: AppColors.textMuted, size: 20),
        border: InputBorder.none,
      ),
    ),
  );

  static Widget _cardTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Color? textColor,
    required bool isDark,
    required bool isArabic,
    required VoidCallback onTap,
  }) => Container(
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF151028) : AppColors.background,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: isDark ? const Color(0xFF251C42) : AppColors.border),
    ),
    child: Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? (isDark ? Colors.white : AppColors.textPrimary),
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12, fontFamily: 'Cairo'))
            : null,
        trailing: Icon(
          isArabic ? Icons.arrow_left_rounded : Icons.arrow_right_rounded,
          color: AppColors.textMuted,
          size: 22,
        ),
        onTap: onTap,
      ),
    ),
  );

  static Widget _faqTile(String question, String answer, bool isDark) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF151028) : AppColors.background,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: isDark ? const Color(0xFF251C42) : AppColors.border),
    ),
    child: ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          color: isDark ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 13.5,
          fontFamily: 'Cairo',
        ),
      ),
      iconColor: AppColors.primary,
      collapsedIconColor: AppColors.textMuted,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          child: Text(
            answer,
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.5,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ],
    ),
  );

  static void _confirmDelete(BuildContext context, {required bool isDark, required bool isArabic}) {
    final s = SettingsStrings(isArabic: isArabic);
    showDialog(
      context: context,
      builder: (dialogCtx) => Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: isDark ? const Color(0xFF16112C) : AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.danger),
          ),
          title: Text(s.deleteAccountConfirmTitle, style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          content: Text(
            s.deleteAccountConfirmMessage,
            style: TextStyle(color: isDark ? AppColors.textMuted : AppColors.textSecondary, fontSize: 13, fontFamily: 'Cairo'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(s.cancel, style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                _showToast(context, s.deleteRequestReceived, isDark: isDark);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
              child: Text(s.yesDelete, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            ),
          ],
        ),
      ),
    );
  }

  static void _showToast(BuildContext context, String message, {bool isDark = true, Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Cairo')),
        backgroundColor: color ?? (isDark ? const Color(0xFF1E163B) : const Color(0xFF332B50)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/settings/settings_widgets.dart';

class SettingsScreen extends StatefulWidget {
  final bool? isDarkMode;
  final ValueChanged<bool>? onThemeChanged;

  const SettingsScreen({
    super.key,
    this.isDarkMode,
    this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _darkMode;
  bool _appNotifications = true;
  bool _dailyStudyReminder = true;
  bool _wifiOnlyDownload = false;

  String _selectedLanguage = 'العربية';
  bool get _isArabic => _selectedLanguage == 'العربية';
  SettingsStrings get _s => SettingsStrings(isArabic: _isArabic);
  int _currentNavIndex = 4;

  @override
  void initState() {
    super.initState();
    _darkMode = widget.isDarkMode ?? true;
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDarkMode != null && widget.isDarkMode != _darkMode) {
      setState(() => _darkMode = widget.isDarkMode!);
    }
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Cairo'),
          ),
          backgroundColor: _darkMode ? const Color(0xFF1E163B) : const Color(0xFF332B50),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _darkMode
        ? const [Color(0xFF221147), Color(0xFF130D26), Color(0xFF090614)]
        : const [AppColors.surface, AppColors.background, AppColors.surfaceSecondary];

    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: _darkMode ? const Color(0xFF090614) : AppColors.background,
        bottomNavigationBar: SettingsBottomBar(
          currentIndex: _currentNavIndex,
          isDark: _darkMode,
          isArabic: _isArabic,
          onTap: (index) {
            setState(() => _currentNavIndex = index);
            if (index != 4) {
              final labels = _isArabic
                  ? ['الرئيسية', 'الكورسات', 'تقدمي', 'الاختبارات', 'حسابي']
                  : ['Home', 'Courses', 'Progress', 'Quizzes', 'Profile'];
              _showFeedback(_isArabic ? 'الانتقال إلى: ${labels[index]}' : 'Go to: ${labels[index]}');
            }
          },
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        // Section 1: Preferences / التفضيلات
                        SettingsSection(
                          title: _s.preferences,
                          isDark: _darkMode,
                          children: [
                            SettingsSwitchTile(
                              icon: Icons.nightlight_round,
                              iconColor: AppColors.warning,
                              title: _s.darkMode,
                              value: _darkMode,
                              isDark: _darkMode,
                              onChanged: (val) {
                                setState(() => _darkMode = val);
                                widget.onThemeChanged?.call(val);
                                _showFeedback(val ? _s.darkModeOn : _s.darkModeOff);
                              },
                            ),
                            SettingsSwitchTile(
                              icon: Icons.notifications_rounded,
                              iconColor: AppColors.warning,
                              title: _s.notifications,
                              value: _appNotifications,
                              isDark: _darkMode,
                              onChanged: (val) {
                                setState(() => _appNotifications = val);
                                _showFeedback(val ? _s.notificationsOn : _s.notificationsOff);
                              },
                            ),
                            SettingsSwitchTile(
                              icon: Icons.alarm_rounded,
                              iconColor: AppColors.danger,
                              title: _s.studyReminder,
                              value: _dailyStudyReminder,
                              isDark: _darkMode,
                              onChanged: (val) {
                                setState(() => _dailyStudyReminder = val);
                                _showFeedback(val ? _s.reminderOn : _s.reminderOff);
                              },
                            ),
                            SettingsSwitchTile(
                              icon: Icons.signal_cellular_alt_rounded,
                              iconColor: AppColors.warning,
                              title: _s.wifiOnly,
                              value: _wifiOnlyDownload,
                              isDark: _darkMode,
                              onChanged: (val) {
                                setState(() => _wifiOnlyDownload = val);
                                _showFeedback(val ? _s.wifiOnlyOn : _s.wifiOnlyOff);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Section 2: Account / الحساب
                        SettingsSection(
                          title: _s.account,
                          isDark: _darkMode,
                          children: [
                            SettingsNavTile(
                              icon: Icons.language_rounded,
                              iconColor: AppColors.info,
                              title: _s.language,
                              isDark: _darkMode,
                              trailing: Text(
                                _selectedLanguage,
                                style: TextStyle(
                                  color: _darkMode ? const Color(0xFFA19DB8) : AppColors.textSecondary,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              onTap: () async {
                                final chosenLang = await SettingsDialogs.showLanguageSheet(
                                  context,
                                  currentLanguage: _selectedLanguage,
                                  isDark: _darkMode,
                                  isArabic: _isArabic,
                                );
                                if (chosenLang != null && chosenLang != _selectedLanguage) {
                                  setState(() => _selectedLanguage = chosenLang);
                                  _showFeedback(chosenLang == 'العربية'
                                      ? 'تم تحويل لغة التطبيق إلى العربية'
                                      : 'Language switched to English');
                                }
                              },
                            ),
                            SettingsNavTile(
                              icon: Icons.person_rounded,
                              iconColor: AppColors.info,
                              title: _s.editProfile,
                              isDark: _darkMode,
                              onTap: () => SettingsDialogs.showEditProfileSheet(
                                context,
                                isDark: _darkMode,
                                isArabic: _isArabic,
                              ),
                            ),
                            SettingsNavTile(
                              icon: Icons.lock_rounded,
                              iconColor: AppColors.warning,
                              title: _s.privacySecurity,
                              isDark: _darkMode,
                              onTap: () => SettingsDialogs.showPrivacySheet(
                                context,
                                isDark: _darkMode,
                                isArabic: _isArabic,
                              ),
                            ),
                            SettingsNavTile(
                              icon: Icons.credit_card_rounded,
                              iconColor: AppColors.warning,
                              title: _s.subscriptionPayment,
                              isDark: _darkMode,
                              onTap: () => SettingsDialogs.showSubscriptionSheet(
                                context,
                                isDark: _darkMode,
                                isArabic: _isArabic,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Section 3: Support / الدعم
                        SettingsSection(
                          title: _s.support,
                          isDark: _darkMode,
                          children: [
                            SettingsNavTile(
                              icon: Icons.help_rounded,
                              iconColor: AppColors.danger,
                              title: _s.helpCenter,
                              isDark: _darkMode,
                              onTap: () => SettingsDialogs.showHelpCenterSheet(
                                context,
                                isDark: _darkMode,
                                isArabic: _isArabic,
                              ),
                            ),
                            SettingsNavTile(
                              icon: Icons.chat_bubble_rounded,
                              iconColor: _darkMode ? Colors.white : AppColors.textPrimary,
                              title: _s.contactUs,
                              isDark: _darkMode,
                              onTap: () => SettingsDialogs.showContactSheet(
                                context,
                                isDark: _darkMode,
                                isArabic: _isArabic,
                              ),
                            ),
                            SettingsNavTile(
                              icon: Icons.star_rounded,
                              iconColor: AppColors.warning,
                              title: _s.rateApp,
                              isDark: _darkMode,
                              onTap: () => SettingsDialogs.showRateAppDialog(
                                context,
                                isDark: _darkMode,
                                isArabic: _isArabic,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Version info
                        Text(
                          'EduFlow v2.4.0',
                          style: TextStyle(
                            color: _darkMode ? const Color(0xFF6B648B) : AppColors.textMuted,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.canPop(context) ? Navigator.pop(context) : _showFeedback(_s.rootScreenFeedback),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _darkMode ? const Color(0xFF1E1738) : AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: _darkMode ? const Color(0xFF251C42) : AppColors.border),
                boxShadow: _darkMode
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Icon(
                _isArabic ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
                color: _darkMode ? Colors.white : AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: Text(
              _s.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _darkMode ? Colors.white : AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          const SizedBox(width: 42, height: 42),
        ],
      ),
    );
  }
}

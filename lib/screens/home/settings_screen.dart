import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../../services/theme_and_locale_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final settings = appState.settings;
    final themeAndLocale = context.watch<ThemeAndLocaleService>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.translate('settings'),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: isDark ? 0 : 2,
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),
          _buildSectionTitle(context, l10n.translate('applicationSection')),
          const SizedBox(height: 10),
          _buildCard(
            context,
            child: ListTile(
              leading: Icon(Icons.language, color: colorScheme.primary),
              title: Text(l10n.translate('appLanguage')),
              subtitle: Text(l10n.languageName(themeAndLocale.languageCode)),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: themeAndLocale.languageCode,
                  items: [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(l10n.languageEnglish),
                    ),
                    DropdownMenuItem(
                      value: 'ar',
                      child: Text(l10n.languageArabic),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null || value == themeAndLocale.languageCode) {
                      return;
                    }
                    context.read<ThemeAndLocaleService>().setLanguageCode(value);
                  },
                ),
              ),
            ),
          ),
          _buildCard(
            context,
            child: SwitchListTile(
              thumbColor: WidgetStatePropertyAll(colorScheme.primary),
              title: Text(l10n.translate('notificationsToggle')),
              secondary: Icon(Icons.notifications, color: colorScheme.primary),
              value: settings.notificationsEnabled,
              onChanged: (value) {
                context.read<AppState>().toggleNotifications(value);
              },
            ),
          ),
          _buildCard(
            context,
            child: SwitchListTile(
              thumbColor: WidgetStatePropertyAll(colorScheme.primary),
              title: Text(l10n.translate('darkModeToggle')),
              secondary: Icon(Icons.dark_mode, color: colorScheme.primary),
              value: themeAndLocale.isDarkMode,
              onChanged: (value) {
                context.read<ThemeAndLocaleService>().toggleDarkMode(value);
              },
            ),
          ),
          const SizedBox(height: 25),
          _buildSectionTitle(context, l10n.translate('supportSection')),
          const SizedBox(height: 10),
          _buildCard(
            context,
            child: ListTile(
              leading: Icon(Icons.email, color: colorScheme.primary),
              title: Text(l10n.translate('contactSupport')),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: colorScheme.primary,
                    content: Text(l10n.translate('contactSupportMessage')),
                  ),
                );
              },
            ),
          ),
          _buildCard(
            context,
            child: ListTile(
              leading: Icon(Icons.star_rate, color: colorScheme.secondary),
              title: Text(l10n.translate('rateApp')),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: colorScheme.primary,
                    content: Text(l10n.translate('rateAppMessage')),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
        border: Border.all(
          color: isDark ? colorScheme.outlineVariant : Colors.transparent,
        ),
      ),
      child: child,
    );
  }
}

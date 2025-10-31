import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../onboarding/step1_age_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final profile = appState.profile;
    final user = appState.user;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final displayName =
        user?.username ?? profile?.preferredName ?? 'Health Sync member';
    final email = user?.email ?? '';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: isDark ? 0 : 2,
        iconTheme: IconThemeData(color: primary),
      ),
      body: profile == null
          ? _EmptyProfile(
              onStart: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Step1AgeScreen(),
                  ),
                );
              },
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: primary.withAlpha(51),
                    child: Text(
                      _avatarInitial(displayName),
                      style: TextStyle(
                        fontSize: 38,
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    displayName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (email.isNotEmpty)
                    Text(
                      email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                        fontSize: 15,
                      ),
                    ),
                  const SizedBox(height: 25),
                  _ProfileSection(
                    title: 'Health information',
                    rows: [
                      _infoRow('Age', '${profile.age} years'),
                      _infoRow(
                          'Height', '${profile.height.toStringAsFixed(1)} cm'),
                      _infoRow(
                          'Weight', '${profile.weight.toStringAsFixed(1)} kg'),
                      _infoRow('Gender', profile.gender),
                      _infoRow('Diabetes', profile.hasDiabetes ? 'Yes' : 'No'),
                      _infoRow(
                        'Hypertension',
                        profile.hasHypertension ? 'Yes' : 'No',
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Step1AgeScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: Text(
                      'Update health profile',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 28,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You can revisit the onboarding flow at any time to keep your information up to date.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  static String _avatarInitial(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return 'H';
    return trimmed.substring(0, 1).toUpperCase();
  }

  static MapEntry<String, String> _infoRow(String label, String value) =>
      MapEntry(label, value);
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<MapEntry<String, String>> rows;

  const _ProfileSection({
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? const []
            : const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          for (final row in rows) _ProfileRow(label: row.key, value: row.value),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyProfile extends StatelessWidget {
  final VoidCallback onStart;

  const _EmptyProfile({required this.onStart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 56, color: primary),
            const SizedBox(height: 20),
            Text(
              'We have not collected your health details yet.',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Complete the onboarding steps to personalise your insights and recommendations.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
              ),
              child: Text(
                'Start onboarding',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

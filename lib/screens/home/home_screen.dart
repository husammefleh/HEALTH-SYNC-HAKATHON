import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../../widgets/app_logo.dart';
import '../auth/login_screen.dart';
import 'dashboard_screen.dart';
import 'food/food_screen.dart';
import 'health/health_main_screen.dart';
import 'history_screen.dart';
import 'medicine/medicine_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'sleep/sleep_screen.dart';
import 'sport/activity_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _tabs = const [
    HomeMainContent(),
    DashboardScreen(),
    ProfileScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final userName = appState.user?.username ?? appState.user?.email ?? l10n.translate('appTitle');

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: theme.brightness == Brightness.dark ? 0 : 3,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const AppLogo(height: 36),
                const SizedBox(width: 8),
                Text(
                  userName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: colorScheme.primary),
              onSelected: (value) async {
                if (value == 'settings') {
                  _onItemTapped(4);
                } else if (value == 'logout') {
                  final navigator = Navigator.of(context);
                  await context.read<AppState>().logout();
                  if (!mounted) return;
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                    (_) => false,
                  );
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'settings',
                  child: Text(l10n.translate('openSettings')),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text(l10n.translate('logout')),
                ),
              ],
            ),
          ],
        ),
      ),
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.translate('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: l10n.translate('dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.translate('profile'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: l10n.translate('history'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.translate('settingsLabel'),
          ),
        ],
      ),
    );
  }
}

class HomeMainContent extends StatelessWidget {
  const HomeMainContent({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final caloriesToday = appState.totalFoodCaloriesToday();
    final sleepHours = appState.totalSleepHoursThisWeek();
    final activityMinutes = appState.totalActivityMinutesThisWeek();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            l10n.translate('welcomeBack'),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.translate('welcomeBackMessage'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _FeatureCard(
                title: l10n.translate('mealsNutrition'),
                icon: Icons.restaurant_menu,
                color: Colors.orangeAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FoodScreen()),
                ),
              ),
              _FeatureCard(
                title: l10n.translate('sleepTracking'),
                icon: Icons.nightlight_round,
                color: Colors.indigoAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SleepScreen()),
                ),
              ),
              _FeatureCard(
                title: l10n.translate('activityTracking'),
                icon: Icons.fitness_center,
                color: Colors.green,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ActivityMainScreen(),
                  ),
                ),
              ),
              _FeatureCard(
                title: l10n.translate('medication'),
                icon: Icons.medical_services_outlined,
                color: Colors.redAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MedicineScreen()),
                ),
              ),
              _FeatureCard(
                title: l10n.translate('vitalsHealth'),
                icon: Icons.monitor_heart,
                color: colorScheme.primary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HealthMainScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.translate('dailySnapshot'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.dailySnapshotDetails(
                    calories: caloriesToday,
                    sleepHours: sleepHours,
                    activityMinutes: activityMinutes,
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withAlpha(64), width: 2),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.4)
                  : color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 48),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

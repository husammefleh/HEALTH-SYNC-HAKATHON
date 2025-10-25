import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/medicine/add_medicine_screen.dart';
import 'screens/home/sleep/add_sleep_screen.dart';
import 'screens/home/sleep/loading_sleep_screen.dart';
import 'screens/home/sleep/sleep_result_screen.dart';
import 'screens/home/sleep/sleep_screen.dart';
import 'screens/home/food/food_add_screen.dart';
import 'screens/home/sport/add_activity_screen.dart';
import 'screens/home/sport/loading_activity_screen.dart';
import 'screens/onboarding/step1_age_screen.dart';
import 'screens/onboarding/summary_screen.dart';
import 'screens/splash_screen.dart';
import 'state/app_state.dart';
import 'services/theme_and_locale_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  final themeAndLocaleService = ThemeAndLocaleService();
  await Future.wait([
    appState.load(),
    themeAndLocaleService.initialize(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appState),
        ChangeNotifierProvider.value(value: themeAndLocaleService),
      ],
      child: const HealthApp(),
    ),
  );
}

class HealthApp extends StatelessWidget {
  const HealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeAndLocale = context.watch<ThemeAndLocaleService>();

    final colorSeed = Colors.teal;
    final ThemeData lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: colorSeed),
      scaffoldBackgroundColor: Colors.grey[50],
      fontFamily: 'Roboto',
      useMaterial3: true,
    );

    final ThemeData darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorSeed,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      fontFamily: 'Roboto',
      useMaterial3: true,
    );

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).translate('appTitle'),
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeAndLocale.themeMode,
      locale: themeAndLocale.locale,
      supportedLocales: themeAndLocale.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: themeAndLocale.localeResolutionCallback,
      home: const SplashScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/sleep': (_) => const SleepScreen(),
        '/add_sleep': (_) => const AddSleepScreen(),
        '/sleep_result': (_) => const SleepResultScreen(),
        '/food_add': (_) => const FoodAddScreen(),
        '/activity_add': (_) => const AddActivityScreen(),
        '/medicine_add': (_) => const AddMedicineScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/loading_sleep':
            final hours = settings.arguments as double? ?? 0;
            return MaterialPageRoute(
              builder: (_) => const LoadingSleepScreen(),
              settings: RouteSettings(arguments: hours),
            );
          case '/activity_loading':
            final activity = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => LoadingActivityScreen(activityData: activity),
            );
          case '/onboarding':
            return MaterialPageRoute(
              builder: (_) => const Step1AgeScreen(),
            );
          case '/summary':
            final args = settings.arguments as Map<String, dynamic>?;
            if (args == null) break;
            return MaterialPageRoute(
              builder: (_) => SummaryScreen(
                height: args['height'] as double,
                weight: args['weight'] as double,
                gender: args['gender'] as String,
                goal: args['goal'] as String,
                hasDiabetes: args['hasDiabetes'] as bool,
                hasHypertension: args['hasHypertension'] as bool,
                age: args['age'] as int,
              ),
            );
        }
        return null;
      },
      builder: (context, child) {
        return Directionality(
          textDirection: themeAndLocale.textDirection,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}


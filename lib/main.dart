import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/medicine/add_medicine_screen.dart';
import 'screens/home/sleep/add_sleep_screen.dart';
import 'screens/home/sleep/sleep_screen.dart';
import 'screens/home/food/food_add_screen.dart';
import 'screens/home/sport/add_activity_screen.dart';
import 'screens/onboarding/step1_age_screen.dart';
import 'screens/onboarding/summary_screen.dart';
import 'screens/splash_screen.dart';
import 'state/app_state.dart';
import 'services/api/activity_service.dart';
import 'services/api/api_base_service.dart';
import 'services/api/app_settings_service.dart';
import 'services/api/ai_api_service.dart';
import 'services/api/auth_service.dart';
import 'services/api/food_service.dart';
import 'services/api/hedera_mirror_service.dart';
import 'services/api/hedera_writer_service.dart';
import 'services/api/health_reading_service.dart';
import 'services/api/medicine_service.dart';
import 'services/api/sleep_service.dart';
import 'services/api/user_profile_service.dart';
import 'services/theme_and_locale_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  late final AppState appState;
  final themeAndLocaleService = ThemeAndLocaleService();
  final apiService = ApiBaseService(
    onUnauthorized: () {
      appState.logout();
    },
  );
  final authService = AuthService(apiService);
  final userProfileApi = UserProfileApiService(apiService);
  final appSettingsApi = AppSettingsApiService(apiService);
  final foodApi = FoodApiService(apiService);
  final sleepApi = SleepApiService(apiService);
  final activityApi = ActivityApiService(apiService);
  final medicineApi = MedicineApiService(apiService);
  final healthApi = HealthReadingApiService(apiService);
  final aiApi = AiApiService();
  final hederaWriter = HederaWriterService();
  final hederaMirror = HederaMirrorService();

  appState = AppState(
    authService: authService,
    userProfileApi: userProfileApi,
    appSettingsApi: appSettingsApi,
    foodApi: foodApi,
    sleepApi: sleepApi,
    activityApi: activityApi,
    medicineApi: medicineApi,
    healthApi: healthApi,
    aiApi: aiApi,
    hederaMirror: hederaMirror,
  );

  await Future.wait([
    appState.load(),
    themeAndLocaleService.initialize(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiBaseService>.value(value: apiService),
        Provider<AuthService>.value(value: authService),
        Provider<UserProfileApiService>.value(value: userProfileApi),
        Provider<AppSettingsApiService>.value(value: appSettingsApi),
        Provider<FoodApiService>.value(value: foodApi),
        Provider<SleepApiService>.value(value: sleepApi),
        Provider<ActivityApiService>.value(value: activityApi),
        Provider<MedicineApiService>.value(value: medicineApi),
        Provider<HealthReadingApiService>.value(value: healthApi),
        Provider<AiApiService>.value(value: aiApi),
        Provider<HederaWriterService>.value(value: hederaWriter),
        Provider<HederaMirrorService>.value(value: hederaMirror),
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

    const colorSeed = Colors.teal;
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
      onGenerateTitle: (context) =>
          AppLocalizations.of(context).translate('appTitle'),
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
        '/food_add': (_) => const FoodAddScreen(),
        '/activity_add': (_) => const AddActivityScreen(),
        '/medicine_add': (_) => const AddMedicineScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
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

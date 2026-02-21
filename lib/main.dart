import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dashboard_screen.dart';
import 'ai_assistant_screen.dart';
import 'settings_screen.dart';
import 'package:provider/provider.dart';
import 'providers/water_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'l10n/app_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding/onboarding_flow_screen.dart';
import 'screens/daily_meter_input_screen.dart';
import 'screens/welcome_back_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('chat_history');
  await Hive.openBox('settings');
  await Hive.openBox('user');
  await Hive.openBox('meter_readings');
  await Hive.openBox('challenges');
  await Hive.openBox('user_settings');

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file not found");
  }

  final authProvider = AuthProvider();
  final waterProvider = WaterProvider();
  final languageProvider = LanguageProvider();

  await authProvider.initialize();
  await waterProvider.initialize();
  await languageProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: waterProvider),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const HydrosmartApp(),
    ),
  );
}

class HydrosmartApp extends StatelessWidget {
  const HydrosmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isAuthenticated = authProvider.isAuthenticated;
    final hasCompletedOnboarding = authProvider.hasCompletedOnboarding;
    final languageProvider = context.watch<LanguageProvider>();

    Widget home;
    if (!isAuthenticated) {
      home = LoginScreen();
    } else if (!hasCompletedOnboarding) {
      home = const OnboardingFlowScreen();
    } else {
      home = const MainNavigationShell();
    }

    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hydrosmart',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: languageProvider.currentLocale,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
        Locale('fr', ''),
      ],
      builder: (context, child) {
        return Directionality(
          textDirection:
          languageProvider.isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
      home: home,
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HydrosmartDashboard(),
    const AIAssistantScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkForInactivity();
  }

  Future<void> _checkForInactivity() async {
    // Give UI time to load
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final waterProvider = context.read<WaterProvider>();
    final daysAway = waterProvider.getDaysSinceLastOpen();

    if (daysAway > 1) {
      // Show welcome back screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => WelcomeBackScreen(daysAway: daysAway),
          fullscreenDialog: true,
        ),
      );
    }
  }

  void _showMeterInput() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DailyMeterInputScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.backgroundGradient
              : AppColors.lightBackgroundGradient,
        ),
        child: IndexedStack(
            index: _selectedIndex,
            children: _screens
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
        onPressed: _showMeterInput,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.water_drop),
        label: Text(
          AppLocalizations.of(context).translate('log_reading'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      )
          : null,
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard, color: AppColors.primary),
            label: AppLocalizations.of(context).translate('nav_home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble_outline),
            selectedIcon: const Icon(Icons.chat_bubble, color: AppColors.primary),
            label: AppLocalizations.of(context).translate('nav_ai_chat'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings, color: AppColors.primary),
            label: AppLocalizations.of(context).translate('nav_settings'),
          ),
        ],
      ),
    );
  }
}
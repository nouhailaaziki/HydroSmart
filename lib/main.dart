import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'ai_assistant_screen.dart';
import 'settings_screen.dart';
import 'package:provider/provider.dart';
import 'providers/water_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding/onboarding_flow_screen.dart';
import 'screens/daily_meter_input_screen.dart';
import 'screens/welcome_back_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme/app_theme.dart';

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

  await authProvider.initialize();
  await waterProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: waterProvider),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hydrosmart',
      theme: AppTheme.darkTheme,
      locale: languageProvider.currentLocale,
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D47A1), Color(0xFF001529)],
          ),
        ),
        child: IndexedStack(
            index: _selectedIndex,
            children: _screens
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _showMeterInput,
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              icon: const Icon(Icons.water_drop),
              label: const Text(
                'Log Reading',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        backgroundColor: const Color(0xFF001529),
        indicatorColor: Colors.cyanAccent.withOpacity(0.2),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard, color: Colors.cyanAccent),
              label: 'Home'
          ),
          NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble, color: Colors.cyanAccent),
              label: 'AI Chat'
          ),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings, color: Colors.cyanAccent),
              label: 'Settings'
          ),
        ],
      ),
    );
  }
}
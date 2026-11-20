import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:southsea_cinema/views/basket_view.dart';
import 'package:southsea_cinema/views/settings_view.dart';

void main() {
  runApp(const SouthseaCinemaApp());
}

class SouthseaCinemaApp extends StatefulWidget {
  const SouthseaCinemaApp({super.key});

  @override
  State<SouthseaCinemaApp> createState() => _SouthseaCinemaAppState();
}

class _SouthseaCinemaAppState extends State<SouthseaCinemaApp> {
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final String? savedTheme = await _preferences.getString('theme_mode');

    if (!mounted) return;

    setState(() {
      _themeMode = savedTheme == 'light' ? ThemeMode.light : ThemeMode.dark;
    });
  }

  Future<void> _changeThemeMode(ThemeMode mode) async {
    setState(() {
      _themeMode = mode;
    });

    await _preferences.setString(
      'theme_mode',
      mode == ThemeMode.light ? 'light' : 'dark',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Southsea Cinema & Arts Centre',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,

      // Light theme
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF3F5F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: cinemaBrand,
          brightness: Brightness.light,
          primary: cinemaBrand,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1B1E28),
          iconTheme: IconThemeData(color: cinemaBrand),
          titleTextStyle: TextStyle(
            color: Color(0xFF1B1E28),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
        ),
      ),

      // Dark theme
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: cinemaBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: cinemaBrand,
          brightness: Brightness.dark,
          primary: cinemaBrand,
          surface: cinemaSurface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: cinemaSurface,
          iconTheme: IconThemeData(color: cinemaBrand),
          titleTextStyle: cinemaHeaderStyle,
          elevation: 0,
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const HomeView(),
        '/basket': (context) => const BasketView(),
        '/settings': (context) => SettingsView(
              themeMode: _themeMode,
              onThemeModeChanged: _changeThemeMode,
            ),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mobile/src/screens/home_page.dart';
import 'package:mobile/src/screens/login_screen.dart';
import 'package:mobile/src/screens/sign_up_screen.dart';
import 'package:mobile/src/screens/task_form_page.dart';
import 'package:mobile/src/screens/logout_page.dart';
import 'package:mobile/src/screens/profile_page.dart';
import 'package:mobile/src/screens/settings_page.dart';
import 'package:mobile/src/screens/tasks_list_page.dart';
import 'package:mobile/src/screens/favorites_page.dart';
import 'package:mobile/src/screens/terms_and_services_page.dart';
import 'package:mobile/src/screens/purpose_page.dart';
import 'package:mobile/src/screens/how_it_works_page.dart';
import 'package:mobile/src/screens/initial_screen_game.dart';
import 'package:mobile/src/providers/auth_provider.dart';
import 'package:mobile/src/providers/theme_provider.dart';
import 'package:mobile/src/providers/settings_provider.dart';
import 'package:mobile/src/providers/task_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6C63FF);
    const darkPurple = Color(0xFF311B92);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    // Configura o tema base baseado no alto contraste
    final lightTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: settingsProvider.highContrast 
          ? Colors.white 
          : const Color(0xFFF7F8FF),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: settingsProvider.highContrast ? darkPurple : primaryColor,
        brightness: Brightness.light,
        surface: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pato',
      themeMode: ThemeMode.light, // Mantendo fixo conforme sua preferência
      theme: lightTheme,
      builder: (context, child) {
        // Aplica a escala de texto global
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(settingsProvider.largerText ? 1.25 : 1.0),
          ),
          child: child!,
        );
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomePage(),
        '/task-form': (context) => const TaskFormPage(),
        '/logout': (context) => const LogoutPage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/tasks-list': (context) => const TasksListPage(),
        '/favorites': (context) => const FavoritesPage(),
        '/terms': (context) => const TermsAndServicesPage(),
        '/purpose': (context) => const PurposePage(),
        '/how-it-works': (context) => const HowItWorksPage(),
        '/games': (context) => const InitialScreenGame(),
      },
    );
  }
}

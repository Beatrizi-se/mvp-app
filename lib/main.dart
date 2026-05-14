import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/src/screens/home_page.dart';
import 'package:mobile/src/screens/login_screen.dart';
import 'package:mobile/src/screens/sign_up_screen.dart';
import 'package:mobile/src/screens/task_form_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6C63FF);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Neurodivergência',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomePage(),
        '/task-form': (context) => const TaskFormPage(),
      },
    );
  }
}

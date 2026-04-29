import 'package:flutter/material.dart';
import 'package:mobile/src/screens/tela_inicial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Neurodivergência',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255), 
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TelaInicial(),
    );
  }
}
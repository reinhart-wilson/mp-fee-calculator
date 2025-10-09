import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/views/calculator_form_screen.dart'; // adjust path if needed

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marketplace Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, // Your custom base color
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const CalculatorFormScreen(),
    );
  }
}

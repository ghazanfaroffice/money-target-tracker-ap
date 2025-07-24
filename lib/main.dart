import 'package:flutter/material.dart';

import 'home_screen.dart';

void main() {
  // No Hive initialization or adapter registration needed here,
  // as StorageService uses SharedPreferences.
  runApp(const MoneyTargetApp());
}

class MoneyTargetApp extends StatelessWidget {
  const MoneyTargetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Target Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal, // Uses a teal theme as per your original main.dart
      ),
      home: const HomeScreen(),
    );
  }
}

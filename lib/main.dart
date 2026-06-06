import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const GymToDoApp());
}

class GymToDoApp extends StatelessWidget {
  const GymToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymToDo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

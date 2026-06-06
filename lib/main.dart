import 'package:flutter/material.dart';
import 'package:gym_to_do/providers/usuario_provider.dart';
import 'package:provider/provider.dart';
import 'providers/treino_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TreinoProvider()),
        ChangeNotifierProvider(create: (context) => UsuarioProvider()),
      ],
      child: const GymToDoApp(),
    ),
  );
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

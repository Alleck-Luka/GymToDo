import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/treino_provider.dart';
import 'providers/usuario_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UsuarioProvider()),
        ChangeNotifierProxyProvider<UsuarioProvider, TreinoProvider>(
          create: (context) => TreinoProvider(),
          update: (context, usuarioProvider, treinoProvider) {
            treinoProvider!.atualizarUsuario(usuarioProvider.usuario?.uid);
            return treinoProvider;
          },
        ),
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

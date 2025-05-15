import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letra/inicio.dart'; // Pantalla de inicio (con argumento idUsuario)
import 'sesion.dart';             // LoginScreen
import 'registro.dart';           // RegistroScreen
import 'home.dart';               // JaguarPage (Pantalla de bienvenida)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Aprendizaje',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      // Pantalla inicial
      home: const SplashScreen(),

      // Rutas fijas
      routes: {
        '/login': (context) => const LoginScreen(), // Login
        '/registro': (context) => const RegistroPage(), // Registro
        '/jaguar': (context) => const JaguarPage(), // Pantalla de bienvenida
        '/sesion': (context) => const LoginScreen(), // Pantalla de inicio de sesión
        
      },

      // Rutas dinámicas con argumentos
      onGenerateRoute: (settings) {
        if (settings.name == '/inicio') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => Inicio(
              idUsuario: args['idUsuario'], // Recibe idUsuario
            ),
          );
        }
        return null; // No se encontró una ruta válida
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/jaguar');
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFA6722),
        body: Center(
          child: SvgPicture.asset(
            'imagen/logo.svg', // Logo SVG
            width: 200, // Tamaño del logo
          ),
        ),
      ),
    );
  }
}

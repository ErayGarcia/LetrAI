import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class JaguarPage extends StatefulWidget {
  const JaguarPage({super.key});

  @override
  State<JaguarPage> createState() => _JaguarPageState();
}

class _JaguarPageState extends State<JaguarPage> {
  final FlutterTts flutterTts = FlutterTts();

  Future<void> speakText() async {
    await flutterTts.setLanguage('es-MX');       // Español de México
    await flutterTts.setPitch(1.3);              // Más agudo (alegre)
    await flutterTts.setSpeechRate(0.9);         // Más rápido
    await flutterTts.setVolume(1.0);             // Volumen completo
    await flutterTts.speak('¡Aprendamos con LetrAI!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'imagen/jaguar.png',
              height: 250,
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Color(0xFFFF6B00),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Aprendamos con\nLetrAI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await speakText(); // Reproduce el texto
                      Navigator.pushNamed(context, '/sesion'); // Navega a la siguiente pantalla
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade400,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(18),
                      elevation: 5,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

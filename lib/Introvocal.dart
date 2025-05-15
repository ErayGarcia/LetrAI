import 'package:flutter/material.dart';

class IntroVocal extends StatelessWidget {
  final int idUsuario;

  const IntroVocal({super.key, required this.idUsuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Introducción a las Vocales'),
        backgroundColor: const Color(0xFFE95227),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido a la introducción de las vocales.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aquí aprenderás sobre el sonido y uso de las vocales.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí se puede agregar la lógica para avanzar a la lección o el siguiente paso
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE95227), // Uso de backgroundColor
              ),
              child: const Text('Comenzar'),
            ),
          ],
        ),
      ),
    );
  }
}

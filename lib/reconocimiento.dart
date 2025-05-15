import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'matematicas.dart'; // Asegúrate de importar el archivo matematicas.dart
import 'db.dart';

class Reconocimiento extends StatefulWidget {
  final int idUsuario;
  final int idModulo;  // Asegúrate de pasar el idModulo al widget

  const Reconocimiento({super.key, required this.idUsuario, required this.idModulo});

  @override
  State<Reconocimiento> createState() => _ReconocimientoState();
}

class _ReconocimientoState extends State<Reconocimiento> {
  final FlutterTts tts = FlutterTts();
  String textoEnPantalla = "";
  bool leccionDesbloqueada = false;

  final List<Map<String, dynamic>> dinero = [
    {'imagen': 'imagen/dinero/1.jpg', 'texto': 'Un peso'},
    {'imagen': 'imagen/dinero/2.jpg', 'texto': 'Dos pesos'},
    {'imagen': 'imagen/dinero/5.jpg', 'texto': 'Cinco pesos'},
    {'imagen': 'imagen/dinero/10.jpg', 'texto': 'Diez pesos'},
    {'imagen': 'imagen/dinero/20.jpg', 'texto': 'Veinte pesos'},
    {'imagen': 'imagen/dinero/50.jpg', 'texto': 'Cincuenta pesos'},
    {'imagen': 'imagen/dinero/100.jpg', 'texto': 'Cien pesos'},
    {'imagen': 'imagen/dinero/200.jpg', 'texto': 'Doscientos pesos'},
    {'imagen': 'imagen/dinero/500.jpg', 'texto': 'Quinientos pesos'},
    {'imagen': 'imagen/dinero/1000.jpeg', 'texto': 'Mil pesos'},
  ];

  Future<void> _hablarConTexto(String texto) async {
    await tts.setLanguage("es-MX");
    await tts.setPitch(1);
    await tts.setSpeechRate(0.5);
    _escribirTextoLento(texto);
    await tts.speak(texto);
  }

  Future<void> _escribirTextoLento(String texto) async {
    textoEnPantalla = "";
    for (int i = 0; i < texto.length; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        textoEnPantalla += texto[i];
      });
    }
  }

  // Actualizar progreso en la base de datos
  Future<void> _actualizarProgreso() async {
    // Aquí asignamos el porcentaje a 100 cuando la lección está completa
    final porcentaje = 100.0;
    await DBHelper().actualizarProgresoModulo(
      widget.idUsuario,
      widget.idModulo,
      porcentaje,
    );
  }

  void _completarLeccion() {
    setState(() {
      leccionDesbloqueada = true;
    });
    _actualizarProgreso(); // Actualizamos el progreso al 100%
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      _hablarConTexto(
        'Vamos a conocer los billetes y monedas. Toca cada imagen para escuchar su valor. Luego, presiona el botón verde para practicar.',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reconocimiento de Números y Billetes'),
        backgroundColor: const Color(0xFF84BA40),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => _hablarConTexto('Vamos a conocer los billetes y monedas. Toca cada imagen para escuchar su valor. Luego, presiona el botón verde para practicar.'),
                  child: Image.asset('imagen/jaguar.png', height: 80),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 200, // Reducir el ancho del cuadro
                    child: Text(
                      textoEnPantalla,
                      style: const TextStyle(fontSize: 10), // Reducir el tamaño de la fuente
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 15,
              runSpacing: 15,
              children: dinero.map((item) {
                return GestureDetector(
                  onTap: () => _hablarConTexto(item['texto']),
                  child: Image.asset(item['imagen'], width: 100, height: 75),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.play_circle, size: 60, color: Colors.green),
                onPressed: () {
                  _completarLeccion();  // Completar la lección y actualizar el progreso
                  if (leccionDesbloqueada) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Matematicas(idUsuario: widget.idUsuario),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

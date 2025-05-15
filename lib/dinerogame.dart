import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'juegos.dart';

class JuegoDeDinero extends StatefulWidget {
  final int idUsuario;

  const JuegoDeDinero({super.key, required this.idUsuario});

  @override
  _JuegoDeDineroState createState() => _JuegoDeDineroState();
}

class _JuegoDeDineroState extends State<JuegoDeDinero> {
  final FlutterTts tts = FlutterTts();
  int errores = 0;
  int indicePregunta = 0;
  bool leccionTerminada = false;

  final List<Map<String, dynamic>> dinero = [
    {'valor': 1, 'imagen': 'imagen/dinero/1.jpg'},
    {'valor': 2, 'imagen': 'imagen/dinero/2.jpg'},
    {'valor': 5, 'imagen': 'imagen/dinero/5.jpg'},
    {'valor': 10, 'imagen': 'imagen/dinero/10.jpg'},
    {'valor': 20, 'imagen': 'imagen/dinero/20.jpg'},
    {'valor': 50, 'imagen': 'imagen/dinero/50.jpg'},
    {'valor': 100, 'imagen': 'imagen/dinero/100.jpg'},
    {'valor': 200, 'imagen': 'imagen/dinero/200.jpg'},
    {'valor': 500, 'imagen': 'imagen/dinero/500.jpg'},
    {'valor': 1000, 'imagen': 'imagen/dinero/1000.jpeg'},
  ];

  late List<Map<String, dynamic>> preguntas;
  late Map<String, dynamic> preguntaActual;
  late List<Map<String, dynamic>> opcionesActuales;

  @override
  void initState() {
    super.initState();
    _iniciarLeccion();
  }

  void _iniciarLeccion() {
    setState(() {
      errores = 0;
      indicePregunta = 0;
      leccionTerminada = false;
      preguntas = List<Map<String, dynamic>>.from(dinero)..shuffle();
      preguntas = preguntas.take(6).toList();
      _cargarPregunta();
    });
  }

  void _cargarPregunta() {
    preguntaActual = preguntas[indicePregunta];

    final List<Map<String, dynamic>> otrasOpciones = List<Map<String, dynamic>>.from(dinero)
      ..removeWhere((b) => b['valor'] == preguntaActual['valor'])
      ..shuffle();

    opcionesActuales = [preguntaActual, otrasOpciones[0], otrasOpciones[1]]..shuffle();

    _hablar("Selecciona el billete de ${preguntaActual['valor']} pesos.");
  }

  Future<void> _hablar(String texto) async {
    await tts.setLanguage("es-MX");
    await tts.setPitch(1);
    await tts.setSpeechRate(0.5);
    await tts.speak(texto);
  }

  void _revisarRespuesta(Map<String, dynamic> seleccion) {
    if (seleccion['valor'] != preguntaActual['valor']) {
      errores++;
    }

    if (indicePregunta < preguntas.length - 1) {
      setState(() {
        indicePregunta++;
        _cargarPregunta();
      });
    } else {
      setState(() {
        leccionTerminada = true;
      });
      _hablar("Lección terminada.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego de Reconocimiento de Dinero'),
        backgroundColor: const Color(0xFF84BA40),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!leccionTerminada) ...[
                GestureDetector(
                  onTap: () => _hablar("Selecciona el billete de ${preguntaActual['valor']} pesos."),
                  child: Column(
                    children: [
                      Image.asset('imagen/jaguar.png', width: 180, height: 180),
                      const SizedBox(height: 10),
                      const Icon(Icons.volume_up, size: 50, color: Colors.blue),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Selecciona el billete de ${preguntaActual['valor']} pesos",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.center,
                  children: opcionesActuales.map((opcion) {
                    return GestureDetector(
                      onTap: () => _revisarRespuesta(opcion),
                      child: Image.asset(opcion['imagen'], width: 120, height: 80),
                    );
                  }).toList(),
                ),
              ] else ...[
                const Icon(Icons.check_circle, size: 100, color: Colors.green),
                const SizedBox(height: 30),
                Text(
                  errores == 0
                      ? "La lección ha sido completada.\nPresiona el botón."
                      : "La lección ha sido completada.\nTuviste algunos errores.\nPresiona el botón.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: errores == 0
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Juegos(idUsuario: widget.idUsuario), // Pasamos el idUsuario aquí
                            ),
                          );
                        }
                      : () {
                          _iniciarLeccion();
                        },
                  child: Text(errores == 0 ? "Volver a Inicio" : "Reintentar"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

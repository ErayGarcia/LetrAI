import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class JuegoColores extends StatefulWidget {
  final int idUsuario;

  const JuegoColores({super.key, required this.idUsuario});

  @override
  State<JuegoColores> createState() => _JuegoColoresState();
}

class _JuegoColoresState extends State<JuegoColores> {
  final FlutterTts flutterTts = FlutterTts();

  List<Map<String, dynamic>> preguntas = [
    {
      'objeto': 'casa',
      'imagen': 'imagen/fotos/casa.png',
      'colorCorrecto': 'Azul',
      'opciones': ['Rojo', 'Azul', 'Verde']
    },
    {
      'objeto': 'carro',
      'imagen': 'imagen/fotos/coche.png',
      'colorCorrecto': 'Rojo',
      'opciones': ['Rojo', 'Amarillo', 'Negro']
    },
    {
      'objeto': 'manzana',
      'imagen': 'imagen/fotos/mandarina.png',
      'colorCorrecto': 'Rojo',
      'opciones': ['Verde', 'Rojo', 'Azul']
    },
    {
      'objeto': 'sol',
      'imagen': 'imagen/fotos/perro.png',
      'colorCorrecto': 'Amarillo',
      'opciones': ['Amarillo', 'Azul', 'Gris']
    },
    {
      'objeto': 'hoja',
      'imagen': 'imagen/fotos/hoja.png',
      'colorCorrecto': 'Verde',
      'opciones': ['Café', 'Verde', 'Negro']
    },
  ];

  int preguntaActual = 0;
  int errores = 0;
  bool juegoTerminado = false;
  bool puedeSeleccionar = false;

  @override
  void initState() {
    super.initState();
    _instruccionInicial();
  }

  Future<void> _instruccionInicial() async {
    await flutterTts.setLanguage('es-MX');
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.4);

    final objeto = preguntas[preguntaActual]['objeto'];

    await flutterTts.speak(
        "En este juego tendrás que observar la imagen y seleccionar uno de los botones con el color que corresponde.");
    await flutterTts.awaitSpeakCompletion(true);

    await flutterTts.speak("Por ejemplo, en esta imagen debes observar de qué color es el $objeto.");
    await flutterTts.awaitSpeakCompletion(true);

    await _decirPreguntaYColores();
  }

  Future<void> _decirPreguntaYColores() async {
    final pregunta = preguntas[preguntaActual];

    await flutterTts.speak("¿De qué color es el o la ${pregunta['objeto']}?");
    await flutterTts.awaitSpeakCompletion(true);

    for (String color in pregunta['opciones']) {
      await flutterTts.speak(color);
      await flutterTts.awaitSpeakCompletion(true);
    }

    setState(() {
      puedeSeleccionar = true;
    });
  }

  Future<void> verificarRespuesta(String seleccion) async {
    if (!puedeSeleccionar) return;

    setState(() {
      puedeSeleccionar = false;
    });

    final colorCorrecto = preguntas[preguntaActual]['colorCorrecto'];

    if (seleccion == colorCorrecto) {
      await flutterTts.speak("Muy bien. Ese es el color correcto.");
      await flutterTts.awaitSpeakCompletion(true);
    } else {
      errores++;
    }

    if (preguntaActual + 1 < preguntas.length) {
      setState(() {
        preguntaActual++;
      });
      await _instruccionInicial();
    } else {
      setState(() {
        juegoTerminado = true;
      });
      await _decirResultadoFinal();
    }
  }

  Future<void> _decirResultadoFinal() async {
    if (errores == 0) {
      await flutterTts.speak("¡Felicidades! Completaste el juego sin errores.");
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak("Presiona el botón de inicio para regresar a casa.");
    } else {
      await flutterTts.speak("Tuviste $errores errores. Puedes volver a intentarlo presionando el botón de reiniciar.");
    }
  }

  void reiniciarJuego() {
    setState(() {
      preguntaActual = 0;
      errores = 0;
      juegoTerminado = false;
      puedeSeleccionar = false;
    });
    _instruccionInicial();
  }

  void irAInicio() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (juegoTerminado) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Resultado del Juego'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset('imagen/leccion.png', height: 150),
              ),
              const SizedBox(height: 20),
              Text(
                errores == 0
                    ? '¡Felicidades! No cometiste errores.'
                    : 'Tuviste $errores errores.',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (errores == 0)
                    IconButton(
                      onPressed: irAInicio,
                      icon: const Icon(Icons.home, size: 40, color: Colors.blue),
                    ),
                  if (errores != 0)
                    IconButton(
                      onPressed: reiniciarJuego,
                      icon: const Icon(Icons.refresh, size: 40, color: Colors.orange),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final pregunta = preguntas[preguntaActual];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Colores'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset(pregunta['imagen'], height: 200)),
            const SizedBox(height: 30),
            const Text(
              '¿De qué color es?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Column(
              children: pregunta['opciones'].map<Widget>((opcion) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: puedeSeleccionar ? () => verificarRespuesta(opcion) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      minimumSize: const Size(200, 50),
                    ),
                    child: Text(
                      opcion,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

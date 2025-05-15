import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Gamearrastrar extends StatefulWidget {
  final int idUsuario;

  const Gamearrastrar({super.key, required this.idUsuario});

  @override
  State<Gamearrastrar> createState() => _JuegoArrastrarSilabasState();
}

class _JuegoArrastrarSilabasState extends State<Gamearrastrar> {
  final FlutterTts flutterTts = FlutterTts();

  List<Map<String, dynamic>> juegos = [
    {
      'palabra': 'ratón',
      'imagen': 'imagen/fotos/raton.png',
      'silabas': ['ra', 'tón'],
      'distractoras': ['ca', 'po']
    },
    {
      'palabra': 'barco',
      'imagen': 'imagen/fotos/barco.png',
      'silabas': ['bar', 'co'],
      'distractoras': ['re', 'mi']
    },
    {
      'palabra': 'coche',
      'imagen': 'imagen/fotos/coche.png',
      'silabas': ['co', 'che'],
      'distractoras': ['ca', 'rro']
    },
    {
      'palabra': 'caja',
      'imagen': 'imagen/fotos/caja.png',
      'silabas': ['ca', 'ja'],
      'distractoras': ['to', 'sa']
    },
    {
      'palabra': 'bota',
      'imagen': 'imagen/fotos/bota.png',
      'silabas': ['bo', 'ta'],
      'distractoras': ['co', 'sa']
    },
    {
      'palabra': 'dedo',
      'imagen': 'imagen/fotos/dedo.png',
      'silabas': ['de', 'do'],
      'distractoras': ['se', 'ca']
    },
    {
      'palabra': 'dulce',
      'imagen': 'imagen/fotos/dulce.png',
      'silabas': ['dul', 'ce'],
      'distractoras': ['se', 'dal']
    },
    {
      'palabra': 'helado',
      'imagen': 'imagen/fotos/helado.png',
      'silabas': ['he', 'la', 'do'],
      'distractoras': ['je', 'le']
    },
    {
      'palabra': 'laguna',
      'imagen': 'imagen/fotos/laguna.png',
      'silabas': ['la', 'gu', 'na'],
      'distractoras': ['sa', 'ju']
    },
  ];

  int juegoActualIndex = 0;
  List<String> silabasDisponibles = [];
  List<String?> silabasJugador = [];
  int errores = 0;
  bool juegoTerminado = false;

  @override
  void initState() {
    super.initState();
    iniciarJuego();
    _decirBienvenida();
  }

  void iniciarJuego() {
    final juego = juegos[juegoActualIndex];
    silabasJugador = List.filled(juego['silabas'].length, null);
    silabasDisponibles = [...juego['silabas'], ...juego['distractoras']];
    silabasDisponibles.shuffle();
  }

  Future<void> _decirBienvenida() async {
    await flutterTts.setLanguage('es-MX');
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak("¡Hola, usuario ${widget.idUsuario}! Vamos a comenzar con un juego de sílabas.");
    await flutterTts.speak("Arrastra las sílabas correctas para formar la palabra completa.");
  }

  Future<void> _decirInstrucciones() async {
    await flutterTts.speak("Toca la imagen para ver las instrucciones.");
  }

  void verificarCompletado() {
    if (silabasJugador.contains(null)) return; // No avanzar si hay espacios vacíos

    final juego = juegos[juegoActualIndex];
    if (!_compararListas(silabasJugador.cast<String>(), juego['silabas'])) {
      errores++;
    }
    siguienteJuego();
  }

  bool _compararListas(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void siguienteJuego() {
    if (juegoActualIndex + 1 < juegos.length) {
      setState(() {
        juegoActualIndex++;
        iniciarJuego();
      });
    } else {
      setState(() {
        juegoTerminado = true;
      });
      _decirResultadoFinal();
    }
  }

  void _decirResultadoFinal() async {
    if (errores == 0) {
      await flutterTts.speak("¡Felicidades! Completaste el juego sin errores.");
    } else {
      await flutterTts.speak("Tuviste $errores errores. Vuelve a intentarlo.");
    }
    await flutterTts.speak("Si deseas continuar, presiona el icono de la casa.");
    await flutterTts.speak("Si quieres reiniciar, presiona el botón de reiniciar.");
  }

  void reiniciarJuego() {
    setState(() {
      juegoActualIndex = 0;
      errores = 0;
      juegoTerminado = false;
      iniciarJuego();
    });
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
          title: const Text('Resultado Final'),
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
                child: Image.asset(
                  'imagen/leccion.png',
                  height: 150,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '¡Felicidades!',
                style: const TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                errores == 0
                    ? 'Completaste el juego sin errores.'
                    : 'Tuviste $errores errores. Vuelve a intentarlo.',
                style: const TextStyle(
                  fontSize: 22,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (errores == 0)
                    IconButton(
                      onPressed: irAInicio,
                      icon: const Icon(
                        Icons.home,
                        size: 40,
                        color: Colors.blueAccent,
                      ),
                    ),
                  const SizedBox(width: 50),
                  IconButton(
                    onPressed: reiniciarJuego,
                    icon: const Icon(
                      Icons.refresh,
                      size: 40,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final juegoActual = juegos[juegoActualIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Juego de sílabas (Usuario: ${widget.idUsuario})'),
        backgroundColor: Colors.blueAccent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _decirInstrucciones,
                        child: Image.asset(juegoActual['imagen'], height: 200),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(juegoActual['silabas'].length, (index) {
                          return DragTarget<String>(
                            onAccept: (data) {
                              setState(() {
                                // Si ya hay una sílaba en ese espacio, se devuelve a las disponibles
                                if (silabasJugador[index] != null) {
                                  silabasDisponibles.add(silabasJugador[index]!);
                                }
                                silabasJugador[index] = data;
                                silabasDisponibles.remove(data);
                              });
                              verificarCompletado();
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                width: 80,
                                height: 60,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  silabasJugador[index] ?? '',
                                  style: const TextStyle(fontSize: 22),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 40),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: silabasDisponibles.map((silaba) {
                          return Draggable<String>(
                            data: silaba,
                            feedback: Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  silaba,
                                  style: const TextStyle(fontSize: 22, color: Colors.white),
                                ),
                              ),
                            ),
                            childWhenDragging: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                silaba,
                                style: const TextStyle(fontSize: 22, color: Colors.black45),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                silaba,
                                style: const TextStyle(fontSize: 22, color: Colors.white),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

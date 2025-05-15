import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'db.dart';

class ABC extends StatefulWidget {
  final int idUsuario;
  final int idModulo;

  const ABC({
    Key? key,
    required this.idUsuario,
    required this.idModulo,
  }) : super(key: key);

  @override
  State<ABC> createState() => _ABCState();
}

class _ABCState extends State<ABC> {
  final List<String> letras = List.generate(26, (i) => String.fromCharCode(65 + i));
  int indiceActual = 0;
  bool leccionCompletada = false;

  late FlutterTts flutterTts;

  final Map<String, String> nombresObjetos = {
    'A': 'ambulancia', 'B': 'burro', 'C': 'carro', 'D': 'doctor', 'E': 'edificio',
    'F': 'familia', 'G': 'gato', 'H': 'hielo', 'I': 'iglesia', 'J': 'jarra',
    'K': 'kilo', 'L': 'limon', 'M': 'mesa', 'N': 'nubes', 'O': 'ojo',
    'P': 'peine', 'Q': 'queso', 'R': 'raton', 'S': 'sol', 'T': 'tomate',
    'U': 'una', 'V': 'vaca', 'W': 'whatsapp', 'X': 'xochimilco', 'Y': 'yoyo', 'Z': 'zapato',
  };

  double get progreso => (indiceActual + 1) / letras.length;

  Future<void> _actualizarProgreso() async {
    final porcentaje = progreso * 100;
    await DBHelper().actualizarProgresoModulo(
      widget.idUsuario,
      widget.idModulo,
      porcentaje,
    );
  }

  void _avanzar() async {
    if (indiceActual < letras.length - 1) {
      setState(() {
        indiceActual++;
      });
      await _actualizarProgreso();
    } else if (!leccionCompletada) {
      await _actualizarProgreso();
      setState(() {
        leccionCompletada = true;
      });
      Future.delayed(const Duration(milliseconds: 300), _decirFinal);
    }
  }

  void _retroceder() {
    if (indiceActual > 0) {
      setState(() {
        indiceActual--;
      });
    }
  }

  Future<void> _configurarTTS() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("es-MX");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.3);
  }

  Future<void> _decirLetra() async {
    await _configurarTTS();
    String letra = letras[indiceActual];
    await flutterTts.speak("$letra");
  }

  Future<void> _decirObjeto() async {
    await _configurarTTS();
    String letra = letras[indiceActual];
    String objeto = nombresObjetos[letra] ?? '';
    await flutterTts.speak("$letra, es como $objeto");
  }

  Future<void> _decirLetraYObjeto() async {
    await _configurarTTS();
    String letra = letras[indiceActual];
    String objeto = nombresObjetos[letra] ?? '';
    await flutterTts.speak("$letra");
  }

  Future<void> _decirFinal() async {
    await _configurarTTS();
    await flutterTts.speak(
        "La lección ha sido completada con éxito. Si quieres continuar, presiona el botón verde. Y si quieres volver a repasar, presiona el botón naranja.");
  }

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _actualizarProgreso();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String letra = letras[indiceActual];
    String imagenLetra = 'imagen/letras/letra_${letra.toLowerCase()}.png';
    String nombreObjeto = nombresObjetos[letra] ?? '';
    String imagenObjeto = 'imagen/objetos/objeto_${nombreObjeto.toLowerCase()}.png';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE95227),
        centerTitle: true,
        title: const Text(
          'Ruta de aprendizaje',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: leccionCompletada
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('imagen/leccion.png', height: 150),
                const SizedBox(height: 30),
                Text(
                  '¡La lección ha sido completada!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                const SizedBox(height: 20),
                CircularPercentIndicator(
                  radius: 80.0,
                  lineWidth: 12.0,
                  animation: true,
                  percent: 1.0,
                  center: const Text(
                    "100%",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                  progressColor: const Color(0xFFE95227),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          indiceActual = 0;
                          leccionCompletada = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: const Icon(Icons.replay),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/inicio',
                          arguments: {'idUsuario': widget.idUsuario},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: const Icon(Icons.home),
                    ),
                  ],
                )
              ],
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      const Expanded(child: Text("Progreso")),
                      Text('${(progreso * 100).toInt()}%'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(
                    value: progreso,
                    backgroundColor: Colors.grey[300],
                    color: const Color(0xFFE95227),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _decirLetra,
                        child: Image.asset(imagenLetra, height: 120),
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        icon: const Icon(Icons.volume_up, size: 40, color: Colors.orange),
                        onPressed: _decirLetraYObjeto,
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _decirObjeto,
                        child: Image.asset(imagenObjeto, height: 120),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _retroceder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Icon(Icons.arrow_back),
                      ),
                      ElevatedButton(
                        onPressed: _avanzar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE95227),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

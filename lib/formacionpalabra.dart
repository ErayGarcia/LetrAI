import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'db.dart'; // Asegúrate de tener este import correcto
import 'formacion.dart'; // Pantalla de inicio

class FormacionPalabra extends StatefulWidget {
  final int idUsuario;
  final int idModulo;

  const FormacionPalabra({
    Key? key,
    required this.idUsuario,
    required this.idModulo,
  }) : super(key: key);

  @override
  State<FormacionPalabra> createState() => _FormacionPalabraState();
}

class _FormacionPalabraState extends State<FormacionPalabra> {
  int palabraIndex = 0;
  final FlutterTts flutterTts = FlutterTts();
  bool leccionCompletada = false;

  final List<String> listaPalabras = [
    'Casa', 'Cama', 'Silla', 'Gato', 'Perro', 'Flor',
    'Mesa', 'Luna', 'Mano', 'Pato', 'Rana', 'Sapo',
  ];

  final Map<String, String> silabas = {
    'Casa': 'Ca - sa',
    'Cama': 'Ca - ma',
    'Silla': 'Si - lla',
    'Gato': 'Ga - to',
    'Perro': 'Pe - rro',
    'Flor': 'Fl - or',
    'Mesa': 'Me - sa',
    'Luna': 'Lu - na',
    'Mano': 'Ma - no',
    'Pato': 'Pa - to',
    'Rana': 'Ra - na',
    'Sapo': 'Sa - po',
  };

  final Map<String, String> diccionarioPronunciacion = {
    'Ca': 'Ka', 'sa': 'sa', 'ma': 'ma',
    'Si': 'Si', 'lla': 'ya',
    'Ga': 'Ga', 'to': 'to',
    'Pe': 'Pe', 'rro': 'ro',
    'Fl': 'Fl', 'or': 'or',
    'Me': 'Me', 'Lu': 'Lu', 'na': 'na',
    'Ma': 'Ma', 'no': 'no',
    'Pa': 'Pa', 'Ra': 'Ra', 'Sa': 'Sa', 'po': 'po',
  };

  final Map<String, List<String>> imagenesRelacionadas = {
    'Casa': ['Cama', 'Silla'],
    'Cama': ['Perro', 'Flor'],
    'Silla': ['Casa', 'Gato'],
    'Gato': ['Flor', 'Cama'],
    'Perro': ['Casa', 'Gato'],
    'Flor': ['Silla', 'Perro'],
    'Mesa': ['Luna', 'Mano'],
    'Luna': ['Sapo', 'Rana'],
    'Mano': ['Pato', 'Mesa'],
    'Pato': ['Rana', 'Sapo'],
    'Rana': ['Pato', 'Luna'],
    'Sapo': ['Rana', 'Mano'],
  };

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage('es-MX');
    flutterTts.setSpeechRate(0.5);
    flutterTts.setPitch(1.0);
  }

  Future<void> reproducirSilabasYPalabra(String palabra) async {
    String? silabasSeparadas = silabas[palabra];
    if (silabasSeparadas != null) {
      final partes = silabasSeparadas.split(' - ');
      for (String s in partes) {
        final sonido = diccionarioPronunciacion[s] ?? s;
        await flutterTts.speak(sonido);
        await Future.delayed(const Duration(milliseconds: 500));
      }
      await flutterTts.speak(palabra);
    }
  }

  double get progreso => (palabraIndex + 1) / listaPalabras.length;

  Future<void> _actualizarProgreso() async {
    final porcentaje = progreso * 100;
    await DBHelper().actualizarProgresoModulo(
      widget.idUsuario,
      widget.idModulo,
      porcentaje,
    );
  }

  void _verificarFinalizacion() {
    if (palabraIndex == listaPalabras.length - 1) {
      setState(() {
        leccionCompletada = true;
      });
      _actualizarProgreso();
    }
  }

  void _reiniciarLeccion() {
    setState(() {
      palabraIndex = 0;
      leccionCompletada = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (leccionCompletada) {
      return Scaffold(
        backgroundColor: Colors.orange[50],
        body: Column(
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              progressColor: const Color(0xFFE95227),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _reiniciarLeccion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                  ),
                  icon: const Icon(Icons.refresh, size: 28),
                  label: const Text(
                    'Reiniciar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Formacion(
                          idUsuario: widget.idUsuario,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B050),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                  ),
                  icon: const Icon(Icons.home, size: 28),
                  label: const Text(
                    'Inicio',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    final palabraPrincipal = listaPalabras[palabraIndex];
    final relacionadas = imagenesRelacionadas[palabraPrincipal] ?? [];
    final palabrasMostrar = [palabraPrincipal, ...relacionadas];

    final silabasUnicas = palabrasMostrar
        .expand((p) => (silabas[p]?.split(' - ') ?? []))
        .toSet()
        .toList();

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text('Formación de Palabras'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 15,
              children: silabasUnicas.map((s) {
                return GestureDetector(
                  onTap: () async {
                    final sonido = diccionarioPronunciacion[s] ?? s;
                    await flutterTts.speak(sonido);
                  },
                  child: Text(
                    s,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: palabrasMostrar.map((p) {
                final String? silabasSeparadas = silabas[p];
                return GestureDetector(
                  onTap: () => reproducirSilabasYPalabra(p),
                  child: Column(
                    children: [
                      Image.asset(
                        'imagen/fotos/${p.toLowerCase()}.png',
                        height: 70,
                        width: 70,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 60),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.brown,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (silabasSeparadas != null) ...[
                        Text(
                          silabasSeparadas,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up,
                              size: 18, color: Colors.deepOrange),
                          onPressed: () => reproducirSilabasYPalabra(p),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'prev',
                  onPressed: () {
                    setState(() {
                      palabraIndex =
                          (palabraIndex - 1 + listaPalabras.length) %
                              listaPalabras.length;
                    });
                  },
                  backgroundColor: Colors.deepOrange,
                  child: const Icon(Icons.arrow_back),
                ),
                FloatingActionButton(
                  heroTag: 'next',
                  onPressed: () {
                    setState(() {
                      palabraIndex = (palabraIndex + 1);
                      if (palabraIndex >= listaPalabras.length) {
                        palabraIndex = listaPalabras.length - 1;
                      }
                      _verificarFinalizacion();
                    });
                  },
                  backgroundColor: Colors.deepOrange,
                  child: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

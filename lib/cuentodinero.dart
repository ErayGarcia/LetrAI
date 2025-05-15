import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'matematicas.dart'; // Asegúrate de importar el archivo matematicas.dart
import 'db.dart';

class CuantoDinero extends StatefulWidget {
  final int idUsuario;
  final int idModulo;

  const CuantoDinero({super.key, required this.idUsuario, required this.idModulo});

  @override
  State<CuantoDinero> createState() => _CuantoDineroState();
}

class _CuantoDineroState extends State<CuantoDinero> {
  final FlutterTts tts = FlutterTts();
  String textoEnPantalla = "";
  bool leccionDesbloqueada = false;
  bool puedePasarAlSiguienteEjercicio = false;

  final List<Map<String, dynamic>> dinero = [
    {'imagen': 'imagen/dinero/50.jpg', 'texto': 'Cincuenta pesos', 'valor': 50.0},
    {'imagen': 'imagen/dinero/20.jpg', 'texto': 'Veinte pesos', 'valor': 20.0},
  ];

  List<Map<String, dynamic>> billetesSeleccionados = [];
  double totalDinero = 0.0;

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

  Future<void> _actualizarProgreso() async {
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
    _actualizarProgreso(); 
  }

  void _agregarBillete(Map<String, dynamic> billete) {
    if (billetesSeleccionados.length < 3) {
      setState(() {
        billetesSeleccionados.add(billete);
        totalDinero += billete['valor'];
      });
    }

    if (billetesSeleccionados.length == 3) {
      _hablarConTexto('El total es: \$${totalDinero.toStringAsFixed(2)}').then((_) {
        setState(() {
          puedePasarAlSiguienteEjercicio = true; // Activar el botón cuando se complete la voz
        });
      });
    }
  }

  void _reiniciar() {
    setState(() {
      billetesSeleccionados.clear();
      totalDinero = 0.0;
      puedePasarAlSiguienteEjercicio = false; // Deshabilitar el botón al reiniciar
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      _hablarConTexto(
        'Vamos a conocer cuánto dinero tienes. Arrastra los billetes al cuadro y presiona el botón verde para calcular el total.',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuánto Dinero Tienes'),
        backgroundColor: const Color(0xFF84BA40),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => _hablarConTexto('Vamos a conocer cuánto dinero tienes. Arrastra los billetes al cuadro y presiona el botón verde para calcular el total.'),
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
                    width: 200,
                    child: Text(
                      textoEnPantalla,
                      style: const TextStyle(fontSize: 10),
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
                return Draggable<Map<String, dynamic>>(
                  data: item,
                  child: Image.asset(item['imagen'], width: 100, height: 75),
                  feedback: Image.asset(item['imagen'], width: 100, height: 75),
                  childWhenDragging: Container(),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            DragTarget<Map<String, dynamic>>(
              onAccept: (billete) {
                _agregarBillete(billete);
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Arrastra los billetes aquí\nTotal: \$${totalDinero.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            const Spacer(),
            if (puedePasarAlSiguienteEjercicio) // Mostrar botón solo cuando se pueda pasar al siguiente ejercicio
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: const Icon(Icons.play_circle, size: 60, color: Colors.green),
                  onPressed: () {
                    _completarLeccion();  // Completar la lección y actualizar el progreso
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Matematicas(idUsuario: widget.idUsuario),
                      ),
                    );
                  },
                ),
              ),
            ElevatedButton(
              onPressed: _reiniciar,
              child: const Text('Reiniciar'),
            ),
          ],
        ),
      ),
    );
  }
}

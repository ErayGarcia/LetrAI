import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'matematicas.dart';
import 'db.dart';

class PagoServiciosExacto extends StatefulWidget {
  final int idUsuario;
  final int idModulo;

  const PagoServiciosExacto({super.key, required this.idUsuario, required this.idModulo});

  @override
  State<PagoServiciosExacto> createState() => _PagoServiciosExactoState();
}

class _PagoServiciosExactoState extends State<PagoServiciosExacto> {
  final FlutterTts tts = FlutterTts();
  String textoEnPantalla = "";
  bool puedePasar = false;
  double totalPagado = 0.0;
  int indiceServicio = 0;

  final List<Map<String, dynamic>> servicios = [
    {'nombre': 'Servicio de Agua', 'precio': 300.0, 'imagen': 'imagen/servicios/agua.jpg'},
    {'nombre': 'Servicio de Luz', 'precio': 800.0, 'imagen': 'imagen/servicios/luz.jpg'},
    {'nombre': 'Servicio de Teléfono', 'precio': 700.0, 'imagen': 'imagen/servicios/telefono.jpg'},
  ];

  final List<Map<String, dynamic>> billetes = [
    {'imagen': 'imagen/dinero/100.jpg', 'texto': 'Cien pesos', 'valor': 100.0},
    {'imagen': 'imagen/dinero/200.jpg', 'texto': 'Doscientos pesos', 'valor': 200.0},
    {'imagen': 'imagen/dinero/500.jpg', 'texto': 'Quinientos pesos', 'valor': 500.0},
  ];

  List<Map<String, dynamic>> seleccionados = [];

  Future<void> _hablar(String texto) async {
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
    await DBHelper().actualizarProgresoModulo(widget.idUsuario, widget.idModulo, porcentaje);
  }

  void _agregarBillete(Map<String, dynamic> billete) {
    setState(() {
      if (seleccionados.length < 3 && totalPagado + billete['valor'] <= servicios[indiceServicio]['precio']) {
        seleccionados.add(billete);
        totalPagado += billete['valor'];
      }
    });

    if (totalPagado == servicios[indiceServicio]['precio']) {
      _hablar('Muy bien. Has pagado exactamente \$${totalPagado.toStringAsFixed(2)}.').then((_) {
        setState(() {
          if (indiceServicio < servicios.length - 1) {
            indiceServicio++;
            totalPagado = 0.0;
            seleccionados.clear();
            Future.delayed(const Duration(milliseconds: 500), () {
              _hablar(
                  'Este servicio cuesta ${servicios[indiceServicio]['precio']} pesos. Usa hasta tres billetes para pagar el monto exacto.');
            });
          } else {
            puedePasar = true;
          }
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      _hablar(
          'Este servicio cuesta ${servicios[indiceServicio]['precio']} pesos. Usa hasta tres billetes para pagar el monto exacto.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final servicio = servicios[indiceServicio];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paga el servicio exacto'),
        backgroundColor: const Color(0xFF84BA40),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => _hablar('Este servicio cuesta ${servicio['precio']} pesos.'),
                  child: Image.asset('imagen/jaguar.png', height: 80),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      textoEnPantalla,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// Servicio
            Column(
              children: [
                Image.asset(servicio['imagen'], width: 100),
                Text(servicio['nombre'], style: const TextStyle(fontSize: 20)),
                Text('Precio: \$${servicio['precio']}', style: const TextStyle(fontSize: 16)),
              ],
            ),

            const SizedBox(height: 20),

            /// Billetes disponibles
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 15,
              runSpacing: 15,
              children: billetes.map((item) {
                return Draggable<Map<String, dynamic>>(
                  data: item,
                  child: Image.asset(item['imagen'], width: 90),
                  feedback: Image.asset(item['imagen'], width: 90),
                  childWhenDragging: Opacity(
                    opacity: 0.5,
                    child: Image.asset(item['imagen'], width: 90),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// Zona de pago
            DragTarget<Map<String, dynamic>>(
              onAccept: _agregarBillete,
              builder: (context, _, __) {
                return Container(
                  width: 250,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Zona de pago', style: TextStyle(fontSize: 16)),
                      Text('Total pagado: \$${totalPagado.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16)),
                      Text('Billetes usados: ${seleccionados.length}/3',
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                );
              },
            ),

            const Spacer(),

            /// Botón continuar solo al final
            if (puedePasar)
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: const Icon(Icons.play_circle, size: 60, color: Colors.green),
                  onPressed: () {
                    _actualizarProgreso();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Matematicas(idUsuario: widget.idUsuario),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'matematicas.dart';
import 'db.dart';

class MontoExacto extends StatefulWidget {
  final int idUsuario;
  final int idModulo;

  const MontoExacto({super.key, required this.idUsuario, required this.idModulo});

  @override
  State<MontoExacto> createState() => _MontoExactoState();
}

class _MontoExactoState extends State<MontoExacto> {
  final FlutterTts tts = FlutterTts();
  String textoEnPantalla = "";
  bool puedePasar = false;
  double totalPagado = 0.0;
  int indiceProducto = 0;

  final List<Map<String, dynamic>> productos = [
    {'nombre': 'Jugo', 'precio': 13.0, 'imagen': 'imagen/producto/jugo.png'},
    {'nombre': 'Pan', 'precio': 7.0, 'imagen': 'imagen/producto/pan.png'},
    {'nombre': 'Manzana', 'precio': 5.0, 'imagen': 'imagen/producto/manzana.png'},
  ];

  final List<Map<String, dynamic>> monedas = [
    {'imagen': 'imagen/dinero/10.jpg', 'texto': 'Diez pesos', 'valor': 10.0},
    {'imagen': 'imagen/dinero/2.jpg', 'texto': 'Dos pesos', 'valor': 2.0},
    {'imagen': 'imagen/dinero/1.jpg', 'texto': 'Un peso', 'valor': 1.0},
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

  void _agregarMoneda(Map<String, dynamic> moneda) {
    setState(() {
      if (totalPagado + moneda['valor'] <= productos[indiceProducto]['precio']) {
        seleccionados.add(moneda);
        totalPagado += moneda['valor'];
      }
    });

    if (totalPagado == productos[indiceProducto]['precio']) {
      _hablar('Muy bien. Has pagado exactamente \$${totalPagado.toStringAsFixed(2)}.')
          .then((_) {
        setState(() {
          if (indiceProducto < productos.length - 1) {
            indiceProducto++;
            totalPagado = 0.0;
            seleccionados.clear();
            Future.delayed(const Duration(milliseconds: 500), () {
              _hablar(
                  'Este producto cuesta ${productos[indiceProducto]['precio']} pesos. Usa las monedas para pagar el monto exacto.');
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
          'Este producto cuesta ${productos[indiceProducto]['precio']} pesos. Usa las monedas para pagar el monto exacto.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final producto = productos[indiceProducto];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paga con el monto exacto'),
        backgroundColor: const Color(0xFF84BA40),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => _hablar('Este producto cuesta ${producto['precio']} pesos.'),
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

            /// Producto
            Column(
              children: [
                Image.asset(producto['imagen'], width: 100),
                Text(producto['nombre'], style: const TextStyle(fontSize: 20)),
                Text('Precio: \$${producto['precio']}', style: const TextStyle(fontSize: 16)),
              ],
            ),

            const SizedBox(height: 20),

            /// Monedas disponibles
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 15,
              runSpacing: 15,
              children: monedas.map((item) {
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
              onAccept: _agregarMoneda,
              builder: (context, _, __) {
                return Container(
                  width: 250,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Zona de pago\nTotal pagado: \$${totalPagado.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
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

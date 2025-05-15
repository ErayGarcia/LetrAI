import 'package:flutter/material.dart';
import 'db.dart';
import 'inicio.dart';
import 'matematicas.dart';
import 'juegos.dart';
import 'perfil.dart';

class Progreso extends StatefulWidget {
  final int idUsuario;

  const Progreso({super.key, required this.idUsuario});

  @override
  State<Progreso> createState() => _ProgresoState();
}

class _ProgresoState extends State<Progreso> {
  double progresoVocales = 0.0;
  double progresoAbecedario = 0.0;
  double progresoNumeros = 0.0;
  double progresoModulo4 = 0.0;
  double progresoModulo5 = 0.0;
  double progresoModulo6 = 0.0;

  final int idModuloVocales = 1;
  final int idModuloAbecedario = 2;
  final int idModuloNumeros = 3;
  final int idModulo4 = 4;
  final int idModulo5 = 5;
  final int idModulo6 = 6;

  @override
  void initState() {
    super.initState();
    _cargarProgreso();
  }

  Future<void> _cargarProgreso() async {
    double? p1 = await DBHelper().obtenerProgresoModulo(widget.idUsuario, idModuloVocales);
    double? p2 = await DBHelper().obtenerProgresoModulo(widget.idUsuario, idModuloAbecedario);
    double? p3 = await DBHelper().obtenerProgresoModulo(widget.idUsuario, idModuloNumeros);
    double? p4 = await DBHelper().obtenerProgresoModulo(widget.idUsuario, idModulo4);
    double? p5 = await DBHelper().obtenerProgresoModulo(widget.idUsuario, idModulo5);
    double? p6 = await DBHelper().obtenerProgresoModulo(widget.idUsuario, idModulo6);

    setState(() {
      progresoVocales = (p1 ?? 0) / 100;
      progresoAbecedario = (p2 ?? 0) / 100;
      progresoNumeros = (p3 ?? 0) / 100;
      progresoModulo4 = (p4 ?? 0) / 100;
      progresoModulo5 = (p5 ?? 0) / 100;
      progresoModulo6 = (p6 ?? 0) / 100;
    });
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == 3) return;
    Widget destino;

    switch (index) {
      case 0:
        destino = Inicio(idUsuario: widget.idUsuario);
        break;
      case 1:
        destino = Matematicas(idUsuario: widget.idUsuario);
        break;
      case 2:
        destino = Juegos(idUsuario: widget.idUsuario);
        break;
      case 4:
        destino = Perfil(idUsuario: widget.idUsuario);
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destino),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                color: Color(0xFF878A5F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Center(
                child: Text(
                  'Progreso',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildModulo("Vocales", progresoVocales, 'imagen/vocal.png'),
                    _buildModulo("Abecedario", progresoAbecedario, 'imagen/abc.png'),
                    _buildModulo("Palabras Generadoras", progresoNumeros, 'imagen/palabras.png'),
                    _buildModulo("Separación de silabas", progresoModulo4, 'imagen/silabas.png'),
                    _buildModulo("Formacion de nuevas palabras", progresoModulo5, 'imagen/formapa.png'),
                    _buildModulo("Construccion de frases ", progresoModulo6, 'imagen/vista.png'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: (index) => _onItemTapped(context, index),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        items: [
          BottomNavigationBarItem(icon: Image.asset('imagen/libro.png', height: 30), label: ''),
          BottomNavigationBarItem(icon: Image.asset('imagen/lapiz.png', height: 30), label: ''),
          BottomNavigationBarItem(icon: Image.asset('imagen/juegos.png', height: 30), label: ''),
          BottomNavigationBarItem(icon: Image.asset('imagen/trofeo.png', height: 30), label: ''),
          BottomNavigationBarItem(icon: Image.asset('imagen/perfil.png', height: 30), label: ''),
        ],
      ),
    );
  }

  Widget _buildModulo(String nombre, double progreso, String rutaImagen) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Image.asset(rutaImagen, height: 60)),
            const SizedBox(height: 8),
            Text(nombre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progreso,
                    backgroundColor: Colors.grey[300],
                    color: Color(0xFFE95227),
                    minHeight: 20,
                  ),
                ),
                Text(
                  '${(progreso * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'inicio.dart';
import 'matematicas.dart';
import 'juegos.dart';
import 'progreso.dart';
import 'perfil.dart';
import 'db.dart';
import 'palabragene.dart';
import 'separacionsilabas.dart'; // Importación agregada
import 'formacionpalabra.dart'; // Importación de la nueva pantalla
import 'construccion.dart'; // Importación de la nueva pantalla

class Formacion extends StatefulWidget {
  final int idUsuario;

  const Formacion({super.key, required this.idUsuario});

  @override
  State<Formacion> createState() => _FormacionState();
}

class _FormacionState extends State<Formacion> {
  int _selectedIndex = 0;
  final FlutterTts flutterTts = FlutterTts();
  String nombreUsuario = '';

  @override
  void initState() {
    super.initState();
    _obtenerNombre();
  }

  Future<void> _obtenerNombre() async {
    final nombre = await DBHelper().obtenerNombreUsuario(widget.idUsuario);
    setState(() {
      nombreUsuario = nombre;
    });
    await _hablar();
  }

  Future<void> _hablar() async {
    await flutterTts.setLanguage('es-MX');
    await flutterTts.setPitch(1.3);
    await flutterTts.setSpeechRate(0.9);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak('Bienvenido Presiona el boton naranja para comenzar la leccion');
  }

  void _onItemTapped(int index) {
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
      case 3:
        destino = Progreso(idUsuario: widget.idUsuario);
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                color: Color(0xFFE95227),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Center(
                child: Text(
                  'Ruta de aprendizaje',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _hablar,
              child: Image.asset('imagen/jaguar.png', height: 120),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildCard(
                    imagePath: 'imagen/palabra.png',
                    title: 'Palabra Generadora',
                    buttonText: 'Comenzar',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AprenderPalabra(
                            idUsuario: widget.idUsuario,
                            idModulo: 3,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildCard(
                    imagePath: 'imagen/silabas.png',
                    title: 'Separación de sílabas',
                    buttonText: 'Comenzar',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeparacionSilabas(
                            idUsuario: widget.idUsuario,
                            idModulo: 4,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildCard(
                    imagePath: 'imagen/formapa.png',
                    title: 'Formación de nuevas palabras',
                    buttonText: 'Comenzar',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormacionPalabra(
                            idUsuario: widget.idUsuario,
                            idModulo: 5,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildCard(
                    imagePath: 'imagen/vista.png',
                    title: 'Construcción de frases cortas',
                    buttonText: 'Comenzar',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Construccion(
                            idUsuario: widget.idUsuario,
                            idModulo: 6,  // Puedes asignar un id de módulo adecuado
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFE95227),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('imagen/libro.png', height: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('imagen/lapiz.png', height: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('imagen/juegos.png', height: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('imagen/trofeo.png', height: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('imagen/perfil.png', height: 30),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String imagePath,
    required String title,
    required String buttonText,
    required VoidCallback? onPressed,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(imagePath, height: 50, fit: BoxFit.contain),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE95227),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

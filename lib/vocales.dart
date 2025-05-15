import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'inicio.dart';
import 'matematicas.dart';
import 'juegos.dart';
import 'progreso.dart';
import 'perfil.dart';
import 'db.dart';
import 'Introvocal.dart';
import 'aprendervocal.dart';

class Vocales extends StatefulWidget {
  final int idUsuario;
  final int idModulo;

  const Vocales({
    super.key,
    required this.idUsuario,
    required this.idModulo,
  });

  @override
  State<Vocales> createState() => _VocalesState();
}

class _VocalesState extends State<Vocales> {
  int _selectedIndex = 0;
  String nombreUsuario = '';
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _obtenerNombre();
    _hablar();
  }

  Future<void> _obtenerNombre() async {
    final nombre = await DBHelper().obtenerNombreUsuario(widget.idUsuario);
    setState(() {
      nombreUsuario = nombre;
    });
  }

  Future<void> _hablar() async {
    await flutterTts.setLanguage('es-MX');
    await flutterTts.setPitch(1.3);
    await flutterTts.setSpeechRate(0.9);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak('Hola Bienvenido');
  }

  Future<void> _repetirSaludo() async {
    await flutterTts.speak('Hola. Presiona El boton de color naranja para comenzar la leccion');
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
        child: nombreUsuario.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _repetirSaludo,
                    child: Image.asset('imagen/jaguar.png', height: 100),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        
                        const SizedBox(height: 16),
                        _buildCard(
                          imagePath: 'imagen/letra.png',
                          title: 'Aprender vocales',
                          buttonText: 'Comenzar',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AprenderVocal(
                                  idUsuario: widget.idUsuario,
                                  idModulo: widget.idModulo,
                                ),
                              ),
                            );
                          },
                        ),
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
                fontSize: 20,
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
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

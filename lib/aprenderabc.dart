import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'db.dart';
import 'inicio.dart';
import 'matematicas.dart';
import 'juegos.dart';
import 'progreso.dart';
import 'perfil.dart';
import 'abc.dart'; // Asegúrate de tener este archivo y clase correctamente

class AprenderABC extends StatefulWidget {
  final int idUsuario;

  const AprenderABC({super.key, required this.idUsuario});

  @override
  State<AprenderABC> createState() => _AprenderABCState();
}

class _AprenderABCState extends State<AprenderABC> {
  String nombreUsuario = '';
  final FlutterTts flutterTts = FlutterTts();
  int _selectedIndex = 0;

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
    await flutterTts.speak('Bienvenido A Aprendiendo el abecedario');
  }

  Future<void> _repetirSaludo() async {
    await flutterTts.setLanguage('es-MX');
    await flutterTts.speak(
      'Hola $nombreUsuario. Esta es la sección llamada Aprendiendo el abecedario. Presiona el botón de color naranja para empezar.',
    );
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
                        'Abecedario',
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
                    child: Image.asset('imagen/jaguar.png', height: 120),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('imagen/letra.png', height: 60),
                              const SizedBox(height: 12),
                              const Text(
                                'Aprendiendo el abecedario',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ABC(idUsuario: widget.idUsuario, idModulo: 2,)
                                      
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFE95227),
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'Comenzar',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
}

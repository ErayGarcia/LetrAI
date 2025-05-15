import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:letra/compresionlec.dart';
import 'package:letra/dinerogame.dart';
import 'db.dart';
import 'inicio.dart';
import 'matematicas.dart';
import 'progreso.dart';
import 'perfil.dart';
import 'gamearrastrar.dart';

class Juegos extends StatefulWidget {
  final int idUsuario;

  const Juegos({super.key, required this.idUsuario});

  @override
  State<Juegos> createState() => _JuegosState();
}

class _JuegosState extends State<Juegos> {
  String nombreUsuario = '';
  final FlutterTts flutterTts = FlutterTts();
  int _selectedIndex = 2; // Juegos es la tercera opción

  @override
  void initState() {
    super.initState();
    _obtenerNombreYHablar();
  }

  Future<void> _obtenerNombreYHablar() async {
    final nombre = await DBHelper().obtenerNombreUsuario(widget.idUsuario);

    setState(() {
      nombreUsuario = nombre;
    });

    await _hablar(nombre);
  }

  Future<void> _hablar(String nombre) async {
    await flutterTts.setLanguage('es-MX');
    await flutterTts.setPitch(1.3);
    await flutterTts.setSpeechRate(0.9);
    await flutterTts.setVolume(1.0);

    await flutterTts.speak('Bienvenido a los juegos, $nombre');
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Inicio(idUsuario: widget.idUsuario)),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Matematicas(idUsuario: widget.idUsuario)),
        );
        break;
      case 2:
        break; // Ya estás en Juegos
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Progreso(idUsuario: widget.idUsuario)),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Perfil(idUsuario: widget.idUsuario)),
        );
        break;
    }
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
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Juegos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset('imagen/jaguar.png', height: 120),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _buildCard(
                          imagePath: 'imagen/vocal.png',
                          title: 'Arrastra las silabas',
                          buttonText: 'Comenzar',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Gamearrastrar(idUsuario: widget.idUsuario),
                              ),
                            );
                          },
                          isLocked: false,
                        ),
                        const SizedBox(height: 16),
                        _buildCard(
                          imagePath: 'imagen/formacion.png',
                          title: 'Compresion Lectora',
                          buttonText: 'Comenzar',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JuegoColores(idUsuario: widget.idUsuario),
                              ),
                            );
                          },
                          isLocked: false,
                        ),
                        const SizedBox(height: 16),
                        _buildCard(
                          imagePath: 'imagen/vocal.png',
                          title: 'Emparejar el billete con su valor',
                          buttonText: 'Comenzar',
                          onPressed: () {
                           Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JuegoDeDinero(idUsuario: widget.idUsuario),
                              ),
                            );
                          },
                          isLocked: false,
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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('imagen/libro.png'),
              height: 30,
              width: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('imagen/lapiz.png'),
              height: 30,
              width: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('imagen/juegos.png'),
              height: 30,
              width: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('imagen/trofeo.png'),
              height: 30,
              width: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('imagen/perfil.png'),
              height: 30,
              width: 30,
            ),
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
    required VoidCallback onPressed,
    required bool isLocked,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: title.length > 25 ? 16 : 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white),
                  ),
                  if (isLocked)
                    const Icon(Icons.lock, size: 16, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

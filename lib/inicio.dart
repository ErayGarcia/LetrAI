import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'db.dart';
import 'matematicas.dart';
import 'juegos.dart';
import 'progreso.dart';
import 'perfil.dart';
import 'vocales.dart';
import 'aprenderabc.dart';
import 'formacion.dart'; // Asegúrate de importar el archivo de formación

class Inicio extends StatefulWidget {
  final int idUsuario;

  const Inicio({super.key, required this.idUsuario});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  String nombreUsuario = '';
  final FlutterTts flutterTts = FlutterTts();
  int _selectedIndex = 0;
  bool isAbecedarioUnlocked = false;
  bool isFormacionUnlocked = false;

  @override
  void initState() {
    super.initState();
    _obtenerNombreYHablar();
    _checkModulosProgreso();
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
    await flutterTts.speak('Bienvenido a la ruta de aprendizaje, . Si quieres iniciar con el primer módulo presiona el boton que aparece en tu pantalla. Al terminar cada módulo se ira desbloqueando el siguiente ');
  }

  Future<void> _checkModulosProgreso() async {
    // Verifica módulo 1 - Vocales
    double progresoVocales = await DBHelper().obtenerProgresoModulo(
      widget.idUsuario,
      1,
    );
    if (progresoVocales >= 1.0) {
      setState(() {
        isAbecedarioUnlocked = true;
      });
    }

    // Verifica módulo 2 - Abecedario
    double progresoAbecedario = await DBHelper().obtenerProgresoModulo(
      widget.idUsuario,
      2,
    );
    if (progresoAbecedario >= 1.0) {
      setState(() {
        isFormacionUnlocked = true;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Matematicas(idUsuario: widget.idUsuario),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Juegos(idUsuario: widget.idUsuario),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Progreso(idUsuario: widget.idUsuario),
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Perfil(idUsuario: widget.idUsuario),
          ),
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
                  const SizedBox(height: 10),
                  Image.asset('imagen/jaguar.png', height: 120),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _buildCard(
                          imagePath: 'imagen/vocal.png',
                          title: 'Vocales',
                          buttonText: 'Comenzar',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Vocales(
                                  idUsuario: widget.idUsuario,
                                  idModulo: 1,
                                ),
                              ),
                            );
                          },
                          isLocked: false,
                        ),
                        const SizedBox(height: 16),
                        _buildCard(
                          imagePath: 'imagen/abc.png',
                          title: 'Abecedario',
                          buttonText: isAbecedarioUnlocked ? 'Comenzar' : 'Bloqueado',
                          onPressed: isAbecedarioUnlocked
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AprenderABC(
                                        idUsuario: widget.idUsuario,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          isLocked: !isAbecedarioUnlocked,
                        ),
                        const SizedBox(height: 16),
                        _buildCard(
                          imagePath: 'imagen/formacion.png',
                          title: 'Formación de palabras y frases',
                          buttonText: isFormacionUnlocked ? 'Comenzar' : 'Bloqueado',
                          onPressed: isFormacionUnlocked
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Formacion(
                                        idUsuario: widget.idUsuario,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          isLocked: !isFormacionUnlocked,
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
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('imagen/libro.png', height: 30, width: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('imagen/lapiz.png', height: 30, width: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('imagen/juegos.png', height: 30, width: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('imagen/trofeo.png', height: 30, width: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('imagen/perfil.png', height: 30, width: 30),
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
    required bool isLocked,
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
                backgroundColor: const Color(0xFFE95227),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(buttonText, style: const TextStyle(color: Colors.white)),
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

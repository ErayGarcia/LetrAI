import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:letra/Pagamonto.dart';
import 'package:letra/cambiodar.dart';
import 'package:letra/cuentodinero.dart';
import 'package:letra/recibos.dart';
import 'db.dart';
import 'inicio.dart';
import 'juegos.dart';
import 'progreso.dart';
import 'perfil.dart';
import 'reconocimiento.dart';

class Matematicas extends StatefulWidget {
  final int idUsuario;

  const Matematicas({super.key, required this.idUsuario});

  @override
  State<Matematicas> createState() => _MatematicasState();
}

class _MatematicasState extends State<Matematicas> {
  String nombreUsuario = '';
  final FlutterTts flutterTts = FlutterTts();
  int _selectedIndex = 1;

  bool isModulo8Unlocked = false;
  bool isModulo9Unlocked = false;
  bool isModulo10Unlocked = false;
  bool isModulo11Unlocked = false;

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
    await flutterTts.speak(
      'Bienvenido a las matemáticas básicas, Si quieres iniciar con el primer módulo presiona el boton que aparece en tu pantalla. Al terminar cada módulo se ira desbloqueando el siguiente',
    );
  }

  Future<void> _checkModulosProgreso() async {
    double progresoModulo7 = await DBHelper().obtenerProgresoModulo(
      widget.idUsuario,
      7,
    );
    if (progresoModulo7 >= 1.0) {
      setState(() {
        isModulo8Unlocked = true;
      });
    }

    double progresoModulo8 = await DBHelper().obtenerProgresoModulo(
      widget.idUsuario,
      8,
    );
    if (progresoModulo8 >= 1.0) {
      setState(() {
        isModulo8Unlocked = true;
        isModulo9Unlocked = true;
      });
    }

    double progresoModulo9 = await DBHelper().obtenerProgresoModulo(
      widget.idUsuario,
      9,
    );
    if (progresoModulo9 >= 1.0) {
      setState(() {
        isModulo9Unlocked = true;
        isModulo10Unlocked = true;
      });
    }

    double progresoModulo10 = await DBHelper().obtenerProgresoModulo(
      widget.idUsuario,
      10,
    );
    if (progresoModulo10 >= 1.0) {
      setState(() {
        isModulo10Unlocked = true;
        isModulo11Unlocked = true;
      });
    }

    double progresoModulo11 = await DBHelper().obtenerProgresoModulo(
      widget.idUsuario,
      11,
    );
    if (progresoModulo11 >= 1.0) {
      setState(() {
        isModulo11Unlocked = true;
      });
    }
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
          MaterialPageRoute(
            builder: (context) => Inicio(idUsuario: widget.idUsuario),
          ),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Juegos(idUsuario: widget.idUsuario),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Progreso(idUsuario: widget.idUsuario),
          ),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Perfil(idUsuario: widget.idUsuario),
          ),
        );
        break;
    }
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
              onPressed: isLocked ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF84BA40),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(buttonText, style: const TextStyle(color: Colors.white)),
                  if (isLocked)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.lock, size: 16, color: Colors.white),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
            nombreUsuario.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: const BoxDecoration(
                        color: Color(0xFF84BA40),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Matemáticas Básicas',
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
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        children: [
                          _buildCard(
                            imagePath: 'imagen/revi.png',
                            title: 'Reconocimiento de Números y Billetes',
                            buttonText: 'Comenzar',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => Reconocimiento(
                                        idUsuario: widget.idUsuario,
                                        idModulo: 7,
                                      ),
                                ),
                              );
                            },
                            isLocked: false,
                          ),
                          const SizedBox(height: 16),
                          _buildCard(
                            imagePath: 'imagen/voz.png',
                            title: '¿Cuánto dinero tengo?',
                            buttonText:
                                isModulo8Unlocked ? 'Comenzar' : 'Bloqueado',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CuantoDinero(
                                        idUsuario: widget.idUsuario,
                                        idModulo: 8,
                                      ),
                                ),
                              );
                            },
                            isLocked: !isModulo8Unlocked,
                          ),
                          const SizedBox(height: 16),
                          _buildCard(
                            imagePath: 'imagen/voz.png',
                            title: '¿Cuánto cambio me deben dar?',
                            buttonText:
                                isModulo9Unlocked ? 'Comenzar' : 'Bloqueado',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => Dinerodar(
                                        idUsuario: widget.idUsuario,
                                        idModulo: 9,
                                      ),
                                ),
                              );
                            },
                            isLocked: !isModulo9Unlocked,
                          ),
                          const SizedBox(height: 16),
                          _buildCard(
                            imagePath: 'imagen/voz.png',
                            title: 'Paga el Monto Exacto',
                            buttonText:
                                isModulo10Unlocked ? 'Comenzar' : 'Bloqueado',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => MontoExacto(
                                        idUsuario: widget.idUsuario,
                                        idModulo: 10,
                                      ),
                                ),
                              );
                            },
                            isLocked: !isModulo10Unlocked,
                          ),
                          const SizedBox(height: 16),
                          _buildCard(
                            imagePath: 'imagen/voz.png',
                            title: 'Pago de Servicios Básicos',
                            buttonText:
                                isModulo11Unlocked ? 'Comenzar' : 'Bloqueado',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => PagoServiciosExacto(
                                        idUsuario: widget.idUsuario,
                                        idModulo: 11,
                                      ),
                                ),
                              );
                            },
                            isLocked: !isModulo11Unlocked,
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
}

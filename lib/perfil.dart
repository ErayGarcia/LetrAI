import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'db.dart'; // Cambia esto al nombre correcto de tu archivo DBHelper

// Importar las pantallas de destino
import 'inicio.dart';
import 'matematicas.dart';
import 'juegos.dart';
import 'progreso.dart';
import 'sesion.dart'; // Asegúrate de importar la pantalla de inicio de sesión

class Perfil extends StatefulWidget {
  final int idUsuario;

  const Perfil({Key? key, required this.idUsuario}) : super(key: key);

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  String nombreUsuario = '';
  File? _imagenPerfil;
  int intentosJuegos = 0;
  int leccionesCompletadas = 0;
  bool certificadoDesbloqueado = false;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    try {
      final nombre = await DBHelper().obtenerNombreUsuario(widget.idUsuario);
      setState(() {
        nombreUsuario = nombre;
        // Suponiendo que también tienes métodos para estos datos
        // intentosJuegos = await DBHelper().obtenerIntentosJuegos(widget.idUsuario);
        // leccionesCompletadas = await DBHelper().obtenerLeccionesCompletadas(widget.idUsuario);

        certificadoDesbloqueado = intentosJuegos >= 5 && leccionesCompletadas >= 3;
      });
    } catch (e) {
      print('Error al cargar datos del usuario: $e');
    }
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagenPerfil = File(pickedFile.path);
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 4) return; // Ya estás en Perfil

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
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destino),
    );
  }

  // Función para cerrar sesión
  void _cerrarSesion() {
    // Aquí va tu lógica para cerrar sesión (reseteando las variables necesarias)
    // Ejemplo: eliminar cualquier dato guardado en SharedPreferences (o cualquier otro almacenamiento persistente).
    
    // Redirigir al inicio de sesión
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Asegúrate de que LoginScreen esté bien definido
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _cerrarSesion, // Cerrar sesión al presionar el ícono
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _seleccionarImagen,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imagenPerfil != null
                        ? FileImage(_imagenPerfil!)
                        : const AssetImage('assets/default_user.png') as ImageProvider,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                nombreUsuario,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 30),
              Row(
                children: const [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text('Usuario'),
                ],
              ),
              const SizedBox(height: 5),
              Text(nombreUsuario),
              const Divider(height: 30),
              _estadisticas(),
              const SizedBox(height: 20),
              _botonCertificado(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // Perfil es la posición 4 (índice 4)
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
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

  Widget _estadisticas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Progreso", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text("Intentos en Juegos: $intentosJuegos"),
        Text("Lecciones Completadas: $leccionesCompletadas"),
      ],
    );
  }

  Widget _botonCertificado() {
    return ElevatedButton.icon(
      onPressed: certificadoDesbloqueado ? () {
        // Acción cuando está habilitado
        print("Generar certificado...");
      } : null,
      icon: const Icon(Icons.verified),
      label: Text(certificadoDesbloqueado ? "Generar Certificado" : "Bloqueado"),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFA6722),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
    );
  }
}

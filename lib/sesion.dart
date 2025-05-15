import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sqflite/sqflite.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart'; // Paquete de TTS
import 'db.dart'; // Tu base de datos

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool ocultarPassword = true;
  String errorMessage = '';
  bool _isListening = false;
  stt.SpeechToText _speech = stt.SpeechToText();
  FlutterTts _flutterTts = FlutterTts(); // Instancia del paquete TTS

  @override
  void initState() {
    super.initState();
    _speech.initialize();
    _flutterTts.setLanguage("es-ES"); // Establece el idioma
    _flutterTts.setSpeechRate(0.5); // Controla la velocidad del habla
    _flutterTts.setVolume(1.0); // Controla el volumen
    _flutterTts.setPitch(1.0); // Controla el tono de la voz
    _giveInstructions(); // Llama la función de instrucciones al cargar la pantalla
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagen más arriba
                GestureDetector(
                  onTap: _giveInstructions, // Llama a las instrucciones cuando se toque la imagen
                  child: SvgPicture.asset(
                    'imagen/sesion.svg',
                    height: 120,
                  ),
                ),
                const SizedBox(height: 30), // Espacio mayor aquí

                // Campo de usuario
                _buildInputField(
                  controller: usuarioController,
                  hintText: 'Numero de usuario',
                  icon: Icons.person,
                  onMicPressed: _toggleMicUsuario,
                ),
                const SizedBox(height: 16),

                // Campo de contraseña
                _buildInputField(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  icon: Icons.lock,
                  obscureText: ocultarPassword,
                  suffixIcons: [
                    IconButton(
                      icon: Icon(
                        ocultarPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          ocultarPassword = !ocultarPassword;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? Colors.red : Colors.deepOrange,
                      ),
                      onPressed: _toggleMicPassword,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Funcionalidad en desarrollo'),
                        ),
                      );
                    },
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _iniciarSesion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 65, 163, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                if (errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],

                const SizedBox(height: 30),

                // Botón para registrarse
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/registro');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 173, 21),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Regístrate aquí",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Function()? onMicPressed,
    List<Widget>? suffixIcons,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepOrange),
        suffixIcon: suffixIcons != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: suffixIcons,
              )
            : IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? Colors.red : Colors.deepOrange,
                ),
                onPressed: onMicPressed,
              ),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Future<void> _iniciarSesion() async {
    final usuario = usuarioController.text.trim();
    final password = passwordController.text;

    if (usuario.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Por favor, completa todos los campos';
      });
      return;
    }

    try {
      final db = await DBHelper.database;
      final result = await db.query(
        'usuarios',
        where: 'nombre = ? AND contraseña = ?',
        whereArgs: [usuario, password],
      );

      if (result.isNotEmpty) {
        final idUsuario = result.first['id_usuario'];

        if (idUsuario != null && idUsuario is int) {
          Navigator.pushReplacementNamed(
            context,
            '/inicio',
            arguments: {'idUsuario': idUsuario},
          );
        } else {
          setState(() {
            errorMessage = "ID de usuario no es válido.";
          });
        }
      } else {
        setState(() {
          errorMessage = "Credenciales incorrectas.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error al iniciar sesión: $e";
      });
    }
  }

  // Función para dar instrucciones
  Future<void> _giveInstructions() async {
    await _flutterTts.speak(
      "Presiona el micrófono para decir tu usuario y contraseña. En caso de que no tengas cuenta, presiona el botón naranja que dice 'Regístrate aquí' para poder registrarse.",
    );
  }

  Future<void> _toggleMicUsuario() async {
    if (_isListening) {
      await _speech.stop();
      setState(() {
        _isListening = false;
      });
    } else {
      await _startListeningForUsuario();
    }
  }

  Future<void> _toggleMicPassword() async {
    if (_isListening) {
      await _speech.stop();
      setState(() {
        _isListening = false;
      });
    } else {
      await _startListeningForPassword();
    }
  }

  Future<void> _startListeningForUsuario() async {
    await _speech.listen(
      onResult: (result) {
        setState(() {
          usuarioController.text = result.recognizedWords;
        });
      },
    );
    setState(() {
      _isListening = true;
    });
  }

  Future<void> _startListeningForPassword() async {
    await _speech.listen(
      onResult: (result) {
        setState(() {
          passwordController.text = result.recognizedWords;
        });
      },
    );
    setState(() {
      _isListening = true;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:letra/db.dart';
import 'package:permission_handler/permission_handler.dart';
import 'sesion.dart'; // Asegúrate de que este es el archivo correcto

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _contrasenaController = TextEditingController();
  bool _isListening = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _hablarInstruccion(); // Llama la función para hablar cuando se entra a la pantalla
  }

  void _startListening(TextEditingController controller) async {
    PermissionStatus status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Se necesita permiso para usar el micrófono'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    bool available = await _speech.initialize();

    if (available) {
      setState(() {
        _isListening = true;
      });

      _speech.listen(
        onResult: (val) {
          String newText = val.recognizedWords;
          if (newText.isNotEmpty) {
            setState(() {
              controller.text = newText;
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            });
          }
        },
        listenFor: const Duration(seconds: 15),
        pauseFor: const Duration(seconds: 8),
        cancelOnError: true,
      );
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _speech.stop();
  }

  void _hablarInstruccion() async {
    await _flutterTts.speak("Por favor presiona el icono del microfono para añadir tu informacion en cada campo.");
  }

  void _validarYContinuar() async {
    String nombre = _nombreController.text.trim();
    String contrasena = _contrasenaController.text.trim();
    String correo = "$nombre@email.com"; // Temporal

    if (nombre.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor llena todos los campos.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    int resultado = await DBHelper.registrarUsuario(nombre, correo, contrasena);

    if (resultado != -1) {
      await _flutterTts.speak("Usuario registrado exitosamente");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario registrado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El numero ya está registrado. Intenta con otro.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _nombreController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 40,
              child: GestureDetector(
                onTap: _hablarInstruccion,
                child: Image.asset(
                  'imagen/jaguar.png',
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 150),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'imagen/robot.svg',
                      height: 60,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Numero del usuario',
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_nombreController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    _nombreController.clear();
                                  });
                                },
                              ),
                            IconButton(
                              icon: Icon(
                                _isListening ? Icons.mic : Icons.mic_none,
                                color: _isListening ? Colors.red : Colors.deepOrange,
                              ),
                              onPressed: () {
                                if (_isListening) {
                                  _stopListening();
                                } else {
                                  _startListening(_nombreController);
                                }
                              },
                            ),
                          ],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _contrasenaController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            if (_contrasenaController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    _contrasenaController.clear();
                                  });
                                },
                              ),
                            IconButton(
                              icon: Icon(
                                _isListening ? Icons.mic : Icons.mic_none,
                                color: _isListening ? Colors.red : Colors.deepOrange,
                              ),
                              onPressed: () {
                                if (_isListening) {
                                  _stopListening();
                                } else {
                                  _startListening(_contrasenaController);
                                }
                              },
                            ),
                          ],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _validarYContinuar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFA6722),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Registrarse'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

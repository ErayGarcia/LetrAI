import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'db.dart';
import 'formacion.dart';

class SeparacionSilabas extends StatefulWidget {
  final int idUsuario;
  final int idModulo;

  const SeparacionSilabas({
    Key? key,
    required this.idUsuario,
    required this.idModulo,
  }) : super(key: key);

  @override
  State<SeparacionSilabas> createState() => _SeparacionSilabasState();
}

class _SeparacionSilabasState extends State<SeparacionSilabas> {
  final List<String> listaPalabras = [
    'Gato', 'Perro', 'Casa', 'Escuela', 'Nino', 'Flor', 'Cielo', 'Arbol',
    'Silla', 'Libro', 'Abuela', 'Abuelo', 'Mesa', 'Banera', 'Barco', 'Bota',
    'Caja', 'Calabaza', 'Cebra', 'Coche', 'Colina', 'Conejo', 'Corazon',
    'Dedo', 'Delfin', 'Dinosaurio', 'Dulce', 'Estrella', 'Feo', 'Gallo',
    'Garganta', 'Gorra', 'Guitarra', 'Huevo', 'Helado', 'Hamster', 'Jirafa',
    'Juguete', 'Laguna', 'Lentes', 'Leon', 'Lobo', 'Lluvia', 'Mandarina',
    'Mar', 'Mermelada', 'Mono', 'Nieve', 'Nube', 'Ojo', 'Oso', 'Pared',
    'Pato', 'Pez', 'Plato', 'Reloj', 'Raton', 'Sombrero', 'Tren', 'Zapato',
  ];

  final Map<String, String> silabas = {
    'Gato': 'Ga - to',
    'Perro': 'Pe - rro',
    'Casa': 'Ca - sa',
    'Escuela': 'Es - cue - la',
    'Nino': 'Ni - ño',
    'Flor': 'Flor',
    'Cielo': 'Cie - lo',
    'Arbol': 'Ár - bol',
    'Silla': 'Si - lla',
    'Libro': 'Li - bro',
    'Abuela': 'A - bue - la',
    'Abuelo': 'A - bue - lo',
    'Mesa': 'Me - sa',
    'Banera': 'Ba - ñe - ra',
    'Barco': 'Bar - co',
    'Bota': 'Bo - ta',
    'Caja': 'Ca - ja',
    'Calabaza': 'Ca - la - ba - za',
    'Cebra': 'Ce - bra',
    'Coche': 'Co - che',
    'Colina': 'Co - li - na',
    'Conejo': 'Co - ne - jo',
    'Corazon': 'Co - ra - zón',
    'Dedo': 'De - do',
    'Delfin': 'Del - fín',
    'Dinosaurio': 'Di - no - sau - rio',
    'Dulce': 'Dul - ce',
    'Estrella': 'Es - tre - lla',
    'Feo': 'Fe - o',
    'Gallo': 'Ga - llo',
    'Garganta': 'Gar - gan - ta',
    'Gorra': 'Go - rra',
    'Guitarra': 'Gui - ta - rra',
    'Huevo': 'Hue - vo',
    'Helado': 'He - la - do',
    'Hamster': 'Hams - ter',
    'Jirafa': 'Ji - ra - fa',
    'Juguete': 'Ju - gue - te',
    'Laguna': 'La - gu - na',
    'Lentes': 'Len - tes',
    'Leon': 'Le - ón',
    'Lobo': 'Lo - bo',
    'Lluvia': 'Llu - via',
    'Mandarina': 'Man - da - ri - na',
    'Mar': 'Mar',
    'Mermelada': 'Mer - me - la - da',
    'Mono': 'Mo - no',
    'Nieve': 'Nie - ve',
    'Nube': 'Nu - be',
    'Ojo': 'O - jo',
    'Oso': 'O - so',
    'Pared': 'Pa - red',
    'Pato': 'Pa - to',
    'Pez': 'Pez',
    'Plato': 'Pla - to',
    'Reloj': 'Re - loj',
    'Raton': 'Ra - tón',
    'Sombrero': 'Som - bre - ro',
    'Tren': 'Tren',
    'Zapato': 'Za - pa - to',
  };

  final Map<String, String> nombresObjetos = {
    'Gato': 'animal que maulla',
    'Perro': 'animal que ladra',
    'Casa': 'donde vivimos',
    'Escuela': 'donde se aprende',
    'Nino': 'persona pequena',
    'Flor': 'parte bonita de la planta',
    'Cielo': 'lo que esta arriba',
    'Arbol': 'planta alta',
    'Silla': 'para sentarse',
    'Libro': 'para leer',
    'Abuela': 'mama del papa o mama',
    'Abuelo': 'papa del papa o mama',
    'Mesa': 'para comer o trabajar',
    'Banera': 'para banarse',
    'Barco': 'viaja por agua',
    'Bota': 'zapato alto',
    'Caja': 'para guardar cosas',
    'Calabaza': 'fruta naranja',
    'Cebra': 'animal con rayas',
    'Coche': 'vehiculo con ruedas',
    'Colina': 'montana pequena',
    'Conejo': 'animal con orejas largas',
    'Corazon': 'bombea la sangre',
    'Dedo': 'parte de la mano',
    'Delfin': 'vive en el mar',
    'Dinosaurio': 'animal antiguo',
    'Dulce': 'comida con azucar',
    'Estrella': 'brilla en el cielo',
    'Feo': 'no es bonito',
    'Gallo': 'canta en la manana',
    'Garganta': 'por donde pasa la comida',
    'Gorra': 'se usa en la cabeza',
    'Guitarra': 'hace musica',
    'Huevo': 'viene de la gallina',
    'Helado': 'frio y dulce',
    'Hamster': 'animal pequeno',
    'Jirafa': 'cuello muy largo',
    'Juguete': 'para jugar',
    'Laguna': 'agua pequena',
    'Lentes': 'ayudan a ver',
    'Leon': 'animal fuerte',
    'Lobo': 'animal salvaje',
    'Lluvia': 'agua del cielo',
    'Mandarina': 'fruta dulce',
    'Mar': 'agua grande',
    'Mermelada': 'dulce de fruta',
    'Mono': 'salta y trepa',
    'Nieve': 'agua congelada',
    'Nube': 'blanca en el cielo',
    'Ojo': 'sirve para ver',
    'Oso': 'animal grande',
    'Pared': 'divide la casa',
    'Pato': 'animal que nada',
    'Pez': 'vive en el agua',
    'Plato': 'para servir comida',
    'Reloj': 'muestra la hora',
    'Raton': 'animal chiquito',
    'Sombrero': 'cubre la cabeza',
    'Tren': 'va por rieles',
    'Zapato': 'para los pies',
  };

  late FlutterTts flutterTts;
  int indiceActual = 0;
  bool leccionCompletada = false;

  double get progreso => (indiceActual + 1) / listaPalabras.length;

  Future<void> _configurarTTS() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("es-MX");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.7);
  }

  Future<void> _decirSilabasYPalabra() async {
    await _configurarTTS();
    final palabra = listaPalabras[indiceActual];
    final separada = silabas[palabra] ?? palabra;
    final partes = separada.split(' - ');
    for (var silaba in partes) {
      await flutterTts.speak(silaba);
      await Future.delayed(const Duration(milliseconds: 500));
    }
    await flutterTts.speak(palabra);
  }

  Future<void> _actualizarProgreso() async {
    final porcentaje = progreso * 100;
    await DBHelper().actualizarProgresoModulo(
      widget.idUsuario,
      widget.idModulo,
      porcentaje,
    );
  }

  void _avanzar() async {
    if (indiceActual < listaPalabras.length - 1) {
      setState(() {
        indiceActual++;
      });
      await _actualizarProgreso();
    } else if (!leccionCompletada) {
      await _actualizarProgreso();
      setState(() {
        leccionCompletada = true;
      });
      await _configurarTTS();
      await flutterTts.speak(
        "Has finalizado el módulo. Si quieres continuar, presiona el botón verde. Y si quieres reiniciar la lección, presiona el botón naranja.",
      );
    }
  }

  void _retroceder() {
    if (indiceActual > 0) {
      setState(() {
        indiceActual--;
      });
    }
  }

  void _reiniciarLeccion() {
    setState(() {
      indiceActual = 0;
      leccionCompletada = false;
    });
    _actualizarProgreso();
  }

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _actualizarProgreso();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palabra = listaPalabras[indiceActual];
    final separada = silabas[palabra] ?? palabra;
    final imagenObjeto = 'imagen/fotos/${palabra.toLowerCase()}.png';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE95227),
        centerTitle: true,
        title: const Text(
          'Ruta de aprendizaje de palabras',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: leccionCompletada
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('imagen/leccion.png', height: 150),
                const SizedBox(height: 30),
                Text(
                  '¡La lección ha sido completada!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                const SizedBox(height: 20),
                CircularPercentIndicator(
                  radius: 80.0,
                  lineWidth: 12.0,
                  animation: true,
                  percent: 1.0,
                  center: const Text(
                    "100%",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                  progressColor: const Color(0xFFE95227),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _reiniciarLeccion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                      icon: const Icon(Icons.refresh, size: 28),
                      label: const Text('Reiniciar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Formacion(idUsuario: widget.idUsuario),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B050),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                      icon: const Icon(Icons.home, size: 28),
                      label: const Text('Inicio', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: LinearPercentIndicator(
                    lineHeight: 14.0,
                    percent: progreso,
                    backgroundColor: Colors.grey[300],
                    progressColor: const Color(0xFFE95227),
                    center: Text("${(progreso * 100).toStringAsFixed(0)}%", style: const TextStyle(fontSize: 12.0)),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  separada,
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF0763A2)),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF15D41),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: _decirSilabasYPalabra,
                    icon: const Icon(Icons.volume_up),
                    color: Colors.white,
                    iconSize: 35,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await _configurarTTS();
                    await flutterTts.speak("$palabra, es como ${nombresObjetos[palabra] ?? ''}");
                  },
                  child: Image.asset(
                    imagenObjeto,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 100),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: _retroceder,
                      icon: const Icon(Icons.arrow_back_ios),
                      color: Colors.grey,
                      iconSize: 40,
                    ),
                    IconButton(
                      onPressed: _avanzar,
                      icon: const Icon(Icons.arrow_forward_ios),
                      color: const Color(0xFF00B050),
                      iconSize: 40,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

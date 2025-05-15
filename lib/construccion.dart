import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'db.dart';
import 'formacion.dart';

class Construccion extends StatefulWidget {
  final int idUsuario;
  final int idModulo;

  const Construccion({super.key, required this.idUsuario, required this.idModulo});

  @override
  State<Construccion> createState() => _ConstruccionState();
}

class _ConstruccionState extends State<Construccion> {
  final FlutterTts flutterTts = FlutterTts();
  int currentImageIndex = 0;
  String currentSentence = "El ___ es un animal.";
  String selectedWord = "";
  double progress = 0;
  bool isCompleted = false; // Para saber si la lección ha terminado

  List<Map<String, dynamic>> imagesAndWords = [

  {

    'words': ["Gato", "Perro", "Casa"],

    'sentences': [

      "El ___ es un animal.",

      "El ___ corre rápido.",

      "La ___ es un lugar donde vivimos."

    ]

  },

  {

    'words': ["Escuela", "Nino", "Flor"],

    'sentences': [

      "La ___ es un lugar para aprender.",

      "El ___ juega con sus amigos.",

      "La ___ tiene colores hermosos."

    ]

  },

  {

    'words': ["Cielo", "Arbol", "Silla"],

    'sentences': [

      "El ___ está muy azul hoy.",

      "El ___ es muy grande.",

      "La ___ está en la sala."

    ]

  },

  {

    'words': ["Libro", "Mesa", "Banera"],

    'sentences': [

      "El ___ tiene muchas páginas.",

      "La ___ está en la cocina.",

      "La ___ está en el baño."

    ]

  },

  {

    'words': ["Barco", "Bota", "Caja"],

    'sentences': [

      "El ___ navega por el mar.",

      "La ___ es de cuero.",

      "La ___ está llena de juguetes."

    ]

  },

  {

    'words': ["Calabaza", "Cebra", "Coche"],

    'sentences': [

      "La ___ es muy dulce.",

      "La ___ tiene rayas blancas y negras.",

      "El ___ es muy rápido."

    ]

  },

  {

    'words': ["Colina", "Conejo", "Corazon"],

    'sentences': [

      "La ___ es muy empinada.",

      "El ___ salta por el jardín.",

      "El ___ late cuando corremos."

    ]

  },

  {

    'words': ["Dedo", "Delfin", "Dinosaurio"],

    'sentences': [

      "El ___ es importante para tocar.",

      "El ___ nada en el mar.",

      "El ___ vivió hace muchos años."

    ]

  },

  {

    'words': ["Dulce", "Estrella", "Feo"],

    'sentences': [

      "El ___ sabe muy bien.",

      "La ___ brilla en el cielo.",

      "El ___ no es bonito, pero es interesante."

    ]

  },

  {

    'words': ["Gallo", "Garganta", "Gorra"],

    'sentences': [

      "El ___ canta por la mañana.",

      "La ___ me duele mucho.",

      "La ___ me protege del sol."

    ]

  },

  {

    'words': ["Guitarra", "Huevo", "Helado"],

    'sentences': [

      "La ___ tiene seis cuerdas.",

      "El ___ se usa para hacer omelette.",

      "El ___ es muy frío y dulce."

    ]

  },

  {

    'words': ["Hamster", "Jirafa", "Juguete"],

    'sentences': [

      "El ___ corre en su rueda.",

      "La ___ tiene un cuello muy largo.",

      "El ___ está en la caja de los juguetes."

    ]

  },

  {

    'words': ["Laguna", "Lentes", "Leon"],

    'sentences': [

      "La ___ es tranquila.",

      "Los ___ protegen los ojos del sol.",

      "El ___ es el rey de la selva."

    ]

  },

  {

    'words': ["Lobo", "Lluvia", "Mandarina"],

    'sentences': [

      "El ___ aúlla a la luna.",

      "La ___ moja todo a su paso.",

      "La ___ es una fruta cítrica."

    ]

  },

  {

    'words': ["Mar", "Mermelada", "Mono"],

    'sentences': [

      "El ___ tiene olas.",

      "La ___ tiene buen sabor.",

      "El ___ salta de árbol en árbol."

    ]

  },

  {

    'words': ["Nieve", "Nube", "Ojo"],

    'sentences': [

      "La ___ cubre todo el suelo.",

      "La ___ cubre el sol.",

      "El ___ es muy importante para ver."

    ]

  },

  {

    'words': ["Oso", "Pared", "Pato"],

    'sentences': [

      "El ___ vive en el bosque.",

      "La ___ está pintada de blanco.",

      "El ___ nada en el agua."

    ]

  },

  {

    'words': ["Pez", "Plato", "Reloj"],

    'sentences': [

      "El ___ nada en el agua.",

      "El ___ está lleno de comida.",

      "El ___ marca las horas del día."

    ]

  },

  {

    'words': ["Raton", "Sombrero", "Tren"],

    'sentences': [

      "El ___ corre por el campo.",

      "El ___ se usa para proteger la cabeza.",

      "El ___ viaja por las vías."

    ]

  },

  {

    'words': ["Zapato", "Flor", "Caja"],

    'sentences': [

      "El ___ protege los pies.",

      "La ___ tiene muchos colores.",

      "La ___ está llena de ropa."

    ]

  },
];

  String droppedWord = "";

  void updateSentence(String word) {
    setState(() {
      droppedWord = word;
      currentSentence = imagesAndWords[currentImageIndex]['sentences'][0].replaceFirst('___', word);
      progress = (currentImageIndex + 1) / imagesAndWords.length;
    });

    // Si llegamos al final, mostrar el mensaje de finalización
    if (currentImageIndex == imagesAndWords.length - 1) {
      _actualizarProgreso(); // Actualiza el progreso
      setState(() {
        isCompleted = true;
      });
    }
  }

  Future<void> speakSentence() async {
    if (droppedWord.isNotEmpty) {
      await flutterTts.speak(currentSentence); 
    } else {
      await flutterTts.speak("Por favor, arrastra una palabra a la oración.");
    }
  }

  void _actualizarProgreso() async {
    final porcentaje = progress * 100;
    await DBHelper().actualizarProgresoModulo(
      widget.idUsuario,
      widget.idModulo,
      porcentaje,
    );
  }

  void resetLesson() {
    setState(() {
      currentImageIndex = 0;
      progress = 0;
      droppedWord = "";
      isCompleted = false;
    });
  }

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage('es-MX');
    flutterTts.setPitch(1.3);
    flutterTts.setSpeechRate(0.9);
  }

  void resetSentence() {
    setState(() {
      droppedWord = "";
      currentSentence = imagesAndWords[currentImageIndex]['sentences'][0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Construcción de Frases Cortas'),
        backgroundColor: const Color(0xFFE95227),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isCompleted) ...[
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  color: Colors.orange,
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'imagen/fotos/${imagesAndWords[currentImageIndex]['words'][0].toLowerCase()}.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Text(
                  currentSentence,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  children: imagesAndWords[currentImageIndex]['words'].map<Widget>((word) {
                    return Draggable<String>( 
                      data: word,
                      child: Chip(
                        label: Text(word),
                        backgroundColor: Colors.orange,
                      ),
                      feedback: Material(
                        color: Colors.transparent,
                        child: Chip(
                          label: Text(word),
                          backgroundColor: Colors.orangeAccent,
                        ),
                      ),
                      childWhenDragging: Chip(
                        label: Text(word),
                        backgroundColor: Colors.grey,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: speakSentence,
                  child: const Icon(
                    Icons.volume_up,
                    size: 50,
                    color: Color(0xFFE95227),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    updateSentence(droppedWord);
                  },
                  child: Column(
                    children: [
                      DragTarget<String>(
                        onAccept: (word) {
                          setState(() {
                            droppedWord = word;
                            updateSentence(word);
                          });
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            width: 300,
                            height: 60,
                            alignment: Alignment.center,
                            color: Colors.grey[200],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (droppedWord.isEmpty)
                                  const Text(
                                    "Arrastra la palabra aquí",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  )
                                else
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.orangeAccent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      droppedWord,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              setState(() {
                                if (currentImageIndex > 0) {
                                  currentImageIndex--;
                                  resetSentence();
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              setState(() {
                                if (currentImageIndex < imagesAndWords.length - 1) {
                                  currentImageIndex++;
                                  resetSentence();
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Lección Terminada",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "¡Felicidades! Has completado la lección.",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Progreso: ${progress * 100}%",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Formacion(
                                idUsuario: widget.idUsuario,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.house), // Icono de casa
                        label: const Text('Inicio'), // Texto en el botón
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Botón verde
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: resetLesson,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Botón naranja
                        ),
                        child: const Icon(Icons.refresh), // Icono de reiniciar
                      ),
                    ],
                  ),
                ],
              ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

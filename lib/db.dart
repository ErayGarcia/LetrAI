import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _database;

  // Obtener la base de datos de forma segura
  static Future<Database> get database async {
    if (_database != null) return _database!;
    
    try {
      _database = await _initDB('sistema_aprendizaje.db');
      return _database!;
    } catch (e) {
      throw Exception('Error al obtener la base de datos: $e');
    }
  }

  // Inicializar la base de datos con manejo de errores
  static Future<Database> _initDB(String fileName) async {
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, fileName);

      return await openDatabase(path, version: 1, onCreate: _onCreate);
    } catch (e) {
      throw Exception('Error al inicializar la base de datos: $e');
    }
  }

  // Función de creación de las tablas con manejo de errores
  static Future _onCreate(Database db, int version) async {
    try {
      await db.execute(''' 
        CREATE TABLE usuarios (
          id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL,
          correo TEXT NOT NULL UNIQUE,
          contraseña TEXT NOT NULL,
          fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      await db.execute(''' 
        CREATE TABLE modulos (
          id_modulo INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL,
          descripcion TEXT,
          porcentaje_requerido REAL NOT NULL DEFAULT 100
        );
      ''');

      await db.execute(''' 
        CREATE TABLE progreso (
          id_usuario INTEGER NOT NULL,
          id_modulo INTEGER NOT NULL,
          progreso REAL NOT NULL,
          PRIMARY KEY (id_usuario, id_modulo),
          FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
          FOREIGN KEY (id_modulo) REFERENCES modulos(id_modulo)
        );
      ''');

      await db.execute(''' 
        CREATE TABLE juegos (
          id_juego INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL,
          descripcion TEXT,
          dificultad TEXT NOT NULL,
          categoria TEXT NOT NULL,
          id_modulo INTEGER,
          FOREIGN KEY (id_modulo) REFERENCES modulos(id_modulo)
        );
      ''');

      await db.execute('''
        CREATE TABLE progreso_juegos(
          id_progreso_juego INTEGER PRIMARY KEY AUTOINCREMENT,
          id_usuario INTEGER,
          id_juego INTEGER,
          intentos INTEGER DEFAULT 0,
          estado TEXT DEFAULT 'pendiente',
          FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
          FOREIGN KEY (id_juego) REFERENCES juegos(id_juego)
        )
      ''');

      await db.execute(''' 
        CREATE TABLE material_apoyo (
          id_material INTEGER PRIMARY KEY AUTOINCREMENT,
          titulo TEXT NOT NULL,
          tipo TEXT NOT NULL,
          url TEXT NOT NULL
        );
      ''');

      await db.execute(''' 
        CREATE TABLE audios_asistente (
          id_audio INTEGER PRIMARY KEY AUTOINCREMENT,
          descripcion TEXT,
          archivo_audio BLOB NOT NULL
        );
      ''');

      await db.execute(''' 
        CREATE TABLE progreso_total_usuarios (
          id_progreso_total INTEGER PRIMARY KEY AUTOINCREMENT,
          id_usuario INTEGER UNIQUE,
          juegos_completados INTEGER DEFAULT 0,
          ejercicios_completados INTEGER DEFAULT 0,
          intentos_fallidos INTEGER DEFAULT 0,
          porcentaje_general REAL DEFAULT 0,
          fecha_ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        );
      ''');

      await db.execute(''' 
        CREATE TABLE progreso_modulos (
          id_progreso_modulo INTEGER PRIMARY KEY AUTOINCREMENT,
          id_usuario INTEGER,
          id_modulo INTEGER,
          juegos_completados INTEGER DEFAULT 0,
          ejercicios_completados INTEGER DEFAULT 0,
          porcentaje_avance REAL DEFAULT 0,
          modulo_desbloqueado INTEGER DEFAULT 0,
          FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
          FOREIGN KEY (id_modulo) REFERENCES modulos(id_modulo)
        );
      ''');

      await db.execute(''' 
        CREATE TABLE ejercicios (
          id_ejercicio INTEGER PRIMARY KEY AUTOINCREMENT,
          titulo TEXT NOT NULL,
          descripcion TEXT,
          tipo TEXT NOT NULL,
          respuesta_tipo TEXT NOT NULL,
          id_modulo INTEGER,
          FOREIGN KEY (id_modulo) REFERENCES modulos(id_modulo)
        );
      ''');

      await db.execute(''' 
        CREATE TABLE ejercicios_matematicas (
          id_ejercicio_matematico INTEGER PRIMARY KEY AUTOINCREMENT,
          id_ejercicio INTEGER,
          pregunta TEXT NOT NULL,
          respuesta_correcta REAL NOT NULL,
          FOREIGN KEY (id_ejercicio) REFERENCES ejercicios(id_ejercicio)
        );
      ''');

      await db.execute(''' 
        CREATE TABLE opciones_ejercicios (
          id_opcion INTEGER PRIMARY KEY AUTOINCREMENT,
          id_ejercicio INTEGER,
          opcion_texto TEXT NOT NULL,
          es_correcta INTEGER NOT NULL,
          FOREIGN KEY (id_ejercicio) REFERENCES ejercicios(id_ejercicio)
        );
      ''');

      await db.execute(''' 
        CREATE TABLE intentos_ejercicios_matematicas (
          id_intento INTEGER PRIMARY KEY AUTOINCREMENT,
          id_usuario INTEGER,
          id_ejercicio_matematico INTEGER,
          respuesta_usuario REAL,
          es_correcta INTEGER,
          fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
          FOREIGN KEY (id_ejercicio_matematico) REFERENCES ejercicios_matematicas(id_ejercicio_matematico)
        );
      ''');

      await db.execute(''' 
        CREATE TABLE progreso_ejercicios (
          id_usuario INTEGER NOT NULL,
          ejercicio TEXT NOT NULL,
          estado TEXT NOT NULL DEFAULT 'bloqueado',
          PRIMARY KEY (id_usuario, ejercicio),
          FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        );
      ''');

    } catch (e) {
      throw Exception('Error al crear las tablas: $e');
    }
  }

  // Función para eliminar la base de datos
  static Future<void> eliminarBaseDeDatos() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'sistema_aprendizaje.db');
      
      // Elimina la base de datos
      await deleteDatabase(path);
      print('Base de datos eliminada');
    } catch (e) {
      throw Exception('Error al eliminar la base de datos: $e');
    }
  }

  // Función para registrar usuarios con manejo de errores
  static Future<int> registrarUsuario(
    String nombre,
    String correo,
    String contrasena,
  ) async {
    try {
      final db = await database;

      final existing = await db.query(
        'usuarios',
        where: 'correo = ?',
        whereArgs: [correo],
      );

      if (existing.isNotEmpty) {
        return -1; // Usuario ya existe
      }

      return await db.insert('usuarios', {
        'nombre': nombre,
        'correo': correo,
        'contraseña': contrasena,
      });
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }

  // Método para iniciar sesión y validar las credenciales
  static Future<int?> iniciarSesion(String nombre, String contrasena) async {
    try {
      final db = await database;

      final List<Map<String, dynamic>> result = await db.query(
        'usuarios',
        where: 'correo = ? AND contraseña = ?',
        whereArgs: [nombre, contrasena],
      );

      if (result.isNotEmpty) {
        return result.first['id_usuario']; // Retorna el id del usuario
      } else {
        return null; // Si no hay coincidencia, retornamos null
      }
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  // Obtener nombre del usuario por id
  Future<String> obtenerNombreUsuario(int idUsuario) async {
    final db = await database;
    final res = await db.query(
      'usuarios',
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
    );

    if (res.isNotEmpty) {
      return res.first['nombre'] as String;
    } else {
      return 'Usuario';
    }
  }

  // Actualizar el progreso del módulo
  Future<void> actualizarProgresoModulo(int idUsuario, int idModulo, double porcentaje) async {
    final db = await database;
    try {
      await db.insert(
        'progreso',
        {
          'id_usuario': idUsuario,
          'id_modulo': idModulo,
          'progreso': porcentaje,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,  // Para actualizar si ya existe
      );
    } catch (e) {
      throw Exception('Error al actualizar el progreso del módulo: $e');
    }
  }

  // Obtener progreso del módulo
  Future<double> obtenerProgresoModulo(int idUsuario, int idModulo) async {
    final db = await database;
    try {
      var result = await db.query(
        'progreso',
        columns: ['progreso'],
        where: 'id_usuario = ? AND id_modulo = ?',
        whereArgs: [idUsuario, idModulo],
      );
      if (result.isNotEmpty) {
        return result.first['progreso'] as double;
      } else {
        return 0.0; // Si no hay progreso guardado, iniciamos desde 0
      }
    } catch (e) {
      throw Exception('Error al obtener el progreso del módulo: $e');
    }
  }

  Future<List<Map<String, dynamic>>> obtenerJuegosPorModulo(int idModulo) async {
  final db = await database;
  return await db.query(
    'juegos',
    where: 'id_modulo = ?',
    whereArgs: [idModulo],
  );
}

  Future<void> guardarProgresoEjercicio(int idUsuario, String nombreJuego) async {
  final db = await database;

  // Revisa si ya existe el progreso
  final existing = await db.query(
    'progreso_ejercicios',
    where: 'id_usuario = ? AND nombre_juego = ?',
    whereArgs: [idUsuario, nombreJuego],
  );

  if (existing.isEmpty) {
    await db.insert('progreso_ejercicios', {
      'id_usuario': idUsuario,
      'nombre_juego': nombreJuego,
      'estado': 1, // Completado
    });
  }
}


Future<int?> obtenerIdJuegoPorNombre(String nombre) async {
  final db = await database;
  final resultado = await db.query(
    'juegos',
    where: 'nombre = ?',
    whereArgs: [nombre],
  );
  if (resultado.isNotEmpty) {
    return resultado.first['id_juego'] as int;
  }
  return null;
}



 Future<void> actualizarEstadoJuego(int idUsuario, String juego, bool desbloqueado) async {
    final db = await database;
    await db.update(
      'usuarios', // O la tabla que estés usando
      {'estado_desbloqueo': desbloqueado ? 1 : 0},
      where: 'id_usuario = ? AND juego = ?',
      whereArgs: [idUsuario, juego],
    );
  }

  Future<bool> obtenerEstadoJuego(int idUsuario, String juego) async {
    final db = await database;
    final result = await db.query(
      'usuarios', // O la tabla que estés usando
      where: 'id_usuario = ? AND juego = ?',
      whereArgs: [idUsuario, juego],
    );
    if (result.isNotEmpty) {
      return result.first['estado_desbloqueo'] == 1;
    }
    return false; // Retorna false si no se encuentra el estado.
  }




  
}


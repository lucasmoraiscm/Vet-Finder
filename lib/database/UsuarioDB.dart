import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/UsuarioModel.dart';

class UsuarioDB {
  static final UsuarioDB _instance = UsuarioDB._internal();
  factory UsuarioDB() => _instance;
  UsuarioDB._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'usuarios.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            nome TEXT, 
            email TEXT,
            senha TEXT
          )
        ''');
      },
    );
  }

  // Armazenar
  Future<int> insertUsuario(Usuario usuario) async {
    Database db = await database;

    return await db.insert('usuarios', usuario.toMap());
  }

  // Consultar
  Future<Usuario?> getUsuarioById(int id) async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      columns: ['id', 'nome', 'email', 'senha'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }

  // Alterar
  Future<int> updateUsuario(Usuario usuario) async {
    Database db = await database;

    return await db.update(
      'usuarios',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  // Excluir
  Future<int> deleteUsuario(int id) async {
    Database db = await database;

    return await db.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Logar
  Future<Usuario?> getLogin(String email, String senha) async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }
}

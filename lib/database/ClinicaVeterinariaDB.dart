import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/ClinicaVeterinariaModel.dart';

class ClinicaVeterinariaDB {
  static final ClinicaVeterinariaDB _instance = ClinicaVeterinariaDB._internal();
  factory ClinicaVeterinariaDB() => _instance;
  ClinicaVeterinariaDB._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'clinicas_veterinaria.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE clinicas_veterinaria(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            nome TEXT, 
            localizacao TEXT
          )
        ''');
      },
    );
  }

  // Armazenar
  Future<int> insertClinicaVeterinaria(ClinicaVeterinaria clinicaVeterinaria) async {
    Database db = await database;

    return await db.insert('clinicas_veterinaria', clinicaVeterinaria.toMap());
  }

  // Consultar
  Future<ClinicaVeterinaria?> getClinicaVeterinariaById(int id) async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.query(
      'clinicas_veterinaria',
      columns: ['id', 'nome', 'localizacao'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ClinicaVeterinaria.fromMap(maps.first);
    }
    return null;
  }

  // Alterar
  Future<int> updateClinicaVeterinaria(ClinicaVeterinaria clinicaVeterinaria) async {
    Database db = await database;

    return await db.update(
      'clinicas_veterinaria',
      clinicaVeterinaria.toMap(),
      where: 'id = ?',
      whereArgs: [clinicaVeterinaria.id],
    );
  }

  // Excluir
  Future<int> deleteClinicaVeterinaria(int id) async {
    Database db = await database;

    return await db.delete(
      'clinicas_veterinaria',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/ClinicaVeterinariaModel.dart';

class ClinicaVeterinariaDB {
  static final ClinicaVeterinariaDB _instance =
      ClinicaVeterinariaDB._internal();
  factory ClinicaVeterinariaDB() => _instance;
  ClinicaVeterinariaDB._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    try {
      _database = await _initDatabase();
      await _inserirClinicasSeNecessario(_database!);
      return _database!;
    } catch (e) {
      throw Exception("Erro ao inicializar o banco de dados: $e");
    }
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

  Future<void> _inserirClinicasSeNecessario(Database db) async {
    final result = await db.query('clinicas_veterinaria');

    if (result.isEmpty) {
      List<ClinicaVeterinaria> clinicas = [
        ClinicaVeterinaria(
          nome: "Amigos com Patas",
          localizacao: LatLng(-5.0956675959730156, -42.80873896815961),
        ),
        ClinicaVeterinaria(
          nome: "UbPet Teresina",
          localizacao: LatLng(-5.106485252533034, -42.80687222833813),
        ),
        ClinicaVeterinaria(
          nome: "Dr. Pet Teresina",
          localizacao: LatLng(-5.0942268277670975, -42.797168510315025),
        ),
        ClinicaVeterinaria(
          nome: "Petiaria",
          localizacao: LatLng(-5.09690779265524, -42.788498018614234),
        ),
        ClinicaVeterinaria(
          nome: "Hospital Veterinário Animal's",
          localizacao: LatLng(-5.065971027961669, -42.79395865447604),
        ),
        ClinicaVeterinaria(
          nome: "BioVet São Francisco",
          localizacao: LatLng(-5.074238872626542, -42.823974221929404),
        ),
        ClinicaVeterinaria(
          nome: "Clínica Veterinária Agroleste",
          localizacao: LatLng(-5.08036149619016, -42.77925664297075),
        ),
      ];

      for (var clinica in clinicas) {
        await db.insert('clinicas_veterinaria', clinica.toMap());
      }
    }
  }


  Future<int> insertClinicaVeterinaria(
    ClinicaVeterinaria clinicaVeterinaria,
  ) async {
    Database db = await database;
    return await db.insert('clinicas_veterinaria', clinicaVeterinaria.toMap());
  }

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

  Future<int> updateClinicaVeterinaria(
    ClinicaVeterinaria clinicaVeterinaria,
  ) async {
    Database db = await database;

    return await db.update(
      'clinicas_veterinaria',
      clinicaVeterinaria.toMap(),
      where: 'id = ?',
      whereArgs: [clinicaVeterinaria.id],
    );
  }

  Future<int> deleteClinicaVeterinaria(int id) async {
    Database db = await database;

    return await db.delete(
      'clinicas_veterinaria',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ClinicaVeterinaria>> getAllClinicas() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'clinicas_veterinaria',
    );

    return maps.map((map) => ClinicaVeterinaria.fromMap(map)).toList();
  }
}

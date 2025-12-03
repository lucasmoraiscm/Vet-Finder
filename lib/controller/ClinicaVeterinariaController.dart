import 'package:flutter/material.dart';
import '../model/ClinicaVeterinariaModel.dart';
import '../database/ClinicaVeterinariaDB.dart';

class ClinicaVeterinariaController extends ChangeNotifier {
  List<ClinicaVeterinaria> _clinicas = [];

  List<ClinicaVeterinaria> get clinicas => _clinicas;

  Future<void> loadClinicas() async {
    _clinicas = await ClinicaVeterinariaDB().getAllClinicas();
    notifyListeners();
  }

  Future<void> addClinica(ClinicaVeterinaria clinicaVeterinaria) async {
    await ClinicaVeterinariaDB().insertClinicaVeterinaria(clinicaVeterinaria);
    await loadClinicas();
    notifyListeners();
  }

  Future<void> updateClinica(ClinicaVeterinaria clinicaVeterinaria) async {
    await ClinicaVeterinariaDB().updateClinicaVeterinaria(clinicaVeterinaria);
    await loadClinicas();
    notifyListeners();
  }

  Future<void> deleteClinica(int id) async {
    await ClinicaVeterinariaDB().deleteClinicaVeterinaria(id);
    await loadClinicas();
    print("Clínica excluída e lista atualizada.");
    notifyListeners();
  }
}

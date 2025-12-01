import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:vet_finder/model/LatLngExtensions.dart';

class ClinicaVeterinaria {
  int? id;
  String nome;
  LatLng localizacao;

  ClinicaVeterinaria({this.id, required this.nome, required this.localizacao});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'localizacao': localizacao.toText()
    };
  }

  factory ClinicaVeterinaria.fromMap(Map<String, dynamic> map) {
    return ClinicaVeterinaria(
      id: map['id'], 
      nome: map['nome'], 
      localizacao: map['localizacao'].toLatLng()
    );
  }
}

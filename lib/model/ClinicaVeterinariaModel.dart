import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

class ClinicaVeterinaria {
  int? id;
  String nome;
  LatLng localizacao;

  ClinicaVeterinaria({this.id, required this.nome, required this.localizacao});

  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'nome': nome, 
      'latitude': localizacao.latitude,
      'longitude': localizacao.longitude
      };
  }

  factory ClinicaVeterinaria.fromMap(Map<String, dynamic> map) {
    return ClinicaVeterinaria(
      id: map['id'],
      nome: map['nome'],
      localizacao: LatLng(
        map['latitude'] as double, 
        map['longitude'] as double
      ),
    );
  }
}

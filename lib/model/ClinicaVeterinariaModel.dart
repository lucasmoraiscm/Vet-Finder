import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

class ClinicaVeterinaria {
  int? id;
  String nome;
  String endereco;
  LatLng localizacao;

  ClinicaVeterinaria({this.id, required this.nome, required this.endereco, required this.localizacao});

  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'nome': nome, 
      'endereco': endereco,
      'latitude': localizacao.latitude,
      'longitude': localizacao.longitude
      };
  }

  factory ClinicaVeterinaria.fromMap(Map<String, dynamic> map) {
    return ClinicaVeterinaria(
      id: map['id'],
      nome: map['nome'],
      endereco: map['endereco'],
      localizacao: LatLng(
        map['latitude'] as double, 
        map['longitude'] as double
      ),
    );
  }
}

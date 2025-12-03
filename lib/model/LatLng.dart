import 'package:google_maps_flutter/google_maps_flutter.dart';

extension LatLngParsing on LatLng {
  String toText() {
    return "$latitude,$longitude";
  }
}

extension StringToLatLng on String {
  LatLng? toLatLng() {
    try {
      final partes = split(',');
      if (partes.length != 2) return null;

      final lat = double.parse(partes[0].trim());
      final lng = double.parse(partes[1].trim());

      return LatLng(lat, lng);
    } catch (e) {
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../controller/ClinicaVeterinariaController.dart';
import '../model/ClinicaVeterinariaModel.dart';

class MapasClinicaVeterinaria extends StatefulWidget {
  const MapasClinicaVeterinaria({super.key, required this.title});

  final String title;

  @override
  State<MapasClinicaVeterinaria> createState() => _MapasClinicaVeterinaria();
}

class _MapasClinicaVeterinaria extends State<MapasClinicaVeterinaria> {
  GoogleMapController? mapController;

  final LatLng _center = const LatLng(-5.0881086268187685, -42.81057701169607);

  Set<Marker> _marcadores = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _carregarMarcadores() async {
    final controller = Provider.of<ClinicaVeterinariaController>(context, listen: false);
    await controller.loadClinicas();
    _atualizarMarcadores(controller.clinicas);
  }

  void _atualizarMarcadores(List<ClinicaVeterinaria> clinicas) {
    Set<Marker> marcadoresLocal = {};
    for (var clinica in clinicas) {
      final marker = Marker(
        markerId: MarkerId(clinica.id.toString()),
        position: clinica.localizacao,
        infoWindow: InfoWindow(title: clinica.nome),
      );
      marcadoresLocal.add(marker);
    }
    setState(() {
      _marcadores = marcadoresLocal;
    });
  }

  _localizacaoAtual() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14.0,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarMarcadores();
    _localizacaoAtual();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14.0,
        ),
        markers: _marcadores,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}

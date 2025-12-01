import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  _carregarMarcadores () {
    Set<Marker> marcadoresLocal = {};
    Marker marcado1 = Marker(
      markerId: MarkerId('01'),
      position: LatLng(-5.0956675959730156, -42.80873896815961),
      infoWindow: InfoWindow(
        title: "Amigos com Patas",
      ),
    );
    Marker marcado2 = Marker(
      markerId: MarkerId('02'),
      position: LatLng(-5.106485252533034, -42.80687222833813),
      infoWindow: InfoWindow(
        title: "UbPet Teresina",
      )
    );
    Marker marcado3 = Marker(
      markerId: MarkerId('03'),
      position: LatLng(-5.0942268277670975, -42.797168510315025),
      infoWindow: InfoWindow(
        title: "Dr. Pet Teresina",
      )
    );
    marcadoresLocal.add(marcado1);
    marcadoresLocal.add(marcado2);
    marcadoresLocal.add(marcado3);
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
      )
    );
  }
}

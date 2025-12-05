import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controller/ClinicaVeterinariaController.dart';
import '../model/ClinicaVeterinariaModel.dart';

class EditarClinicaPage extends StatefulWidget {
  final Marker clinica;

  EditarClinicaPage({required this.clinica});

  @override
  _EditarClinicaPageState createState() => _EditarClinicaPageState();
}

class _EditarClinicaPageState extends State<EditarClinicaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(
      text: widget.clinica.infoWindow.title ?? '',
    );
    _latitudeController = TextEditingController(
      text: widget.clinica.position.latitude.toString(),
    );
    _longitudeController = TextEditingController(
      text: widget.clinica.position.longitude.toString(),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  _salvarEdicao() async {
    if (_formKey.currentState?.validate() ?? false) {
      final novaClinica = ClinicaVeterinaria(
        id: int.parse(widget.clinica.markerId.value),
        nome: _nomeController.text,
        localizacao: LatLng(
          double.parse(_latitudeController.text),
          double.parse(_longitudeController.text),
        ),
      );

      final controller = Provider.of<ClinicaVeterinariaController>(
        context,
        listen: false,
      );
      await controller.updateClinica(novaClinica);

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Clínica Veterinária'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome da Clínica',
                    prefixIcon: Icon(Icons.local_hospital),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome da clínica';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _latitudeController,
                  decoration: InputDecoration(
                    labelText: 'Latitude',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a latitude';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _longitudeController,
                  decoration: InputDecoration(
                    labelText: 'Longitude',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a longitude';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _salvarEdicao,
                  child: Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controller/ClinicaVeterinariaController.dart';
import '../model/ClinicaVeterinariaModel.dart';
import 'ListagemClinicaVeterinaria.dart';

class CadastroClinicaVeterinaria extends StatefulWidget {
  const CadastroClinicaVeterinaria({super.key});

  @override
  State<CadastroClinicaVeterinaria> createState() => _CadastroClinicaVeterinariaState();
}

class _CadastroClinicaVeterinariaState extends State<CadastroClinicaVeterinaria> {
  final _nomeController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  void _fazerCadastro() async {
    final nome = _nomeController.text;
    final lat = _latController.text;
    final lng = _lngController.text;

    final controller = Provider.of<ClinicaVeterinariaController>(
      context,
      listen: false,
    );

    if (nome.isEmpty || lat.isEmpty || lng.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final clinicaVeterinaria = ClinicaVeterinaria(
      nome: nome, 
      localizacao: LatLng(double.parse(lat), double.parse(lng))
    );

    await controller.addClinica(clinicaVeterinaria);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Clínica veterinária cadastrada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
      
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Clínica Veterinária"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                'Preencha os dados abaixo', 
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 40),

              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.local_hospital),
                ),
                controller: _nomeController,
              ),
              const SizedBox(height: 20),

              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Latitude',
                  prefixIcon: Icon(Icons.location_on),
                ),
                controller: _latController,
              ),
              const SizedBox(height: 20),

              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Longitude',
                  prefixIcon: Icon(Icons.location_on),
                ),
                controller: _lngController,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _fazerCadastro,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controller/ClinicaVeterinariaController.dart';
import '../model/ClinicaVeterinariaModel.dart';

class ClinicaVeterinariaListPage extends StatefulWidget {
  @override
  _ClinicaVeterinariaListPageState createState() =>
      _ClinicaVeterinariaListPageState();
}

class _ClinicaVeterinariaListPageState
    extends State<ClinicaVeterinariaListPage> {
  Set<Marker> _marcadores = {};

  @override
  void initState() {
    super.initState();
    _carregarMarcadores();
  }

  _carregarMarcadores() async {
    final controller = Provider.of<ClinicaVeterinariaController>(
      context,
      listen: false,
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clínicas Veterinárias'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Consumer<ClinicaVeterinariaController>(
        builder: (context, controller, child) {
          return controller.clinicas.isEmpty
              ? Center(
            child: Text(
              'Nenhuma clínica cadastrada',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          )
              : ListView.builder(
            itemCount: _marcadores.length,
            itemBuilder: (context, index) {
              final marcador = _marcadores.elementAt(index);
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  title: Text(
                    marcador.infoWindow.title ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  subtitle: Text(
                    'Localização: ${marcador.position.latitude}, ${marcador.position.longitude}',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirmDelete = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Excluir'),
                          content: Text(
                            'Você tem certeza que deseja excluir esta clínica?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, false),
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, true),
                              child: Text('Excluir'),
                            ),
                          ],
                        ),
                      );

                      if (confirmDelete) {
                        await controller.deleteClinica(
                          int.parse(marcador.markerId.value),
                        );
                        _carregarMarcadores();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Clínica excluída com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

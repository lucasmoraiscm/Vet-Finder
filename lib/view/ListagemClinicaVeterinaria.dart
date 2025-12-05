import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controller/ClinicaVeterinariaController.dart';
import '../model/ClinicaVeterinariaModel.dart';
import './EditarClinica.dart';

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

  void _showClinicaDetails(ClinicaVeterinaria clinica) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Detalhes da Clínica',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nome: ${clinica.nome}',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Latitude: ${clinica.localizacao.latitude}',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Longitude: ${clinica.localizacao.longitude}',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Fechar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
          if (controller.clinicas.isEmpty) {
            return Center(
              child: Text(
                'Nenhuma clínica cadastrada',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: _marcadores.length,
            itemBuilder: (context, index) {
              final marcador = _marcadores.elementAt(index);
              final clinica = controller.clinicas.firstWhere(
                (c) => c.id.toString() == marcador.markerId.value,
              );

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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditarClinicaPage(clinica: marcador),
                            ),
                          );

                          if (result != null && result) {
                            _carregarMarcadores(); // Recarregar marcadores após edição
                          }
                        },
                      ),
                      IconButton(
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
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Excluir'),
                                ),
                              ],
                            ),
                          );

                          if (confirmDelete) {
                            await controller.deleteClinica(
                              int.parse(marcador.markerId.value),
                            );
                            _carregarMarcadores(); // Recarregar marcadores após exclusão
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Clínica excluída com sucesso!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    _showClinicaDetails(clinica);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

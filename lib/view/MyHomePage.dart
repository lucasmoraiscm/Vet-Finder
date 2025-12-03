import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './MapasClinicaVeterinaria.dart';
import './ListagemClinicaVeterinaria.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _verMapa() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapasClinicaVeterinaria(title: widget.title),
      ),
    );
  }

  void _verListaClinicas() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClinicaVeterinariaListPage(),
      ), // Navega para a listagem
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verMapa,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Mapas', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _verListaClinicas, // Chama a função para navegar para a lista
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor:
                        Colors.green, // Você pode escolher a cor que preferir
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Clínicas Veterinárias',
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

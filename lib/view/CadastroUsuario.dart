import 'package:flutter/material.dart';
import '../controller/UsuarioController.dart';
import 'LoginUsuario.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({super.key});

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  final _usuarioController = UsuarioController();

  void _fazerCadastro() async {
    final nome = _nomeController.text;
    final email = _emailController.text;
    final senha = _senhaController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    int id = await _usuarioController.cadastrar(nome, email, senha);

    if (!mounted) return;

    if (id > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário cadastrado com sucesso! Faça login.'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const LoginUsuario())
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao cadastrar usuário.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Usuário"),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => const LoginUsuario())
            );
          },
        ),
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
                  prefixIcon: Icon(Icons.person),
                ),
                controller: _nomeController,
              ),
              const SizedBox(height: 20),

              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email),
                ),
                controller: _emailController,
              ),
              const SizedBox(height: 20),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.password),
                ),
                controller: _senhaController,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity, // Botão esticado
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

import 'package:flutter/material.dart';
import '../controller/UsuarioController.dart';
import './CadastroUsuario.dart';
import './MyHomePage.dart';

class LoginUsuario extends StatefulWidget {
  const LoginUsuario({super.key});

  @override
  State<LoginUsuario> createState() => _LoginUsuarioState();
}

class _LoginUsuarioState extends State<LoginUsuario> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  final _usuarioController = UsuarioController();

  void _fazerLogin() async {
    final email = _emailController.text;
    final senha = _senhaController.text;

    bool loginSucesso = await _usuarioController.logar(email, senha);

    if (!mounted) return; 

    if (loginSucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'Pet Finder')));
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail ou senha incorretos.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _irCadastro() {
     Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroUsuario()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView( 
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(Icons.pets, size: 80, color: Colors.green),
              const SizedBox(height: 30),

              TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'E-mail',
              ),
              controller: _emailController,
              ),
              const SizedBox(height: 20),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                ),
                controller: _senhaController,
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity, 
                child: ElevatedButton(
                  onPressed: _fazerLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity, 
                child: ElevatedButton(
                  onPressed: _irCadastro,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Cadastrar-se',
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

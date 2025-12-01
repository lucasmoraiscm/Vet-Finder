import '../database/UsuarioDB.dart';
import '../model/UsuarioModel.dart';

class UsuarioController {
  final UsuarioDB _db = UsuarioDB();

  Future<bool> logar(String email, String senha) async {
    if (email.isEmpty || senha.isEmpty) {
      return false;
    }

    Usuario? usuario = await _db.getLogin(email, senha);
    
    return usuario != null;
  }

  Future<int> cadastrar(String nome, String email, String senha) async {
    final novoUsuario = Usuario(
      nome: nome, 
      email: email, 
      senha: senha
    );

    return await _db.insertUsuario(novoUsuario);
  }
}

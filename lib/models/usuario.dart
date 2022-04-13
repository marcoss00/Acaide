import 'cidade.dart';

class Usuario {
  final String id;
  final String nome;
  final String email;
  final Cidade cidade;
  final String telefone;
  final String senha;
  final String foto_perfil;

  Usuario(
      this.id, this.nome, this.email, this.cidade, this.telefone, this.senha, this.foto_perfil);
}

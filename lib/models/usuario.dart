class Usuario {
  final String id;
  final String nome;
  final String email;
  final Map<String, int> cidade;
  final String telefone;
  final String foto_perfil;
  final String cpf;

  Usuario(
      {required this.id,
      required this.nome,
      required this.email,
      required this.cidade,
      required this.telefone,
      required this.foto_perfil,
      required this.cpf});
}

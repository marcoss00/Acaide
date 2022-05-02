class Anuncio {
  final String id;
  final String idUsuario;
  final String titulo;
  final bool tipo_anunciante;
  final int quant_rasas;
  final bool entrega;
  final double preco;
  final Map<String, int> cidades;
  final String imagem;
  final String descricao;
  final DateTime dataCriacao;
  final String fotoPerfilUsuario;
  final String nomeUsuario;
  final String telefoneUsuario;

  Anuncio({
    required this.id,
    required this.idUsuario,
    required this.titulo,
    required this.tipo_anunciante,
    required this.entrega,
    required this.preco,
    required this.cidades,
    required this.imagem,
    required this.quant_rasas,
    required this.descricao,
    required this.dataCriacao,
    required this.fotoPerfilUsuario,
    required this.nomeUsuario,
    required this.telefoneUsuario,
  });
}

import 'dart:io';

class Anuncio {
  final String titulo;
  final int tipo_anunciante;
  final int quant_telas;
  final bool entrega;
  final double preco;
  final int regiao;
  final File imagem;
  final String descricao;

  Anuncio(this.titulo, this.tipo_anunciante, this.entrega, this.preco,
      this.regiao, this.imagem, this.quant_telas, this.descricao);
}

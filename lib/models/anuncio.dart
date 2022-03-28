import 'dart:io';
import 'cidade.dart';

class Anuncio {
  final String titulo;
  final bool? tipo_anunciante;
  final int? quant_telas;
  final bool? entrega;
  final double? preco;
  final List<Object?>? cidades;
  final File imagem;
  final String? descricao;

  Anuncio(this.titulo, this.tipo_anunciante, this.entrega, this.preco,
      this.cidades, this.imagem, this.quant_telas, this.descricao);
}

import 'package:acaide/models/cidades_repository.dart';

class PrecoMedio extends CidadesRepository{
  final double preco_medio;
  final String cidade;
  final int quant_anuncio;

  PrecoMedio({
    required this.preco_medio,
    required this.cidade,
    required this.quant_anuncio,
  });
}

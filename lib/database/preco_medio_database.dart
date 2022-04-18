import 'package:acaide/models/preco_medio.dart';

class PrecoMedioDatabase {
  Future<List<PrecoMedio>> findAllPrecoMedio() async {
    final List<PrecoMedio> precosMedio = [];
    //overflow problem
    precosMedio
        .add(PrecoMedio(preco_medio: 110.0, cidade: "Belém", quant_anuncio: 6));
    precosMedio
        .add(PrecoMedio(preco_medio: 1, cidade: "Abaetetuba", quant_anuncio: 10));
    return precosMedio;
  }
}

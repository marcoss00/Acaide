import 'package:acaide/database/anuncio_database.dart';
import 'package:acaide/models/anuncio.dart';
import 'package:acaide/models/cidade.dart';
import 'package:acaide/models/cidades_repository.dart';
import 'package:acaide/models/preco_medio.dart';

class PrecoMedioDatabase {
  final AnuncioDatabase _dao = AnuncioDatabase();
  final CidadesRepository apiCidades = CidadesRepository();

  Future<List<PrecoMedio>> findAllPrecoMedio() async {
    final List<Anuncio> anuncios = await _dao.findAllAnuncio();
    final List<Cidade> cidades = await apiCidades.getCidadesFromAPI();
    final List<PrecoMedio> precosMedio = [];
    List<double> somaPreco = [];
    List<int> quant_anuncio = [];
    List<double> precoMedioList = [];
    for (int j = 0; j < cidades.length; j++) {
      somaPreco.add(0.0);
      quant_anuncio.add(0);
      precoMedioList.add(0.0);
    }
    for (int i = 0; i < cidades.length; i++) {
      anuncios.forEach((anuncio) {
        anuncio.cidades.forEach((key, value) {
          if (key == cidades[i].nome && anuncio.tipo_anunciante) {
            quant_anuncio[i] = quant_anuncio[i] + 1;
            somaPreco[i] = somaPreco[i] + anuncio.preco;
          }
        });
      });
      if (quant_anuncio[i] != 0) {
        precoMedioList[i] = somaPreco[i] / quant_anuncio[i];
      }
      final PrecoMedio precoMedio = PrecoMedio(
          preco_medio: precoMedioList[i],
          cidade: cidades[i].nome!,
          quant_anuncio: quant_anuncio[i]);
      precosMedio.add(precoMedio);
    }
    return precosMedio;
  }
}

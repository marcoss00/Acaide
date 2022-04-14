import 'package:acaide/components/anuncio_item.dart';
import 'package:acaide/components/drawer_item.dart';
import 'package:acaide/database/anuncio_database.dart';
import 'package:acaide/models/anuncio.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import '../models/cidade.dart';
import '../models/cidades_repository.dart';

List<Anuncio>? anunciosFiltrados = [];
final CidadesRepository _cidades = CidadesRepository();
List<Object?> _cidadesSelecionadas = [_cidades.cidadesList[18]];
bool delayInicio = true;

class AnunciosList extends StatefulWidget {
  AnunciosList({Key? key}) : super(key: key);

  @override
  State<AnunciosList> createState() => _AnunciosListState();
}

class _AnunciosListState extends State<AnunciosList> {
  final AnuncioDatabase _dao = AnuncioDatabase();

  carregarApi() async {
    var cidadesList = await _cidades.getCidadesFromAPI();
    return cidadesList;
    //função feita apenas pra carregar api das cidades junto com a screen.
    //Não precisa retornar "cidadesList", mas coloquei pra retornar só pra não ficar o aviso que a variavel n ta sendo usada.
  }

  @override
  void initState() {
    super.initState();
    carregarApi();
    delayInicio = true;
    Future.delayed(
        Duration(seconds: 2), () => setState(() => delayInicio = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[800],
      drawer: Drawer(
        child: DrawerItem(),
      ),
      appBar: AppBar(
        title: Text(
          "Feira Virtual de Açaí",
          style: TextStyle(
            fontFamily: "Cookie",
            fontSize: 28.0,
          ),
        ),
        backgroundColor: Colors.purple[800],
        actions: [
          IconButton(
            onPressed: () => _showMultiSelect(context),
            icon: Icon(Icons.location_on),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: (delayInicio)
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : FutureBuilder<List<Anuncio>>(
              initialData: [],
              future: _dao.findAllAnuncio(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    break;
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  case ConnectionState.active:
                    break;
                  case ConnectionState.done:
                    anunciosFiltrados = filtroCidades(snapshot);
                    return RefreshIndicator(
                      onRefresh: () => _reloadList(snapshot),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: anunciosFiltrados?.length,
                        itemBuilder: (context, indice) {
                          final anuncio = anunciosFiltrados![indice];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AnuncioItem(
                                anuncio: anuncio,
                                onLongTap: () {},
                                botoes: Container(),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                }
                return Text("Erro desconhecido!");
              },
            ),
    );
  }

  filtroCidades(AsyncSnapshot<List<Anuncio>> snapshot) {
    List<Anuncio>? anuncios = snapshot.data;
    List<int> cidadesSelecionadasId = [];
    final Map<String, int> cidadesSelecionadasMap = Map.fromIterable(
        _cidadesSelecionadas,
        key: (cidade) => cidade.nome,
        value: (cidade) => cidade.id);
    cidadesSelecionadasMap.forEach((key, value) {
      cidadesSelecionadasId.add(value);
    });
    for (int i = 0; i < anuncios!.length; i++) {
      bool temCidade = false;
      List<int> cidadesAnuncioId = [];
      final Map<String, int> cidadesAnuncioMap = anuncios[i].cidades;
      cidadesAnuncioMap.forEach((key, value) {
        cidadesAnuncioId.add(value);
      });
      for (int j = 0; j < cidadesSelecionadasId.length; j++) {
        for (int k = 0; k < cidadesAnuncioId.length; k++) {
          if (cidadesSelecionadasId[j] == cidadesAnuncioId[k]) {
            temCidade = true;
          }
        }
      }
      if (temCidade == false) {
        anuncios.remove(anuncios[i]);
        i = i - 1;
      }
    }
    return anuncios;
  }

  Future<void> _reloadList(AsyncSnapshot snapshot) async {
    var newList =
        await Future.delayed(Duration(seconds: 2), () => snapshot.data);
    setState(() {
      anunciosFiltrados = filtroCidades(newList);
    });
  }

  Future<void> _showMultiSelect(BuildContext context) async {
    var cidadesList = await _cidades.getCidadesFromAPI();
    final _itens = cidadesList
        .map((cidade) => MultiSelectItem<Cidade>(cidade, cidade.nome!))
        .toList();
    return showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            MultiSelectDialogField(
              decoration: BoxDecoration(),
              buttonIcon: Icon(
                null,
                color: Colors.white,
              ),
              buttonText: Text(
                "Selecione o(s) Município(s)",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
              initialValue: _cidadesSelecionadas,
              searchable: true,
              items: _itens,
              separateSelectedItems: true,
              title: Text("Municípios:"),
              selectedColor: Colors.purple,
              onConfirm: (resultado) {
                _cidadesSelecionadas = resultado;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AnunciosList(),
                  ),
                );
              },
              searchIcon: Icon(Icons.search),
              selectedItemsTextStyle: TextStyle(color: Colors.green),
              chipDisplay: MultiSelectChipDisplay(
                scroll: true,
                chipColor: Colors.purple[800],
                textStyle: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

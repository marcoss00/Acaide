import 'package:acaide/components/anuncio_item.dart';
import 'package:acaide/components/drawer_item.dart';
import 'package:acaide/database/anuncio_database.dart';
import 'package:acaide/models/anuncio.dart';
import 'package:acaide/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import '../models/cidade.dart';
import '../models/cidades_repository.dart';

final CidadesRepository _cidades = CidadesRepository();
List<Object?> _cidadesSelecionadas = [];
bool showTextField = false;

class AnunciosList extends StatefulWidget {
  final Usuario usuario;
  final List<Cidade> cidades;

  AnunciosList(this.usuario, this.cidades);

  @override
  State<AnunciosList> createState() => _AnunciosListState();
}

class _AnunciosListState extends State<AnunciosList> {
  List<Anuncio> anunciosFiltrados = [];
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[800],
      drawer: (showTextField)
          ? null
          : Drawer(
              child: DrawerItem(widget.usuario, widget.cidades),
            ),
      appBar: AppBar(
        title: (showTextField)
            ? Container(
                height: 40,
                child: TextField(
                  onChanged: (busca) => buscaAnuncio(busca),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showTextField = false;
                        });
                      },
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Buscar anúncio:",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : Text(
                "Feira Virtual de Açaí",
                style: TextStyle(
                  fontFamily: "Cookie",
                  fontSize: 28.0,
                ),
              ),
        backgroundColor: Colors.purple[800],
        actions: [
          (showTextField)
              ? Container()
              : IconButton(
                  onPressed: () => _showMultiSelect(context),
                  icon: Icon(Icons.location_on),
                ),
          (showTextField)
              ? Container()
              : IconButton(
                  onPressed: () {
                    setState(() {
                      showTextField = true;
                    });
                  },
                  icon: Icon(Icons.search),
                ),
        ],
      ),
      body: FutureBuilder<List<Anuncio>>(
        initialData: [],
        future: _dao.findAllAnuncioFiltrado(_cidadesSelecionadas),
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
              if (!showTextField) {
                anunciosFiltrados = snapshot.data!;
              }
              return RefreshIndicator(
                onRefresh: () => _reloadList(snapshot),
                child: (anunciosFiltrados.isEmpty)
                    ? SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: Text(
                              "Nenhum anúncio encontrado",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: anunciosFiltrados.length,
                        itemBuilder: (context, indice) {
                          final anuncio = anunciosFiltrados[indice];
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

  void buscaAnuncio(String query) async {
    final List<Anuncio> anuncios =
        await _dao.findAllAnuncioFiltrado(_cidadesSelecionadas);
    final List<Anuncio> busca = anuncios.where((anuncio) {
      final String tituloAnuncio = anuncio.titulo.toLowerCase();
      final String saida = query.toLowerCase();

      return tituloAnuncio.contains(saida);
    }).toList();
    setState(() => anunciosFiltrados = busca);
  }

  Future<void> _reloadList(AsyncSnapshot snapshot) async {
    if (!showTextField) {
      var newList =
          await Future.delayed(Duration(seconds: 2), () => snapshot.data);
      setState(() {
        anunciosFiltrados = newList;
      });
    }
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
                    builder: (context) =>
                        AnunciosList(widget.usuario, widget.cidades),
                  ),
                );
              },
              searchIcon: Icon(Icons.search),
              searchHint: 'Buscar Município',
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

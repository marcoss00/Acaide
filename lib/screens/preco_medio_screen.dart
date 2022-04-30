import 'package:acaide/components/drawer_item.dart';
import 'package:acaide/components/preco_medio_card.dart';
import 'package:acaide/database/preco_medio_database.dart';
import 'package:acaide/models/preco_medio.dart';
import 'package:acaide/models/usuario.dart';
import 'package:flutter/material.dart';
import '../models/cidade.dart';

bool showTextField = false;

class PrecoMedioScreen extends StatefulWidget {
  final Usuario usuario;
  final List<Cidade> cidades;

  PrecoMedioScreen(this.usuario, this.cidades);

  @override
  State<PrecoMedioScreen> createState() => _PrecoMedioScreenState();
}

class _PrecoMedioScreenState extends State<PrecoMedioScreen> {
  final PrecoMedioDatabase _dao = PrecoMedioDatabase();
  List<PrecoMedio> precosMedio = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[800],
      drawer: Drawer(
        child: DrawerItem(widget.usuario, widget.cidades),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: (showTextField)
            ? Container(
                height: 40,
                child: TextField(
                  onChanged: (busca) => buscaPrecoMedio(busca),
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
                    labelText: "Buscar município:",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : Text(
                "Preço Médio",
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
                  onPressed: () => aviso(),
                  icon: Icon(Icons.announcement_outlined),
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
      body: FutureBuilder<List<PrecoMedio>>(
        initialData: [],
        future: _dao.findAllPrecoMedio(),
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
                precosMedio = snapshot.data!;
              }
              return RefreshIndicator(
                onRefresh: () => _reloadList(snapshot),
                child: (precosMedio.isEmpty)
                    ? SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: Text(
                              "Nada encontrado",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: precosMedio.length,
                        itemBuilder: (context, indice) {
                          final precoMedio = precosMedio[indice];
                          return Padding(
                            padding: const EdgeInsets.only(
                                right: 15, left: 15, top: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PrecoMedioCard(precoMedio: precoMedio),
                              ],
                            ),
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

  void buscaPrecoMedio(String query) async {
    final List<PrecoMedio> precosMedioList = await _dao.findAllPrecoMedio();
    final List<PrecoMedio> busca = precosMedioList.where((precoMedio) {
      final String nomeCidade = precoMedio.cidade.toLowerCase();
      final String saida = query.toLowerCase();

      return nomeCidade.contains(saida);
    }).toList();
    setState(() => precosMedio = busca);
  }

  Future<void> _reloadList(AsyncSnapshot snapshot) async {
    if (!showTextField) {
      var newList =
          await Future.delayed(Duration(seconds: 2), () => snapshot.data);
      setState(() {
        precosMedio = newList;
      });
    }
  }

  Future<void> aviso() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Aviso"),
            content: Text(
                "O preço médio de cada cidade é calculado com base apenas nos anúncios dos produtores."),
          );
        });
  }
}

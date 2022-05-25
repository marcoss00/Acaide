import 'package:acaide/components/anuncio_item.dart';
import 'package:acaide/components/drawer_item.dart';
import 'package:acaide/database/anuncio_database.dart';
import 'package:acaide/models/anuncio.dart';
import 'package:acaide/models/cidade.dart';
import 'package:acaide/models/usuario.dart';
import 'package:acaide/screens/anuncio_detalhes_screen.dart';
import 'package:acaide/screens/anuncio_form.dart';
import 'package:acaide/screens/anuncio_form_edicao.dart';
import 'package:flutter/material.dart';

List<Anuncio>? anuncios = [];
bool delayInicio = true;

class MeusAnunciosList extends StatefulWidget {
  final Usuario usuario;
  final List<Cidade> cidades;

  MeusAnunciosList(this.usuario, this.cidades);

  @override
  State<MeusAnunciosList> createState() => _MeusAnunciosListState();
}

class _MeusAnunciosListState extends State<MeusAnunciosList> {
  final AnuncioDatabase _dao = AnuncioDatabase();

  @override
  void initState() {
    super.initState();
    delayInicio = true;
    Future.delayed(
        Duration(seconds: 2), () => setState(() => delayInicio = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[800],
      drawer: Drawer(
        child: DrawerItem(widget.usuario, widget.cidades),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Meus Anúncios",
          style: TextStyle(
            fontFamily: "Cookie",
            fontSize: 28.0,
          ),
        ),
        backgroundColor: Colors.purple[800],
        actions: [
          //IconButton(
          //onPressed: () {},
          //icon: Icon(Icons.more_vert_rounded),
          //),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 255, 240, 255),
        child: Text(
          "+",
          style: TextStyle(fontSize: 28, color: Colors.purple[800]),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AnuncioForm(widget.usuario, widget.cidades),
            ),
          );
        },
      ),
      body: (delayInicio)
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : FutureBuilder<List<Anuncio>>(
              initialData: [],
              future: _dao.findAnuncioUsuario(widget.usuario.id),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                      child: Text('Nada encontrado. Tente novamente'),
                    );
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  case ConnectionState.active:
                    return Center(
                      child: Text('Conexão incompleta'),
                    );
                  case ConnectionState.done:
                    anuncios = snapshot.data;
                    return RefreshIndicator(
                      onRefresh: () => _reloadList(snapshot),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: anuncios?.length,
                        itemBuilder: (context, indice) {
                          final Anuncio anuncio = anuncios![indice];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AnuncioItem(
                                anuncio: anuncio,
                                onLongTap: () {
                                  _showDialog(anuncio);
                                },
                                botoes: Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        final String preco = anuncio.preco.toString().replaceAll(".", ",");
                                        final String precoRaza = "${preco} R\$";
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => AnuncioFormEdicao(widget.usuario, widget.cidades, anuncio, precoRaza),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.edit),
                                      color: Colors.yellow,
                                    ),
                                    IconButton(
                                      onPressed: () => _deleteDialog(anuncio),
                                      icon: Icon(Icons.delete),
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                }
              },
            ),
    );
  }

  Future<void> _reloadList(AsyncSnapshot snapshot) async {
    var newList =
        await Future.delayed(Duration(seconds: 2), () => snapshot.data);
    setState(() {
      anuncios = newList;
    });
  }

  Future<void> _showDialog(Anuncio anuncio) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AnuncioDetalhesScreen(anuncio),
                  ),
                );
              },
              child: Text("Visualizar"),
            ),
            SimpleDialogOption(
              onPressed: () {
                final String preco = anuncio.preco.toString().replaceAll(".", ",");
                final String precoRaza = "${preco} R\$";
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AnuncioFormEdicao(widget.usuario, widget.cidades, anuncio, precoRaza),
                  ),
                );
              },
              child: Text("Editar"),
            ),
            SimpleDialogOption(
              onPressed: () => _deleteDialog(anuncio),
              child: Text("Excluir"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDialog(Anuncio anuncio) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Excluir Anúncio'),
        content: const Text('Você tem certeza?'),
        actions: [
          TextButton(
            child: const Text('Sim'),
            onPressed: () {
              _dao.deleteAnuncio(anuncio);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      MeusAnunciosList(widget.usuario, widget.cidades),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Anúncio Deletado Com Sucesso!'),
                ),
              );
            },
          ),
          TextButton(
            child: const Text('Não'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}

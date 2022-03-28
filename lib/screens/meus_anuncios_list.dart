import 'package:acaide/components/anuncio_item.dart';
import 'package:acaide/components/drawer_item.dart';
import 'package:acaide/models/anuncio.dart';
import 'package:acaide/screens/anuncio_form.dart';
import 'package:flutter/material.dart';

class MeusAnunciosList extends StatefulWidget {
  final List<Anuncio> _anuncios = [];

  MeusAnunciosList({Key? key}) : super(key: key);

  @override
  State<MeusAnunciosList> createState() => _MeusAnunciosListState();
}

class _MeusAnunciosListState extends State<MeusAnunciosList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[800],
      drawer: Drawer(
        child: DrawerItem(),
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
          final Future<Anuncio?> future = Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return AnuncioForm();
            }),
          );
          future.then(
                (anuncioRecebido) => _atualiza(anuncioRecebido),
          );
        },
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount:widget._anuncios.length,
        itemBuilder: (context, indice) {
          final anuncio = widget._anuncios[indice];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnuncioItem(
                anuncio: anuncio,
                onLongTap: () {
                  _showDialog();
                },
                botoes: Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit),
                      color: Colors.yellow,
                    ),
                    IconButton(
                      onPressed: () => _deleteDialog(),
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

  void _atualiza(Anuncio? anuncioRecebido) {
    setState(() {
      widget._anuncios.add(anuncioRecebido!);
    });
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: () {},
              child: Text("Visualizar"),
            ),
            SimpleDialogOption(
              onPressed: () {},
              child: Text("Editar"),
            ),
            SimpleDialogOption(
              onPressed: () => _deleteDialog(),
              child: Text("Excluir"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Excluir Anúncio'),
        content: const Text('Você tem certeza?'),
        actions: [
          TextButton(
            child: const Text('Sim'),
            onPressed: () {},
          ),
          TextButton(
            child: const Text('Não'),
            onPressed: () {},
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}

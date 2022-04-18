import 'package:acaide/components/drawer_item.dart';
import 'package:acaide/components/preco_medio_card.dart';
import 'package:acaide/database/preco_medio_database.dart';
import 'package:acaide/models/preco_medio.dart';
import 'package:flutter/material.dart';

class MediaPrecoScreen extends StatefulWidget {
  const MediaPrecoScreen({Key? key}) : super(key: key);

  @override
  State<MediaPrecoScreen> createState() => _MediaPrecoScreenState();
}

class _MediaPrecoScreenState extends State<MediaPrecoScreen> {
  final PrecoMedioDatabase _dao = PrecoMedioDatabase();
  List<PrecoMedio> precosMedio = [];

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
          "Preço Médio",
          style: TextStyle(
            fontFamily: "Cookie",
            fontSize: 28.0,
          ),
        ),
        backgroundColor: Colors.purple[800],
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.announcement_outlined),
          ),
          IconButton(
            onPressed: () {},
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
              precosMedio = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: precosMedio.length,
                itemBuilder: (context, indice) {
                  final precoMedio = precosMedio[indice];
                  return Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrecoMedioCard(precoMedio: precoMedio),
                      ],
                    ),
                  );
                },
              );
          }
          return Text("Erro desconhecido!");
        },
      ),
    );
  }
}
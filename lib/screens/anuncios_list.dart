import 'package:acaide/components/anuncio_item.dart';
import 'package:acaide/components/drawer_item.dart';
import 'package:acaide/models/anuncio.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import '../models/cidade.dart';
import '../models/cidades.dart';

final Cidades _cidades = Cidades();
List<Object?> _cidadesSelecionadas = [_cidades.cidadesList[0]];
final _itens = _cidades.cidadesList
    .map((cidade) => MultiSelectItem<Cidade>(cidade, cidade.name!))
    .toList();

class AnunciosList extends StatefulWidget {
  final List<Anuncio> _anuncios = [];

  AnunciosList({Key? key}) : super(key: key);

  @override
  State<AnunciosList> createState() => _AnunciosListState();
}

class _AnunciosListState extends State<AnunciosList> {
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
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget._anuncios.length,
        itemBuilder: (context, indice) {
          final anuncio = widget._anuncios[indice];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnuncioItem(anuncio: anuncio),
            ],
          );
        },),
    );
  }

  Future<void> _showMultiSelect(BuildContext context) async {
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

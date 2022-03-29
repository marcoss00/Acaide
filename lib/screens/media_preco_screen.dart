import 'package:acaide/components/drawer_item.dart';
import 'package:acaide/models/media_preco.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediaPrecoScreen extends StatefulWidget {
  const MediaPrecoScreen({Key? key}) : super(key: key);

  @override
  State<MediaPrecoScreen> createState() => _MediaPrecoScreenState();
}

class _MediaPrecoScreenState extends State<MediaPrecoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        title: Text(
          "Preço Médio",
          style: TextStyle(
            fontFamily: "Cookie",
            fontSize: 28.0,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: DrawerItem(),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Consumer<MediaPreco>(
              builder: (context, valor, child) {
                return Text(
                  valor.toString(),
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

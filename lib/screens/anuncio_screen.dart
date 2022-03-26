import 'package:acaide/components/drawer_item.dart';
import 'package:flutter/material.dart';

class AnuncioScreen extends StatefulWidget {
  const AnuncioScreen({Key? key}) : super(key: key);

  @override
  State<AnuncioScreen> createState() => _AnuncioScreenState();
}

class _AnuncioScreenState extends State<AnuncioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawerItem(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        title: Text(
          "Anúncio",
          style: TextStyle(
            fontFamily: "Cookie",
            fontSize: 28.0,
          ),
        ),
      ),
      body: Container(),
      //body:
    );
  }
}

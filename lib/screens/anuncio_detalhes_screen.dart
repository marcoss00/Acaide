import 'package:flutter/material.dart';

class AnuncioDetalhesScreen extends StatefulWidget {
  const AnuncioDetalhesScreen({Key? key}) : super(key: key);

  @override
  State<AnuncioDetalhesScreen> createState() => _AnuncioDetalhesScreenState();
}

class _AnuncioDetalhesScreenState extends State<AnuncioDetalhesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Detalhes Anúncio",
          style: TextStyle(
            fontFamily: "Cookie",
            fontSize: 28.0,
          ),
        ),
        backgroundColor: Colors.purple[800],
      ),
    );
  }
}


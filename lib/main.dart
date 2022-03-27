import 'package:acaide/models/media_preco.dart';
import 'package:acaide/screens/anuncio_form.dart';
import 'package:acaide/screens/anuncios_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (context) => MediaPreco(100.0),
      child: AcaideApp(),
    ));

class AcaideApp extends StatelessWidget {
  const AcaideApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnunciosList(),
    );
  }
}

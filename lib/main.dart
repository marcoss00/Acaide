import 'package:acaide/screens/anuncios_list.dart';
import 'package:flutter/material.dart';

void main() => runApp(AcaideApp());

class AcaideApp extends StatelessWidget {
  const AcaideApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnunciosList(),
    );
  }
}

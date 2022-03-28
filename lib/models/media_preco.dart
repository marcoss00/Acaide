import 'package:flutter/material.dart';

class MediaPreco extends ChangeNotifier{
  //Usar o NumberFormat
  final double valor;

  MediaPreco(this.valor);

  @override
  String toString() {
    return 'R\$ $valor';
  }
}

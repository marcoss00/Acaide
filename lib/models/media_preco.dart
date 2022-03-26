import 'package:flutter/material.dart';

class MediaPreco extends ChangeNotifier{
  //trocar o tipo de dado de DOUBLE para (perguntar para o Casseb)
  //Usar o NumberFormat
  final double valor;

  MediaPreco(this.valor);

  @override
  String toString() {
    return 'R\$ $valor';
  }
}

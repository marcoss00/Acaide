import 'package:acaide/models/cidade.dart';
import 'package:flutter/material.dart';

class Cidades {

  final List<Cidade> cidadesList = [
    Cidade(id: 0, name: "Belém"),
    Cidade(id: 1, name: "Castanhal"),
    Cidade(id: 2, name: "Abaetetuba"),
    Cidade(id: 3, name: "Igarapé Miri"),
  ];

  List<DropdownMenuItem<String>> get cidadesDropdown {
    List<DropdownMenuItem<String>> cidadeItens = [
      DropdownMenuItem(
        child: Text(cidadesList[0].name.toString()),
        value: cidadesList[0].id.toString(),
      ),
      DropdownMenuItem(
        child: Text(cidadesList[1].name.toString()),
        value: cidadesList[1].id.toString(),
      ),
      DropdownMenuItem(
        child: Text(cidadesList[2].name.toString()),
        value: cidadesList[2].id.toString(),
      ),
      DropdownMenuItem(
        child: Text(cidadesList[3].name.toString()),
        value: cidadesList[3].id.toString(),
      ),
    ];
    return cidadeItens;
  }
}
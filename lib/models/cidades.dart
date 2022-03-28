import 'package:acaide/models/cidade.dart';
import 'package:flutter/material.dart';

class Cidades {

  final List<Cidade> cidadesList = [
    Cidade(id: 0, name: "Belém"),
    Cidade(id: 1, name: "Igarapé Miri"),
    Cidade(id: 2, name: "Cametá"),
    Cidade(id: 3, name: "Abaetetuba"),
    Cidade(id: 4, name: "Barcarena"),
    Cidade(id: 5, name: "Bujaru"),
    Cidade(id: 6, name: "Santa Izabel do Pará"),
    Cidade(id: 7, name: "Anajás"),
    Cidade(id: 8, name: "Bagre"),
    Cidade(id: 9, name: "Limoeiro do Ajuru"),
    Cidade(id: 10, name: "Oeiras do Pará"),
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
      DropdownMenuItem(
        child: Text(cidadesList[4].name.toString()),
        value: cidadesList[4].id.toString(),
      ),
      DropdownMenuItem(
        child: Text(cidadesList[5].name.toString()),
        value: cidadesList[5].id.toString(),
      ),
      DropdownMenuItem(
        child: Text(cidadesList[6].name.toString()),
        value: cidadesList[6].id.toString(),
      ),
      DropdownMenuItem(
        child: Text(cidadesList[7].name.toString()),
        value: cidadesList[7].id.toString(),
      ),
      DropdownMenuItem(
        child: Text(cidadesList[8].name.toString()),
        value: cidadesList[8].id.toString(),
      ),
      DropdownMenuItem(
        child: Text(cidadesList[9].name.toString()),
        value: cidadesList[9].id.toString(),
      ),
      DropdownMenuItem(
        child: Text(cidadesList[10].name.toString()),
        value: cidadesList[10].id.toString(),
      ),
    ];
    return cidadeItens;
  }
}
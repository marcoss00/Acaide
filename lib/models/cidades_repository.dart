import 'package:acaide/models/cidade.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const quantidadeCidadesPara = 144;
const uri =
    "https://servicodados.ibge.gov.br/api/v1/localidades/estados/15/municipios?orderBy=nome";

class CidadesRepository {
  List<Cidade> cidadesList = [];
  bool primeiraBusca = true;

  Future<List<DropdownMenuItem<String>>> get cidadesDropdown async {
    List<DropdownMenuItem<String>> cidadeItens = [];
    cidadesList = await getCidadesFromAPI();
    cidadesList.forEach((cidade) {
      cidadeItens.add(DropdownMenuItem(
        child: Text(cidade.nome.toString()),
        value: cidade.id.toString(),
      ));
    });
    return cidadeItens;
  }

  Future<List<Cidade>> getCidadesFromAPI() async {
    if (primeiraBusca) {
      primeiraBusca = false;
      var response = await http.get(Uri.parse(uri));
      var json = jsonDecode(response.body);
      for (int i = 0; i < quantidadeCidadesPara; i++) {
        var cidadeApi = json[i];
        final int? idInteiro = int.tryParse(cidadeApi['id']);
        final Cidade cidade = Cidade(nome: cidadeApi['nome'], id: idInteiro);
        cidadesList.add(cidade);
      }
    }
    return cidadesList;
  }
}

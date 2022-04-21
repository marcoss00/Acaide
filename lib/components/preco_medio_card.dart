import 'package:acaide/models/preco_medio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const kPrimaryColor = Color(0xff00444f);
const kSecondaryColor = Color(0xffff7b67);
const kThirdColor = Color(0xfffcd76b);
const kBackgroundColor = Color(0xfffff9f4);

NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

class PrecoMedioCard extends StatefulWidget {
  final PrecoMedio precoMedio;

  PrecoMedioCard({required this.precoMedio});

  @override
  State<PrecoMedioCard> createState() => _PrecoMedioCardState();
}

class _PrecoMedioCardState extends State<PrecoMedioCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          height: 60,
          width: 60,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (widget.precoMedio.preco_medio == 0.0)
                ? Colors.red
                : Colors.green,
          ),
          child: Center(
            child: Text(
              widget.precoMedio.cidade.substring(0, 2),
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: Text(widget.precoMedio.cidade),
        subtitle:
            Text(widget.precoMedio.quant_anuncio.toString() + " anúncios"),
        trailing: (widget.precoMedio.preco_medio == 0.0)
            ? Text("Sem anúncios")
            : Text(
                formatter.format(widget.precoMedio.preco_medio),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
      ),
    );
  }
}

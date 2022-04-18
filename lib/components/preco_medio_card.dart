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
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 60,
                width: 60,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.purple,
                ),
                child: Center(
                    child: Text(
                  widget.precoMedio.cidade.substring(0,2),
                  style: TextStyle(fontSize: 30, color: Colors.white),
                )),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.precoMedio.cidade,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ApptextStyle.LISTTILE_TITLE,
                  ),
                  Text(
                    "${widget.precoMedio.quant_anuncio} anúncios",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ApptextStyle.LISTTILE_SUB_TITLE,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (widget.precoMedio.preco_medio == 0.0)?Text(
                    "Sem anúncios",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ApptextStyle.LISTTILE_TITLE,
                  ):Text(
                    formatter.format(widget.precoMedio.preco_medio),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ApptextStyle.LISTTILE_TITLE,
                  ),
                  // Row(
                  //   children: [
                  //     transaction.changePercentageIndicator == "up"
                  //         ? Icon(
                  //       FontAwesomeIcons.levelUpAlt,
                  //       size: 10,
                  //       color: Colors.green,
                  //     )
                  //         : Icon(
                  //       FontAwesomeIcons.levelDownAlt,
                  //       size: 10,
                  //       color: Colors.red,
                  //     ),
                  //     SizedBox(
                  //       width: 5,
                  //     ),
                  //     Text(
                  //       transaction.changePercentage,
                  //       style: ApptextStyle.LISTTILE_SUB_TITLE,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ApptextStyle {
  static const TextStyle MY_CARD_TITLE =
      TextStyle(color: kThirdColor, fontWeight: FontWeight.w700, fontSize: 16);

  static const TextStyle MY_CARD_SUBTITLE =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18);

  static const TextStyle LISTTILE_TITLE = TextStyle(
    color: kPrimaryColor,
    fontSize: 20,
  );

  static const TextStyle LISTTILE_SUB_TITLE = TextStyle(
    color: Colors.grey,
    fontSize: 15,
  );
}

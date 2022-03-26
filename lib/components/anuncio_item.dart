import 'package:flutter/material.dart';

class AnuncioItem extends StatelessWidget {
  final void Function()? onLongTap;
  final Widget? botoes;

  const AnuncioItem({Key? key, this.onLongTap, this.botoes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(
        Radius.circular(20.0),
      ),
      color: Colors.purple[800],
      child: InkResponse(
        containedInkWell: true,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
        onTap: () {},
        onLongPress: onLongTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(
                "assets/images/teste.jpg",
                fit: BoxFit.fitHeight,
                width: 100,
                height: 100,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    bottom: 13.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Morena Açaí',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        'Produção própria',
                        style: TextStyle(
                          color: Colors.black38,
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 5.0,
                            ),
                            child: Icon(
                              Icons.airport_shuttle_outlined,
                              color: Colors.black38,
                            ),
                          ),
                          Text(
                            'Não entrega',
                            style: TextStyle(
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'R\$ 110,00',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'RobotoSlab',
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              botoes!,
            ],
          ),
        ),
      ),
    );
  }
}

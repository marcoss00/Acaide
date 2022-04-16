import 'package:acaide/models/anuncio.dart';
import 'package:acaide/screens/anuncio_detalhes_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

class AnuncioItem extends StatefulWidget {
  final void Function()? onLongTap;
  final Widget? botoes;
  final Anuncio anuncio;

  AnuncioItem({Key? key, this.onLongTap, this.botoes, required this.anuncio})
      : super(key: key);

  @override
  State<AnuncioItem> createState() => _AnuncioItemState();
}

class _AnuncioItemState extends State<AnuncioItem> {
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
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  AnuncioDetalhesScreen(anuncio: widget.anuncio),
            ),
          );
        },
        onLongPress: widget.onLongTap,
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
              Hero(
                tag: widget.anuncio.imagem,
                child: Image.network(
                  widget.anuncio.imagem,
                  fit: BoxFit.fill,
                  width: 100,
                  height: 100,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Row(
                      children: [
                        Icon(Icons.error),
                        Text("Erro!\nRecarregue\na pagina"),
                      ],
                    );
                  },
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.purple[800],
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
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
                        widget.anuncio.titulo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black54,
                        ),
                      ),
                      (widget.anuncio.tipo_anunciante == true)
                          ? Text(
                              'Produção própria',
                              style: TextStyle(
                                color: Colors.black38,
                              ),
                            )
                          : Text(
                              'Revendedor',
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
                          (widget.anuncio.entrega == false)
                              ? Text(
                                  'Não entrega',
                                  style: TextStyle(
                                    color: Colors.black38,
                                  ),
                                )
                              : Text(
                                  'Entrega',
                                  style: TextStyle(
                                    color: Colors.black38,
                                  ),
                                ),
                        ],
                      ),
                      Text(
                        formatter.format(widget.anuncio.preco),
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
              widget.botoes!,
            ],
          ),
        ),
      ),
    );
  }
}

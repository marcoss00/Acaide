import 'dart:async';
import 'package:flutter/material.dart';
import '../models/anuncio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

class AnuncioDetalhesScreen extends StatefulWidget {
  final Anuncio anuncio;

  AnuncioDetalhesScreen(this.anuncio);

  @override
  State<AnuncioDetalhesScreen> createState() => _AnuncioDetalhesScreenState();
}

class _AnuncioDetalhesScreenState extends State<AnuncioDetalhesScreen> {
  static const maxSegundos = 60;
  static const maxMinutos = 60;
  static const maxHoras = 24;
  int segundos = 0;
  int minutos = 0;
  int horas = maxHoras;
  Timer? timer;

  void tempoRestante() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (segundos <= 0) {
        segundos = maxSegundos;
        if (minutos <= 0) {
          minutos = maxMinutos;
          setState(() => horas--);
        }
        setState(() => minutos--);
      }
      setState(() => segundos--);
    });
  }

  @override
  void initState() {
    super.initState();
    final DateTime horarioAtual = DateTime.now();
    if (horarioAtual.second < widget.anuncio.dataCriacao.second) {
      segundos = widget.anuncio.dataCriacao.second - horarioAtual.second;
    } else if (horarioAtual.second == widget.anuncio.dataCriacao.second &&
        horarioAtual.day != widget.anuncio.dataCriacao.day) {
      segundos = 0;
    } else if (horarioAtual.second == widget.anuncio.dataCriacao.second &&
        horarioAtual.day == widget.anuncio.dataCriacao.day) {
      segundos = 59 - (horarioAtual.second - widget.anuncio.dataCriacao.second);
    } else {
      segundos = maxSegundos -
          (horarioAtual.second - widget.anuncio.dataCriacao.second);
    }
    if (horarioAtual.minute < widget.anuncio.dataCriacao.minute) {
      minutos = widget.anuncio.dataCriacao.minute - horarioAtual.minute;
    } else if (horarioAtual.minute == widget.anuncio.dataCriacao.minute &&
        horarioAtual.day != widget.anuncio.dataCriacao.day) {
      minutos = 0;
    } else if (horarioAtual.minute == widget.anuncio.dataCriacao.minute &&
        horarioAtual.day == widget.anuncio.dataCriacao.day) {
      minutos = 59 - (horarioAtual.minute - widget.anuncio.dataCriacao.minute);
    } else {
      minutos = maxMinutos -
          (horarioAtual.minute - widget.anuncio.dataCriacao.minute);
    }
    if (horarioAtual.hour < widget.anuncio.dataCriacao.hour) {
      horas = widget.anuncio.dataCriacao.hour - horarioAtual.hour;
    } else if (horarioAtual.hour == widget.anuncio.dataCriacao.hour &&
        horarioAtual.day != widget.anuncio.dataCriacao.day) {
      horas = 0;
    } else if (horarioAtual.hour == widget.anuncio.dataCriacao.hour &&
        horarioAtual.day == widget.anuncio.dataCriacao.day) {
      horas = 23 - (horarioAtual.hour - widget.anuncio.dataCriacao.hour);
    } else {
      horas = maxHoras - (horarioAtual.hour - widget.anuncio.dataCriacao.hour);
    }
    tempoRestante();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Detalhes Anúncio",
          style: TextStyle(
            fontFamily: "Cookie",
            fontSize: 28.0,
          ),
        ),
        backgroundColor: Colors.purple[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32.h),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black26),
                ),
                child: Hero(
                  tag: widget.anuncio.imagem,
                  child: Image.network(
                    widget.anuncio.imagem,
                    height: 260.h,
                    fit: BoxFit.cover,
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
              ),
              SizedBox(height: 24.h),
              SlideAnimation(
                intervalStart: 0.4,
                begin: const Offset(0, 30),
                child: FadeAnimation(
                  intervalStart: 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.anuncio.titulo,
                        style: TextStyle(
                          fontSize: 24.r,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(100),
                          //   child: Image.asset(
                          //     'assets/images/perfil.png',
                          //     width: 20.r,
                          //   ),
                          // ),
                          // SizedBox(width: 8.h),
                          (widget.anuncio.tipo_anunciante)
                              ? Text(
                                  'Produção própria',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                )
                              : Text(
                                  'Revendedor',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        widget.anuncio.descricao,
                        style: TextStyle(
                          fontSize: 14.r,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      const Divider(),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 90.0),
                            child: _InfoTile(
                                title: '${widget.anuncio.quant_rasas}',
                                subtitle: 'Quantidade de rasas'),
                          ),
                          Expanded(
                            child: _InfoTile(
                                title: formatter.format(widget.anuncio.preco),
                                subtitle: 'Preço unitário'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 120.0),
                            child: _InfoTile(
                                title: (horas < 0)
                                    ? 'Anúncio finalizado'
                                    : '${horas}h ${minutos}min ${segundos}s',
                                subtitle: 'Tempo restante'),
                          ),
                          _InfoTile(
                              title: (widget.anuncio.entrega) ? "Sim" : "Não",
                              subtitle: 'Entrega'),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            widget.anuncio.fotoPerfilUsuario,
                            width: 40.r,
                            height: 40.r,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(widget.anuncio.nomeUsuario),
                        subtitle: Text(
                          'Anunciante',
                          style: TextStyle(
                            fontSize: 16.r,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () => _showCidades(context),
                          icon: Icon(Icons.location_city),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Button(widget.anuncio),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCidades(BuildContext context) async {
    List<String> cidadesAnuncio = [];
    widget.anuncio.cidades.forEach((key, value) {
      cidadesAnuncio.add(key);
    });
    final double tamanho = 40.0 * cidadesAnuncio.length;
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Text(
              "Disponível para: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Container(
              width: tamanho,
              height: tamanho,
              child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: cidadesAnuncio.length,
                  separatorBuilder: (context, indice) => Divider(),
                  itemBuilder: (context, indice) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6, left: 5),
                      child: Text("${cidadesAnuncio[indice]}"),
                    );
                  }),
            ),
          ],
        );
      },
    );
  }
}

class Button extends StatelessWidget {
  final Anuncio anuncio;

  Button(this.anuncio);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDialog(context, anuncio),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 16.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.purple[900],
        ),
        child: Center(
          child: Text(
            'Contatos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.r,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context, Anuncio anuncio) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            TextButton.icon(
              icon: FaIcon(Icons.whatsapp, color: Colors.green),
              label: Text(
                'WhatsApp',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () => abrirWhatsApp("+55${anuncio.telefoneUsuario}",
                  "Olá, tudo bem ? Vi seu anúncio no app Açaíde..."),
            ),
            TextButton.icon(
              icon: FaIcon(Icons.phone, color: Colors.grey),
              label: Text(
                'Ligar',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () => fazerLigacao(anuncio.telefoneUsuario),
            ),
          ],
        );
      },
    );
  }

  fazerLigacao(String numero) async {
    var url = 'tel:$numero';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  abrirWhatsApp(String numero, String mensagem) async {
    var whatsappUrl = "https://wa.me/$numero?text=$mensagem";
    await launch(whatsappUrl);
  }
}

class FadeAnimation extends StatelessWidget {
  const FadeAnimation({
    Key? key,
    required this.child,
    this.begin = 0,
    this.end = 1,
    this.intervalStart = 0,
    this.intervalEnd = 1,
    this.duration = const Duration(milliseconds: 650),
    this.curve = Curves.fastOutSlowIn,
  }) : super(key: key);

  ///Animate from value
  ///
  ///[default value 0]
  final double begin;

  ///Animate to value
  ///
  ///[default value 1]
  final double end;

  ///Animation Duration
  ///
  ///[default is 750ms]
  final Duration duration;

  ///Animation delay
  ///
  ///[default is 0]
  final double intervalStart;

  ///Animation delay
  ///
  ///[default is 1]
  final double intervalEnd;

  ///Animation Curve
  ///
  ///[default is Curves.fastOutSlowIn]
  final Curve curve;

  ///This widget will be animated
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: begin, end: end),
      duration: duration,
      curve: Interval(intervalStart, intervalEnd, curve: curve),
      child: child,
      builder: (BuildContext context, double? value, Widget? child) {
        return Opacity(
          opacity: value!,
          child: child,
        );
      },
    );
  }
}

class SlideAnimation extends StatelessWidget {
  const SlideAnimation({
    Key? key,
    required this.child,
    this.begin = const Offset(250, 0),
    this.end = const Offset(0, 0),
    this.intervalStart = 0,
    this.intervalEnd = 1,
    this.duration = const Duration(milliseconds: 650),
    this.curve = Curves.fastOutSlowIn,
  }) : super(key: key);

  ///Animate from value
  ///
  ///[default value Offset(250,0)j
  final Offset begin;

  ///Animate to value
  ///
  ///[default value Offset(0,0)]
  final Offset end;

  ///Animation delay
  ///
  ///[default is 0]
  final double intervalStart;

  ///Animation delay
  ///
  ///[default is 1]
  final double intervalEnd;

  ///Animation Duration
  ///
  ///[default is 750ms]
  final Duration duration;

  ///Animation Curve
  ///
  ///[default is Curves.fastOutSlowIn]
  final Curve curve;

  ///This widget will be animated
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: begin, end: end),
      duration: duration,
      curve: Interval(intervalStart, intervalEnd, curve: curve),
      child: child,
      builder: (BuildContext context, Offset? value, Widget? child) {
        return Transform.translate(
          offset: value!,
          child: child,
        );
      },
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({Key? key, required this.title, required this.subtitle})
      : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

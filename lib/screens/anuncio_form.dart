import 'package:acaide/components/editor_campo_texto.dart';
import 'package:acaide/models/anuncio.dart';
import 'package:acaide/models/cidade.dart';
import 'package:acaide/models/usuario.dart';
import 'package:acaide/screens/meus_anuncios_list.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../database/anuncio_database.dart';

File? _fotoAnuncio;
XFile? pathFotoAnuncio;
final AnuncioDatabase _dao = AnuncioDatabase();
List<Object?> _cidadesSelecionadas = [];
FazEntrega fazEntrega = FazEntrega.naoEntrega;
TipoAnunciante tipoAnunciante = TipoAnunciante.producaoPropria;
String id = Uuid().v1();
double total = 0;
final loading = ValueNotifier<bool>(false);
bool temImagem = true;

class AnuncioForm extends StatefulWidget {
  final Usuario usuario;
  final List<Cidade> cidades;

  AnuncioForm(this.usuario, this.cidades);

  @override
  State<AnuncioForm> createState() => _AnuncioFormState();
}

class _AnuncioFormState extends State<AnuncioForm> {
  Color top_color = Colors.purple[800]!;

  final TextEditingController controladorCampoTitulo = TextEditingController();
  final TextEditingController controladorCampoDescricao =
      TextEditingController();
  final TextEditingController controladorCampoQuantidadeRasas =
      TextEditingController();
  final TextEditingController controladorCampoPrecoRasa =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final InterstitialAd myInterstitial;
  bool adTelaCheiaCarregado = false;

  void carregarAdTelaCheia(){
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/8691691433',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            adTelaCheiaCarregado = true;
            myInterstitial = ad;
            myInterstitial.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                myInterstitial.dispose();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                myInterstitial.dispose();
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  void atualizaCounterTextTitulo() {
    setState(() {
      controladorCampoTitulo.text;
    });
  }

  void atualizaCounterTextDescricao() {
    setState(() {
      controladorCampoDescricao.text;
    });
  }

  @override
  void initState() {
    super.initState();
    controladorCampoDescricao.addListener(atualizaCounterTextDescricao);
    controladorCampoTitulo.addListener(atualizaCounterTextTitulo);
    _fotoAnuncio = null;
    id = Uuid().v1();
    _cidadesSelecionadas = [];
    fazEntrega = FazEntrega.naoEntrega;
    tipoAnunciante = TipoAnunciante.producaoPropria;
    setState(() => loading.value = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        title: Text(
          "Inserir anúncio",
          style: TextStyle(
            fontFamily: "Cookie",
            fontSize: 28.0,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 30,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              //Color.fromARGB(255, 255, 110, 255),
              Colors.purple[800]!,
              top_color,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    FotoAnuncio(),
                    (temImagem)
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "Insira uma imagem para o anúncio",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: EditorCampoTexto(
                        rotulo: "Título do anúncio*",
                        dica: "Ex: Açaí do Branco",
                        controlador: controladorCampoTitulo,
                        counterText: "${controladorCampoTitulo.text.length}/20",
                        teclado: TextInputType.text,
                        icone: Icons.title,
                        validador: (value) {
                          if (value == null || value.isEmpty) {
                            return "É obrigatório um título para o anúncio";
                          } else if (value.length > 20) {
                            return "Numéro máximo de caracteres\nexcedido";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextFormField(
                        maxLines: null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "É obrigatório uma descrição para o\nanúncio";
                          } else if (value.length > 300) {
                            return "Numéro máximo de caracteres\nexcedido";
                          }
                          return null;
                        },
                        controller: controladorCampoDescricao,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintMaxLines: 4,
                          counterText:
                              "${controladorCampoDescricao.text.length}/300",
                          counterStyle: TextStyle(color: Colors.white),
                          hintText:
                              "Ex: Açaí de excelente qualidade, produzido na região... Entre em contato para mais informações",
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Descrição*",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          prefixIcon: Icon(
                            Icons.description,
                            color: Colors.white,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: EntregaRadio(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TipoAnuncianteRadio(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "É obrigatório informar a quantidade de rasas\n no anúncio";
                          }
                          final int? quantTelas = int.tryParse(value);
                          if (quantTelas! < 1) {
                            return "Quantidade inválida";
                          }
                          return null;
                        },
                        controller: controladorCampoQuantidadeRasas,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: "Ex: 13",
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Quantidade de Rasas*",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          prefixIcon: Icon(
                            Icons.production_quantity_limits_outlined,
                            color: Colors.white,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        inputFormatters: [
                          CurrencyTextInputFormatter(
                            locale: 'br',
                            symbol: 'R\$',
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "É obrigatório informar o preço das rasas\n no anúncio";
                          } else if (value.length > 9) {
                            return "Preço muito elevado";
                          }
                          return null;
                        },
                        controller: controladorCampoPrecoRasa,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: "Ex: 90,00 R\$",
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Preço de cada Rasa*",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          prefixIcon: Icon(
                            Icons.price_change,
                            color: Colors.white,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 20, top: 30, left: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: CidadeDropdown(widget.cidades),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 500,
                child: ElevatedButton(
                  onPressed: (loading.value)
                      ? () => null
                      : () {
                          if (_fotoAnuncio == null) {
                            setState(() {
                              temImagem = false;
                            });
                          } else {
                            setState(() => temImagem = true);
                          }
                          if (_formKey.currentState!.validate() &&
                              _fotoAnuncio != null &&
                              _cidadesSelecionadas != []) {
                            loading.value = !loading.value;
                            carregarAdTelaCheia();
                            return uploadFotoAnuncio(context);
                          }
                        },
                  child: AnimatedBuilder(
                    animation: loading,
                    builder: (context, _) {
                      return (loading.value)
                          ? Text(
                              "${total.round()}%",
                              style: TextStyle(color: Colors.black),
                            )
                          : Text(
                              "Enviar Anúncio",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            );
                    },
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 240, 255)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  uploadFotoAnuncio(BuildContext context) async {
    XFile? file = await pathFotoAnuncio;
    final int? quantSaca = int.tryParse(controladorCampoQuantidadeRasas.text);
    final String precoRasa = controladorCampoPrecoRasa.text.replaceAll(" ", "");
    final String precoRasa2 = precoRasa.replaceAll(',', '.');
    final String precoRasa3 = precoRasa2.replaceAll('R\$', '');
    final double? preco = double.tryParse(precoRasa3);
    final String refImagem =
        "imagensAnuncio/img-${DateTime.now().toString()}.jpg";
    final Map<String, int> cidadesMap = Map.fromIterable(_cidadesSelecionadas,
        key: (cidade) => cidade.nome, value: (cidade) => cidade.id);
    final DateTime dataCriacao = DateTime.now();
    final String refFotoPerfilUsuario =
        await _dao.getRef(widget.usuario.foto_perfil);

    final Anuncio anuncioCriado = Anuncio(
      id: id,
      idUsuario: widget.usuario.id,
      titulo: controladorCampoTitulo.text,
      tipo_anunciante: tipoAnunciante == TipoAnunciante.producaoPropria,
      entrega: fazEntrega == FazEntrega.entrega,
      preco: preco!,
      cidades: cidadesMap,
      imagem: refImagem,
      quant_rasas: quantSaca!,
      descricao: controladorCampoDescricao.text,
      dataCriacao: dataCriacao,
      fotoPerfilUsuario: refFotoPerfilUsuario,
      nomeUsuario: widget.usuario.nome,
      telefoneUsuario: widget.usuario.telefone,
    );
    if (file != null) {
      UploadTask task = await _dao.uploadImagemAnuncio(file.path, refImagem);
      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        switch (snapshot.state) {
          case TaskState.paused:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    MeusAnunciosList(widget.usuario, widget.cidades),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Envio pausado"),
              ),
            );
            break;
          case TaskState.running:
            setState(() {
              total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
            });
            break;
          case TaskState.success:
            if(adTelaCheiaCarregado){
              myInterstitial.show();
            }
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    MeusAnunciosList(widget.usuario, widget.cidades),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Anúncio enviado"),
              ),
            );
            return _dao.saveAnuncio(anuncioCriado);
          case TaskState.canceled:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    MeusAnunciosList(widget.usuario, widget.cidades),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Envio cancelado"),
              ),
            );
            break;
          case TaskState.error:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    MeusAnunciosList(widget.usuario, widget.cidades),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Erro ao enviar o anúncio"),
              ),
            );
            break;
        }
      });
    }
  }
}

class FotoAnuncio extends StatefulWidget {
  const FotoAnuncio({Key? key}) : super(key: key);

  @override
  State<FotoAnuncio> createState() => _FotoAnuncioState();
}

class _FotoAnuncioState extends State<FotoAnuncio> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _modalBottomSheet(context),
      child: Center(
        child: (_fotoAnuncio == null)
            ? Container(
                color: Colors.white,
                width: 250,
                height: 250,
                child: Icon(
                  Icons.camera_alt,
                  size: 200,
                  color: Colors.grey,
                ),
              )
            : Image.file(_fotoAnuncio!),
      ),
    );
  }

  _modalBottomSheet(context) {
    showModalBottomSheet(
      isDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            children: [
              Text(
                "Escolha uma foto para o anúncio",
                style: TextStyle(fontSize: 20.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: TextButton.icon(
                        onPressed: () => _checkPermissionCamera(),
                        icon: Icon(
                          Icons.camera,
                          color: Colors.black,
                        ),
                        label: Text(
                          "Câmera",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _checkPermissionGallery(),
                      icon: Icon(
                        Icons.image,
                        color: Colors.black,
                      ),
                      label: Text(
                        "Galeria",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _fotoAnuncio = File(pickedFile.path);
        pathFotoAnuncio = pickedFile;
      });
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        _fotoAnuncio = File(pickedFile.path);
        pathFotoAnuncio = pickedFile;
      });
    }
  }

  _checkPermissionCamera() async {
    var statusPermissionCamera = await Permission.camera.status;
    var statusPermissionMicrophone = await Permission.microphone.status;
    if (!statusPermissionCamera.isGranted) {
      await Permission.camera.request();
    }
    if (!statusPermissionMicrophone.isGranted) {
      await Permission.microphone.request();
    }
    if (await Permission.camera.isGranted &&
        await Permission.microphone.isGranted) {
      _getFromCamera();
    }
  }

  _checkPermissionGallery() async {
    var statusPermissionStorage = await Permission.storage.status;
    if (!statusPermissionStorage.isGranted) {
      await Permission.storage.request();
    }
    if (await Permission.storage.isGranted) {
      _getFromGallery();
    }
  }
}

class CidadeDropdown extends StatefulWidget {
  final List<Cidade> cidades;

  CidadeDropdown(this.cidades);

  @override
  State<CidadeDropdown> createState() => _CidadeDropdownState();
}

class _CidadeDropdownState extends State<CidadeDropdown> {
  @override
  Widget build(BuildContext context) {
    final _itens = widget.cidades
        .map((cidade) => MultiSelectItem<Cidade>(cidade, cidade.nome!))
        .toList();
    return MultiSelectBottomSheetField(
      initialValue: [],
      validator: (value) {
        if (value == null ||
            value == [] ||
            value.toString() == "" ||
            value.isEmpty) {
          return "Escolha pelo menos um município\npara anunciar";
        }
        return null;
      },
      decoration: BoxDecoration(
        color: Colors.purple[800],
        borderRadius: BorderRadius.all(Radius.circular(40)),
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
      ),
      buttonIcon: Icon(
        null,
        color: Colors.white,
      ),
      buttonText: Text(
        "Municípios*",
        style: TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
      ),
      searchable: true,
      searchHint: 'Buscar Município',
      items: _itens,
      separateSelectedItems: true,
      title: Text("Municípios:"),
      selectedColor: Colors.purple,
      onConfirm: (resultado) {
        _cidadesSelecionadas = resultado;
      },
      searchIcon: Icon(Icons.search),
      selectedItemsTextStyle: TextStyle(color: Colors.green),
      chipDisplay: MultiSelectChipDisplay(
        scroll: true,
        chipColor: Colors.green,
        textStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}

class EntregaRadio extends StatefulWidget {
  const EntregaRadio({Key? key}) : super(key: key);

  @override
  State<EntregaRadio> createState() => _EntregaRadioState();
}

enum FazEntrega { entrega, naoEntrega }

class _EntregaRadioState extends State<EntregaRadio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "Entrega:",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          RadioListTile<FazEntrega>(
            activeColor: Colors.green,
            title: Text(
              "Realiza a Entrega",
              style: TextStyle(color: Colors.white),
            ),
            value: FazEntrega.entrega,
            groupValue: fazEntrega,
            onChanged: (FazEntrega? valor) {
              setState(() {
                fazEntrega = valor!;
              });
            },
          ),
          RadioListTile<FazEntrega>(
            activeColor: Colors.green,
            title: Text(
              "Não Entrega",
              style: TextStyle(color: Colors.white),
            ),
            value: FazEntrega.naoEntrega,
            groupValue: fazEntrega,
            onChanged: (FazEntrega? valor) {
              setState(() {
                fazEntrega = valor!;
              });
            },
          ),
        ],
      ),
    );
  }
}

class TipoAnuncianteRadio extends StatefulWidget {
  const TipoAnuncianteRadio({Key? key}) : super(key: key);

  @override
  State<TipoAnuncianteRadio> createState() => _TipoAnuncianteRadioState();
}

enum TipoAnunciante { producaoPropria, revendedor }

class _TipoAnuncianteRadioState extends State<TipoAnuncianteRadio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Text(
              "Proveniência:",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          RadioListTile<TipoAnunciante>(
            activeColor: Colors.green,
            title: Text(
              "Produção Própria",
              style: TextStyle(color: Colors.white),
            ),
            value: TipoAnunciante.producaoPropria,
            groupValue: tipoAnunciante,
            onChanged: (TipoAnunciante? valor) {
              setState(() {
                tipoAnunciante = valor!;
              });
            },
          ),
          RadioListTile<TipoAnunciante>(
            activeColor: Colors.green,
            title: Text(
              "Revendedor",
              style: TextStyle(color: Colors.white),
            ),
            value: TipoAnunciante.revendedor,
            groupValue: tipoAnunciante,
            onChanged: (TipoAnunciante? valor) {
              setState(() {
                tipoAnunciante = valor!;
              });
            },
          ),
        ],
      ),
    );
  }
}

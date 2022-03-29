import 'package:acaide/models/anuncio.dart';
import 'package:acaide/models/cidade.dart';
import 'package:acaide/models/cidades.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

File? _fotoAnuncio = null;
final Cidades _cidades = Cidades();

class AnuncioForm extends StatefulWidget {
  const AnuncioForm({Key? key}) : super(key: key);

  @override
  State<AnuncioForm> createState() => _AnuncioFormState();
}

class _AnuncioFormState extends State<AnuncioForm> {
  Color top_color = Colors.purple[800]!;

  final TextEditingController controladorCampoTitulo = TextEditingController();
  final TextEditingController controladorCampoDescricao =
      TextEditingController();
  final TextEditingController controladorCampoQuantidadeSaca =
      TextEditingController();
  final TextEditingController controladorCampoPrecoSaca =
      TextEditingController();

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
                child: Column(
                  children: [
                    FotoAnuncio(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        controller: controladorCampoTitulo,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        autofocus: true,
                        decoration: InputDecoration(
                          counterText: "0/20",
                          counterStyle: TextStyle(color: Colors.white),
                          hintText: "Ex: Açaí do Branco",
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Título do anúncio*",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          prefixIcon: Icon(
                            Icons.title,
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
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextFormField(
                        controller: controladorCampoDescricao,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        autofocus: true,
                        decoration: InputDecoration(
                          counterText: "0/100",
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
                        controller: controladorCampoQuantidadeSaca,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Ex: 13",
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Quantidade de Telas*",
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
                        controller: controladorCampoPrecoSaca,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Ex: R\$ 90,00",
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Preço da Tela*",
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
                            child: CidadeDropdown(),
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
                  onPressed: () => _criaAnuncio(context),
                  child: Text(
                    "Enviar Anúncio",
                    style: TextStyle(
                      color: Colors.black,
                    ),
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

  void _criaAnuncio(BuildContext context) {
    final int? quantSaca = int.tryParse(controladorCampoQuantidadeSaca.text);
    final double? preco = double.tryParse(controladorCampoPrecoSaca.text);

    final Anuncio anuncioCriado = Anuncio(
      controladorCampoTitulo.text,
      tipoAnunciante == TipoAnunciante.producaoPropria,
      fazEntrega == FazEntrega.entrega,
      preco!,
      _cidadesSelecionadas,
      _fotoAnuncio!,
      quantSaca!,
      controladorCampoDescricao.text,
    );

    Navigator.pop(context, anuncioCriado);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Anúncio Criado"),
      ),
    );
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
  const CidadeDropdown({Key? key}) : super(key: key);

  @override
  State<CidadeDropdown> createState() => _CidadeDropdownState();
}

List<Object?> _cidadesSelecionadas = [];

class _CidadeDropdownState extends State<CidadeDropdown> {
  final _itens = _cidades.cidadesList
      .map((cidade) => MultiSelectItem<Cidade>(cidade, cidade.name!))
      .toList();

  @override
  Widget build(BuildContext context) {
    return MultiSelectBottomSheetField(
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

FazEntrega fazEntrega = FazEntrega.naoEntrega;

class _EntregaRadioState extends State<EntregaRadio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
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

TipoAnunciante tipoAnunciante = TipoAnunciante.producaoPropria;

class _TipoAnuncianteRadioState extends State<TipoAnuncianteRadio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
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

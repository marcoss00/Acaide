import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

enum TipoAnunciante { produtor, revendedor }

File? foto_anuncio;

class AnuncioForm extends StatefulWidget {
  const AnuncioForm({Key? key}) : super(key: key);

  @override
  _AnuncioFormState createState() => _AnuncioFormState();
}

class _AnuncioFormState extends State<AnuncioForm> {
  TipoAnunciante? _padrao_anunciante = TipoAnunciante.produtor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[800],
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        title: Text(
          "Inserir anúncio",
          style: TextStyle(
            fontFamily: "PTSans",
            fontSize: 23.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ImagemAnuncio(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(32.0),
                    child: TextFormField(
                      controller: TextEditingController(),
                      style: TextStyle(),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText: 'Título do anúncio*',
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey,
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
                    child: TextFormField(
                      controller: TextEditingController(),
                      style: TextStyle(),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText: 'Descrição*',
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey,
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      RadioListTile<TipoAnunciante>(
                        activeColor: Colors.green,
                        tileColor: Colors.white,
                        title: Text('Região A'),
                        value: TipoAnunciante.produtor,
                        groupValue: _padrao_anunciante,
                        onChanged: (TipoAnunciante? value) {
                          setState(() {
                            _padrao_anunciante = value;
                          });
                        },
                      ),
                      RadioListTile<TipoAnunciante>(
                        activeColor: Colors.green,
                        tileColor: Colors.white,
                        title: Text('Região B'),
                        value: TipoAnunciante.revendedor,
                        groupValue: _padrao_anunciante,
                        onChanged: (TipoAnunciante? value) {
                          setState(() {
                            _padrao_anunciante = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      RadioListTile<TipoAnunciante>(
                        activeColor: Colors.green,
                        tileColor: Colors.white,
                        title: Text('Produtor'),
                        value: TipoAnunciante.produtor,
                        groupValue: _padrao_anunciante,
                        onChanged: (TipoAnunciante? value) {
                          setState(() {
                            _padrao_anunciante = value;
                          });
                        },
                      ),
                      RadioListTile<TipoAnunciante>(
                        activeColor: Colors.green,
                        tileColor: Colors.white,
                        title: Text('Revendedor'),
                        value: TipoAnunciante.revendedor,
                        groupValue: _padrao_anunciante,
                        onChanged: (TipoAnunciante? value) {
                          setState(() {
                            _padrao_anunciante = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      RadioListTile<TipoAnunciante>(
                        activeColor: Colors.green,
                        tileColor: Colors.white,
                        title: Text('Entrega'),
                        value: TipoAnunciante.produtor,
                        groupValue: _padrao_anunciante,
                        onChanged: (TipoAnunciante? value) {
                          setState(() {
                            _padrao_anunciante = value;
                          });
                        },
                      ),
                      RadioListTile<TipoAnunciante>(
                        activeColor: Colors.green,
                        tileColor: Colors.white,
                        title: Text('Não Entrega'),
                        value: TipoAnunciante.revendedor,
                        groupValue: _padrao_anunciante,
                        onChanged: (TipoAnunciante? value) {
                          setState(() {
                            _padrao_anunciante = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
                    child: TextFormField(
                      controller: TextEditingController(),
                      style: TextStyle(),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText: 'Quantidade de Telas de Açaí',
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey,
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
                    child: TextFormField(
                      controller: TextEditingController(),
                      style: TextStyle(),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText: 'Preço da Tela de Açaí',
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey,
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                width: 500,
                child: ElevatedButton(
                  onPressed: () {},
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
            ),
          ],
        ),
      ),
    );
  }
}

class ImagemAnuncio extends StatefulWidget {
  const ImagemAnuncio({Key? key}) : super(key: key);

  @override
  State<ImagemAnuncio> createState() => _ImagemAnuncioState();
}

class _ImagemAnuncioState extends State<ImagemAnuncio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: foto_anuncio == null
          ? Material(
              child: InkWell(
                onTap: () {
                  _modalBottomSheet(context);
                },
                child: Container(
                  color: Colors.white,
                  width: 250,
                  height: 250,
                  child: Icon(
                    Icons.camera_alt,
                    size: 200,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          : Material(
              child: InkWell(
                onTap: () {
                  _modalBottomSheet(context);
                },
                child: Image.file(foto_anuncio!),
              ),
            ),
    );
  }

  _modalBottomSheet(context) {
    showModalBottomSheet(
      isDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Tirar foto'),
                onTap: () => _checkPermissionCamera(),
              ),
              ListTile(
                leading: Icon(Icons.wallpaper_outlined),
                title: Text('Escolher existente...'),
                onTap: () => _checkPermissionGallery(),
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
        foto_anuncio = File(pickedFile.path);
      });
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        foto_anuncio = File(pickedFile.path);
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

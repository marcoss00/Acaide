import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/cidades.dart';

File? _fotoPerfil;
File? _fotoPerfilCortada;
final Cidades _cidades = Cidades();

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool show_password = false;
  Color top_color = Colors.purple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Color.fromARGB(255, 255, 110, 255),
              top_color,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 22,
                  bottom: 12,
                ),
                child: Text(
                  "Cadastro",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Form(
                child: Column(
                  children: [
                    FotoPerfil(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: "Nome Completo",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          prefixIcon: Icon(
                            Icons.person,
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
                      padding: const EdgeInsets.only(top: 8),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: "E-mail",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
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
                      padding: const EdgeInsets.only(top: 8),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: "CPF",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          prefixIcon: Icon(
                            Icons.description_outlined,
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
                    CidadeDropdown(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: "Número de Telefone",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          prefixIcon: Icon(
                            Icons.phone,
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
                      padding: const EdgeInsets.only(top: 8),
                      child: TextFormField(
                        obscureText:
                            (this.show_password == true) ? false : true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Senha",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          prefixIcon: Icon(
                            Icons.vpn_key_sharp,
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
                    (this.show_password == false)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextFormField(
                              obscureText: true,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Confirme a Senha",
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                prefixIcon: Icon(
                                  Icons.vpn_key_sharp,
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
                          )
                        : Container(),
                    Row(
                      children: [
                        Checkbox(
                          value: this.show_password,
                          activeColor: Colors.green,
                          onChanged: (bool? newValue) {
                            setState(() {
                              this.show_password = newValue!;
                            });
                          },
                        ),
                        Text(
                          "Mostrar senha",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 500,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Cadastrar-se",
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
}

class FotoPerfil extends StatefulWidget {
  const FotoPerfil({Key? key}) : super(key: key);

  @override
  State<FotoPerfil> createState() => _FotoPerfilState();
}

class _FotoPerfilState extends State<FotoPerfil> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _modalBottomSheet(context),
      child: Center(
        child: (_fotoPerfilCortada == null)
            ? CircleAvatar(
                backgroundColor: Colors.white,
                radius: 80.0,
                child: Icon(
                  Icons.add_a_photo_rounded,
                  color: Colors.purple[800],
                  size: 35,
                ),
              )
            : Stack(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: FileImage(_fotoPerfilCortada!),
                  ),
                  Positioned(
                    bottom: 22.0,
                    right: 22.0,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.purple[800],
                      size: 28.0,
                    ),
                  ),
                ],
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
          height: 100,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            children: [
              Text(
                "Escolha a sua foto de perfil",
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
        _fotoPerfil = File(pickedFile.path);
        _imageCropper();
      });
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        _fotoPerfil = File(pickedFile.path);
        _imageCropper();
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

  _imageCropper() async {
    _fotoPerfilCortada = await ImageCropper().cropImage(
      sourcePath: _fotoPerfil!.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.circle,
    );
    setState(() {});
  }
}

class CidadeDropdown extends StatefulWidget {
  const CidadeDropdown({Key? key}) : super(key: key);

  @override
  State<CidadeDropdown> createState() => _CidadeDropdownState();
}

class _CidadeDropdownState extends State<CidadeDropdown> {
  String? valorSelecionado = null;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: "Município",
        labelStyle: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
        prefixIcon: Icon(
          Icons.location_city,
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
      style: TextStyle(color: Colors.white, fontSize: 18),
      dropdownColor: Colors.purple,
      value: valorSelecionado,
      onChanged: (String? novoValor) {
        setState(() {
          valorSelecionado = novoValor!;
        });
      },
      items: _cidades.cidadesDropdown,
    );
  }
}

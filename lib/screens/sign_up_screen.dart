import 'package:acaide/database/usuario_database.dart';
import 'package:acaide/models/usuario.dart';
import 'package:acaide/screens/login_screen.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/cidade.dart';
import '../models/cidades_repository.dart';

File? _fotoPerfil;
File? _fotoPerfilCortada;
final CidadesRepository _cidades = CidadesRepository();
List<DropdownMenuItem<String>> listCidades = [];
String? cidadeSelecionada = null;
bool temFotoPerfil = true;
bool clicado = false;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool show_password = false;
  Color top_color = Colors.purple;
  final UsuarioDatabase _dao = UsuarioDatabase();
  final TextEditingController controladorCampoNome = TextEditingController();
  final TextEditingController controladorCampoEmail = TextEditingController();
  final TextEditingController controladorCampoCpf = TextEditingController();
  final TextEditingController controladorCampoTelefone =
      TextEditingController();
  final TextEditingController controladorCampoSenha = TextEditingController();
  final TextEditingController controladorCampoConfirmarSenha =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    clicado = false;
    _fotoPerfil = null;
    _fotoPerfilCortada = null;
    cidadeSelecionada = null;
  }

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
              //Color.fromARGB(255, 255, 110, 255),
              top_color,
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
                key: _formKey,
                child: Column(
                  children: [
                    FotoPerfil(),
                    (temFotoPerfil)
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "Insira uma foto de perfil",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null) {
                            return "Insira o seu nome";
                          }
                          if (value.isEmpty) {
                            return "Insira o seu nome";
                          }
                          if (value.length < 6) {
                            return "Insira pelo menos o seu nome e sobrenome";
                          }
                          if (value.contains(RegExp(r'[0-9]'))) {
                            return "O nome não pode conter números";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        controller: controladorCampoNome,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: "Nome",
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
                        validator: (value) {
                          if (value == null) {
                            return "Insira o seu e-mail";
                          }
                          if (value.isEmpty) {
                            return "Insira o seu e-mail";
                          }
                          bool emailValido = EmailValidator.validate(value);
                          if (!emailValido) {
                            return "E-mail inválido";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: controladorCampoEmail,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: "acaide@acaide.com",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CpfInputFormatter(),
                        ],
                        validator: (value) {
                          if (value == null) {
                            return "Insira o seu CPF";
                          }
                          if (value.isEmpty) {
                            return "Insira o seu CPF";
                          }
                          if (!CPFValidator.isValid(value)) {
                            return "CPF inválido";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        controller: controladorCampoCpf,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: "000.000.000-00",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter(),
                        ],
                        validator: (value) {
                          if (value == null) {
                            return "Insira o seu número de telefone";
                          }
                          if (value.isEmpty) {
                            return "Insira o seu número de telefone";
                          }
                          if (value.length != 15) {
                            return "Número inválido";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        controller: controladorCampoTelefone,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: "(00) 90000-0000",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
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
                        validator: (value) {
                          if (value == null) {
                            return "Insira uma senha";
                          }
                          if (value.isEmpty) {
                            return "Insira uma senha";
                          }
                          if (value.length < 6) {
                            return "A senha deve conter no mínimo 6 caracteres";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        controller: controladorCampoSenha,
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
                              validator: (this.show_password == true)
                                  ? null
                                  : (value) {
                                      if (controladorCampoSenha.text !=
                                          controladorCampoConfirmarSenha.text) {
                                        return "As senhas não coincidem";
                                      }
                                      return null;
                                    },
                              keyboardType: TextInputType.visiblePassword,
                              controller: controladorCampoConfirmarSenha,
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
                  onPressed: (clicado)
                      ? null
                      : () {
                          if (_fotoPerfilCortada == null) {
                            setState(() {
                              temFotoPerfil = false;
                            });
                          } else {
                            setState(() {
                              temFotoPerfil = true;
                            });
                          }
                          if (_formKey.currentState!.validate() &&
                              _fotoPerfilCortada != null) {
                            setState(() {
                              clicado = true;
                            });
                            return cadastrar();
                          }
                        },
                  child: (clicado)
                      ? Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        )
                      : Text(
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

  Future<void> avisoVerificarEmail() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Aviso"),
            content: Text("Verifique o seu email para concluir o cadastro."),
            actions: [
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cadastro realizado com sucesso!'),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

  Future<void> dialogCarregamento() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  cadastrar() async {
    final String refFoto = "fotosPerfil/img-${DateTime.now().toString()}.jpg";
    final String emailSemEspaco = controladorCampoEmail.text.trim();
    final String telefone = controladorCampoTelefone.text[1] +
        controladorCampoTelefone.text[2] +
        controladorCampoTelefone.text[5] +
        controladorCampoTelefone.text[6] +
        controladorCampoTelefone.text[7] +
        controladorCampoTelefone.text[8] +
        controladorCampoTelefone.text[9] +
        controladorCampoTelefone.text[11] +
        controladorCampoTelefone.text[12] +
        controladorCampoTelefone.text[13] +
        controladorCampoTelefone.text[14];

    final String cpf = controladorCampoCpf.text[0] +
        controladorCampoCpf.text[1] +
        controladorCampoCpf.text[2] +
        controladorCampoCpf.text[4] +
        controladorCampoCpf.text[5] +
        controladorCampoCpf.text[6] +
        controladorCampoCpf.text[8] +
        controladorCampoCpf.text[9] +
        controladorCampoCpf.text[10] +
        controladorCampoCpf.text[12] +
        controladorCampoCpf.text[13];

    Map<String, int> cidadeUsuario = {};

    final List<Cidade> cidadesAPI = await _cidades.getCidadesFromAPI();
    cidadesAPI.forEach((element) {
      final int? cidadeId = int.tryParse(cidadeSelecionada!);
      if (element.id == cidadeId) {
        cidadeUsuario = {element.nome!: element.id!};
      }
    });

    var user = await _dao.cadastroEmailSenha(
        senha: controladorCampoSenha.text,
        email: emailSemEspaco,
        nome: controladorCampoNome.text);

    if (user == false) {
      setState(() {
        clicado = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao cadastrar usuário"),
        ),
      );
    } else {
      User userFirebase = user;
      final Usuario usuario = Usuario(
          id: userFirebase.uid,
          nome: controladorCampoNome.text,
          email: emailSemEspaco,
          cidade: cidadeUsuario,
          telefone: telefone,
          foto_perfil: refFoto,
          cpf: cpf);
      UploadTask task =
          await _dao.uploadFotoPerfil(_fotoPerfilCortada!.path, refFoto);
      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        switch (snapshot.state) {
          case TaskState.paused:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Cadastro pausado"),
              ),
            );
            break;
          case TaskState.running:
            dialogCarregamento();
            break;
          case TaskState.success:
            _dao.saveUsuarioFirestore(usuario);
            return avisoVerificarEmail();
          case TaskState.canceled:
            userFirebase.delete();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Erro ao cadastrar usuário"),
              ),
            );
            break;
          case TaskState.error:
            userFirebase.delete();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Erro ao cadastrar usuário"),
              ),
            );
            break;
        }
      });
    }
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
  cidadeList() async {
    listCidades = await _cidades.cidadesDropdown;
  }

  @override
  void initState() {
    super.initState();
    cidadeList();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      validator: (value) {
        if (value == null) {
          return "Selecione o seu município";
        }
        return null;
      },
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
      value: cidadeSelecionada,
      onChanged: (String? novoValor) {
        setState(() {
          cidadeSelecionada = novoValor!;
        });
      },
      items: listCidades,
    );
  }
}

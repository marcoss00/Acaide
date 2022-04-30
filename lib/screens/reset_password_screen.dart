import 'package:acaide/models/cidade.dart';
import 'package:acaide/models/usuario.dart';
import 'package:flutter/material.dart';
import '../database/usuario_database.dart';
import 'login_screen.dart';

bool clicado = false;

class ResetPasswordScreen extends StatefulWidget {
  final Usuario usuario;
  final List<Cidade> cidades;

  ResetPasswordScreen(this.usuario, this.cidades);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController controladorCampoEmail = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UsuarioDatabase _dao = UsuarioDatabase();

  @override
  void initState() {
    super.initState();
    clicado = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[800],
      body: Container(
        padding: EdgeInsets.only(top: 60, left: 30, right: 30),
        color: Colors.white,
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Icon(
                    Icons.lock_open_outlined,
                    size: 100,
                    color: Colors.purple,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Esqueceu sua senha?",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Informe o e-mail associado a sua conta que enviaremos um link para o mesmo com as instruções para restaurá-la.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: controladorCampoEmail,
                      validator: (value) {
                        if (value == null) {
                          return "Insira o seu e-mail";
                        }
                        if (value.isEmpty) {
                          return "Insira o seu e-mail";
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: "E-mail",
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        prefixIcon: Icon(
                          Icons.mail_outline,
                          color: Colors.black,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    height: 60,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.purple[800],
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: SizedBox.expand(
                      child: TextButton(
                        onPressed: (clicado)
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    clicado = true;
                                  });
                                  return recuperarSenha();
                                }
                              },
                        child: (clicado)
                            ? Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                "Enviar",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  recuperarSenha() async {
    final bool enviaEmail =
        await _dao.recuperarSenha(controladorCampoEmail.text.trim());
    if (enviaEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("E-mail enviado!"),
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginScreen(widget.usuario, widget.cidades),
        ),
      );
    } else {
      setState(() {
        clicado = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("E-mail não cadastrado"),
        ),
      );
    }
  }
}

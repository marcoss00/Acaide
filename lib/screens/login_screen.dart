import 'package:acaide/screens/anuncios_list.dart';
import 'package:acaide/screens/reset_password_screen.dart';
import 'package:acaide/screens/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../database/usuario_database.dart';

bool clicado = false;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color topColor = Colors.purple;
  bool continueConectado = false;
  final TextEditingController controladorCampoEmail = TextEditingController();
  final TextEditingController controladorCampoSenha = TextEditingController();
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 30,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              topColor,
              Color.fromARGB(255, 255, 220, 255),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "assets/images/logo_marca_completa.png",
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Entrar",
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
                    TextFormField(
                      validator: (value) {
                        if (value == null) {
                          return "Insira o seu e-mail";
                        }
                        if (value.isEmpty) {
                          return "Insira o seu e-mail";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: controladorCampoEmail,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: "E-mail",
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        prefixIcon: Icon(
                          Icons.mail_outline,
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
                    TextFormField(
                      validator: (value) {
                        if (value == null) {
                          return "Insira a sua senha";
                        }
                        if (value.isEmpty) {
                          return "Insira a sua senha";
                        }
                        return null;
                      },
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      controller: controladorCampoSenha,
                      style: TextStyle(
                        color: Colors.white,
                      ),
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Esqueceu a senha?",
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Checkbox(
                      value: this.continueConectado,
                      activeColor: Colors.purple,
                      onChanged: (bool? newValue) {
                        setState(() {
                          this.continueConectado = newValue!;
                        });
                      },
                    ),
                    Text(
                      "Continuar conectado?",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: (clicado)
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            clicado = true;
                          });
                          return logar();
                        }
                      },
                child: (clicado)
                    ? Container(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : Text("Login"),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.purple[800]!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Text(
                "Ainda não tem uma conta?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Cadastre-se",
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
                      Color.fromARGB(255, 255, 240, 255),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  logar() async {
    var user = await _dao.loginEmailSenha(
        controladorCampoEmail.text.trim(), controladorCampoSenha.text);

    if (user == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("E-mail ou senha incorretos"),
        ),
      );
      setState(() {
        clicado = false;
      });
    } else {
      User usuario = user;
      if (usuario.emailVerified) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AnunciosList(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("E-mail não verificado"),
          ),
        );
        setState(() {
          clicado = false;
        });
      }
    }
  }
}

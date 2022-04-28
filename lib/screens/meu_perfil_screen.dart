import 'package:acaide/components/drawer_item.dart';
import 'package:acaide/models/usuario.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

final Color textProfileColor = Colors.black87;

class MeuPerfilScreen extends StatefulWidget {
  final Usuario usuario;

  MeuPerfilScreen(this.usuario);

  @override
  State<MeuPerfilScreen> createState() => _MeuPerfilScreenState();
}

class _MeuPerfilScreenState extends State<MeuPerfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawerItem(),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Meu Perfil",
          style: TextStyle(
            fontFamily: "Cookie",
            fontSize: 28.0,
          ),
        ),
        backgroundColor: Colors.purple[800],
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.purple[800],
              alignment: Alignment.center,
              child: ProfileColumn(widget.usuario),
            ),
            Divider(
              color: Colors.grey.shade300,
              height: 8.0,
            ),
            AccountColumn(widget.usuario),
          ],
        ),
      ),
    );
  }
}

class ProfileColumn extends StatelessWidget {
  final Usuario usuario;

  ProfileColumn(this.usuario);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: deviceSize.height * 0.24,
      child: FittedBox(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(usuario.foto_perfil),
                        //foregroundColor: Colors.black,
                        radius: 80.0,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  (usuario.nome.split(' ').length < 2)
                      ? Text(
                          usuario.nome.split(' ')[0],
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        )
                      : Container(),
                  (usuario.nome.split(' ').length >= 2)
                      ? Text(
                          usuario.nome.split(' ')[0] + " " +
                              usuario.nome.split(' ')[1],
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        )
                      : Container(),
                  (usuario.nome.split(' ').length == 3)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            usuario.nome.split(' ')[2],
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                        )
                      : Container(),
                  (usuario.nome.split(' ').length == 4)
                      ? Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      usuario.nome.split(' ')[2] + " " + usuario.nome.split(' ')[3],
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  )
                      : Container(),
                  (usuario.nome.split(' ').length > 4)
                      ? Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      usuario.nome.split(' ')[2] + " " + usuario.nome.split(' ')[3] + " ...",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountColumn extends StatelessWidget {
  final Usuario usuario;

  AccountColumn(this.usuario);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: deviceSize.height * 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Telefone",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            color: textProfileColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: Text(
                          UtilBrasilFields.obterTelefone(usuario.telefone),
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                              color: textProfileColor),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "E-mail",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            color: textProfileColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: Text(
                          usuario.email,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                              color: textProfileColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "CPF",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: textProfileColor),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 5.0, bottom: 10.0),
                          child: Text(
                            UtilBrasilFields.obterCpf(usuario.cpf),
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: textProfileColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Município",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: textProfileColor),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 5.0, bottom: 10.0),
                          child: Text(
                            usuario.cidade.keys.first,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: textProfileColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

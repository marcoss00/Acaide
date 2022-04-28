import 'package:acaide/models/usuario.dart';
import 'package:acaide/screens/anuncio_form.dart';
import 'package:acaide/screens/anuncios_list.dart';
import 'package:acaide/screens/login_screen.dart';
import 'package:acaide/screens/preco_medio_screen.dart';
import 'package:acaide/screens/meu_perfil_screen.dart';
import 'package:acaide/screens/meus_anuncios_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../database/usuario_database.dart';

class DrawerItem extends StatefulWidget {
  const DrawerItem({Key? key}) : super(key: key);

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  bool logado = false;
  final UsuarioDatabase _dao = UsuarioDatabase();
  String idUsuario = "";

  @override
  void initState() {
    super.initState();
    var temUsuario = _dao.usuarioLogado();
    if (temUsuario == false) {
      logado = false;
    } else {
      User user = temUsuario;
      idUsuario = user.uid;
      logado = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Usuario>(
      future: _dao.findUsuario(idUsuario),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text('Nada encontrado. Tente novamente'),
            );
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          case ConnectionState.active:
            return Center(
              child: Text('Conexão incompleta'),
            );
          case ConnectionState.done:
            final Usuario? usuario = snapshot.data;
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                (this.logado == true)
                    ? UserAccountsDrawerHeader(
                        decoration: BoxDecoration(color: Colors.purple[800]),
                        accountEmail: Text(
                          usuario!.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        accountName: Text(
                          usuario.nome,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        currentAccountPicture: CircleAvatar(
                          backgroundImage:
                              NetworkImage(usuario.foto_perfil),
                        ),
                      )
                    : SizedBox(
                        height: 100,
                        child: DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.purple[800],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.login,
                              size: 30,
                              color: Colors.black54,
                            ),
                            label: Text(
                              "Entrar",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              ),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
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
                Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AnunciosList(),
                        ),
                      );
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 5),
                      leading: Image.asset(
                        "assets/images/logo-marca.png",
                        width: 40,
                        height: 40,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Anúncios",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  child: InkWell(
                    onTap: () {
                      if (logado) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AnuncioForm(),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      }
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.create,
                        color: Colors.purple[800],
                      ),
                      title: Text(
                        "Inserir Anúncio",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Material(
                  child: InkWell(
                    onTap: () {
                      if (logado) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MeusAnunciosList(),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      }
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.description,
                        color: Colors.purple[800],
                      ),
                      title: Text(
                        "Meus Anúncios",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PrecoMedioScreen(),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.stacked_bar_chart,
                        color: Colors.purple[800],
                      ),
                      title: Text(
                        "Preço Médio",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Material(
                  child: InkWell(
                    onTap: () {
                      if (logado) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MeuPerfilScreen(usuario!),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      }
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.purple[800],
                      ),
                      title: Text(
                        "Meu Perfil",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                (this.logado == true)
                    ? Material(
                        child: InkWell(
                          onTap: () => _signoutDialog(),
                          child: ListTile(
                            leading: Icon(
                              Icons.arrow_back,
                              color: Colors.purple[800],
                            ),
                            title: Text(
                              "Sair",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Divider(
                  color: (this.logado == true) ? Colors.black : null,
                ),
                Material(
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: Icon(
                        Icons.help,
                        color: Colors.purple[800],
                      ),
                      title: Text(
                        "Ajuda",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Material(
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: Icon(
                        Icons.bug_report,
                        color: Colors.purple[800],
                      ),
                      title: Text(
                        "Reportar Erro",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Material(
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: Icon(
                        Icons.announcement,
                        color: Colors.purple[800],
                      ),
                      title: Text(
                        "Sobre",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            );
        }
      },
    );
  }

  Future<void> _signoutDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Desconectar'),
        content: const Text('Você tem certeza?'),
        actions: [
          TextButton(
            child: const Text('Sim'),
            onPressed: () {
              _dao.signOut();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AnunciosList(),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Desconectado com sucesso!'),
                ),
              );
            },
          ),
          TextButton(
            child: const Text('Não'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}

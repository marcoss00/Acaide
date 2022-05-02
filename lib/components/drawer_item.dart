import 'package:acaide/models/cidade.dart';
import 'package:acaide/models/usuario.dart';
import 'package:acaide/screens/anuncio_form.dart';
import 'package:acaide/screens/anuncios_list.dart';
import 'package:acaide/screens/login_screen.dart';
import 'package:acaide/screens/preco_medio_screen.dart';
import 'package:acaide/screens/meu_perfil_screen.dart';
import 'package:acaide/screens/meus_anuncios_list.dart';
import 'package:flutter/material.dart';
import '../database/usuario_database.dart';

bool logado = false;

class DrawerItem extends StatefulWidget {
  final Usuario usuario;
  final List<Cidade> cidades;

  DrawerItem(this.usuario, this.cidades);

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  final UsuarioDatabase _dao = UsuarioDatabase();

  @override
  void initState() {
    super.initState();
    if (_dao.usuarioLogado() == false || widget.usuario.id == "id"){
      logado = false;
    }
    else{
      logado = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        (logado == true)
            ? UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Colors.purple[800]),
          accountEmail: Text(
            widget.usuario.email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          accountName: Text(
            widget.usuario.nome,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          currentAccountPicture: CircleAvatar(
            backgroundImage:
            NetworkImage(widget.usuario.foto_perfil),
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
                    builder: (context) => LoginScreen(widget.usuario, widget.cidades),
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
                  builder: (context) => AnunciosList(widget.usuario, widget.cidades),
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
                    builder: (context) => AnuncioForm(widget.usuario, widget.cidades),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(widget.usuario, widget.cidades),
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
                    builder: (context) => MeusAnunciosList(widget.usuario, widget.cidades),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(widget.usuario, widget.cidades),
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
                  builder: (context) => PrecoMedioScreen(widget.usuario, widget.cidades),
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
                    builder: (context) => MeuPerfilScreen(widget.usuario, widget.cidades),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(widget.usuario, widget.cidades),
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
        (logado == true)
            ? Material(
          child: InkWell(
            onTap: () => _signoutDialog(widget.usuario),
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
          color: (logado == true) ? Colors.black : null,
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

  Future<void> _signoutDialog(Usuario usuario) async {
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
                  builder: (context) => AnunciosList(widget.usuario, widget.cidades),
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

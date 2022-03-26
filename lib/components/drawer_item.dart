import 'package:flutter/material.dart';

class DrawerItem extends StatefulWidget {
  const DrawerItem({Key? key}) : super(key: key);

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  bool logado = true;
  bool foto_perfil = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        (this.logado == true)
            ? UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.purple[800]),
                accountEmail: Text("marcos18300024@aluno.cesupa.br"),
                accountName: Text("Marcos Vinicius"),
                currentAccountPicture: (this.foto_perfil == true)
                    ? CircleAvatar(
                        backgroundImage: AssetImage("assets/images/perfil.png"),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          "MV",
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        ),
                      ),
              )
            : SizedBox(
                height: 100,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.purple[800],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.login,
                      size: 30,
                      color: Colors.black54,
                    ),
                    label: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
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
        ListTile(
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
        ListTile(
          leading: Icon(
            Icons.create,
            color: Colors.purple[800],
          ),
          title: Text(
            "Inserir Anúncio",
            style: TextStyle(fontSize: 18),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.description,
            color: Colors.purple[800],
          ),
          title: Text(
            "Meus Anúncios",
            style: TextStyle(fontSize: 18),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.stacked_bar_chart,
            color: Colors.purple[800],
          ),
          title: Text(
            "Preço Médio",
            style: TextStyle(fontSize: 18),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.purple[800],
          ),
          title: Text(
            "Meu Perfil",
            style: TextStyle(fontSize: 18),
          ),
        ),
        (this.logado == true)
            ? ListTile(
                leading: Icon(
                  Icons.arrow_back,
                  color: Colors.purple[800],
                ),
                title: Text(
                  "Sair",
                  style: TextStyle(fontSize: 18),
                ),
              )
            : Container(),
        Divider(
          color: (this.logado == true) ? Colors.black : null,
        ),
        ListTile(
          leading: Icon(
            Icons.help,
            color: Colors.purple[800],
          ),
          title: Text(
            "Ajuda",
            style: TextStyle(fontSize: 18),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.bug_report,
            color: Colors.purple[800],
          ),
          title: Text(
            "Reportar Erro",
            style: TextStyle(fontSize: 18),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.announcement,
            color: Colors.purple[800],
          ),
          title: Text(
            "Sobre",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}

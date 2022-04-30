import 'package:acaide/models/usuario.dart';
import 'package:acaide/screens/anuncios_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'database/usuario_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AcaideApp());
}

class AcaideApp extends StatelessWidget {
  final UsuarioDatabase _dao = UsuarioDatabase();

  @override
  Widget build(BuildContext context) {
    String idUsuario = "";
    var temUsuario = _dao.usuarioLogado();
    if (temUsuario != false) {
      User user = temUsuario;
      idUsuario = user.uid;
    }
    return ScreenUtilInit(
      builder: (BuildContext context) {
        return MaterialApp(
          theme: ThemeData(
            unselectedWidgetColor: Colors.white,
          ),
          home: FutureBuilder<Usuario>(
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
                  if (usuario == null) {
                    final Usuario usuarioNulo = Usuario(
                        id: 'id',
                        nome: 'nome',
                        email: 'email',
                        cidade: {},
                        telefone: 'telefone',
                        foto_perfil: 'foto_perfil',
                        cpf: 'cpf');
                    return AnunciosList(usuarioNulo);
                  } else {
                    return AnunciosList(usuario);
                  }
              }
            },
          ),
        );
      },
    );
  }
}

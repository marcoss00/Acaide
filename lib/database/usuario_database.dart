import 'dart:io';
import 'package:acaide/models/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UsuarioDatabase {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  static const String _tableName = 'usuarios';
  static const String _id = 'id';
  static const String _nome = 'nome';
  static const String _email = 'email';
  static const String _cidade = 'cidade';
  static const String _telefone = 'telefone';
  static const String _fotoPerfil = 'foto_perfil';
  static const String _cpf = 'cpf';

  Future loginEmailSenha(String email, String senha) async {
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      user = userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future cadastroEmailSenha({
    required String senha,
    required String email,
    required String nome,
  }) async {
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: senha);
      user = userCredential.user;
      await user!.updateDisplayName(nome);
      await user.reload();
      user = auth.currentUser;
      user?.sendEmailVerification();
      return user;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future saveUsuarioFirestore(Usuario usuario) async {
    final DocumentReference save =
        await firestore.collection(_tableName).doc(usuario.id);
    final Map<String, dynamic> anuncioMap = {};
    anuncioMap[_id] = usuario.id;
    anuncioMap[_nome] = usuario.nome;
    anuncioMap[_email] = usuario.email;
    anuncioMap[_cidade] = usuario.cidade;
    anuncioMap[_telefone] = usuario.telefone;
    anuncioMap[_fotoPerfil] = usuario.foto_perfil;
    anuncioMap[_cpf] = usuario.cpf;
    return save.set(anuncioMap);
  }

  Future<Usuario> findUsuario(String idUser) async {
    final query = await firestore.collection(_tableName).doc(idUser).get();
    final String urlImagem =
    await storage.ref(query.get(_fotoPerfil)).getDownloadURL();
    final Map<dynamic, dynamic> cidade = query.get(_cidade);
    final Map<String, int> cidadeConvertido = cidade.cast<String, int>();
    final Usuario usuario = Usuario(
        id: query.get(_id),
        nome: query.get(_nome),
        email: query.get(_email),
        cidade: cidadeConvertido,
        telefone: query.get(_telefone),
        foto_perfil: urlImagem,
        cpf: query.get(_cpf));
    return usuario;
  }

  Future recuperarSenha(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<UploadTask> uploadFotoPerfil(String path, String fotoPerfilRef) async {
    File file = File(path);
    try {
      return storage.ref(fotoPerfilRef).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  Future signOut() async {
    try {
      return auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  usuarioLogado() {
    User? user = auth.currentUser;
    if (user != null) {
      return user;
    } else {
      return false;
    }
  }

  Future deleteFotoPerfil(String foto_perfil) async {
    return await storage.ref(foto_perfil).delete();
  }

  Future deleteUsuarioFirestore(Usuario usuario) async {
    final delete = await firestore.collection(_tableName).doc(usuario.id);
    return delete.delete();
  }
}

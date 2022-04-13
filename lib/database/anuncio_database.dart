import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/anuncio.dart';

class AnuncioDatabase {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static const String _tableName = 'anuncios';
  static const String _id = 'id';
  static const String _titulo = 'titulo';
  static const String _tipoAnunciante = 'tipo_anunciante';
  static const String _quantRasas = 'quant_rasas';
  static const String _entrega = 'entrega';
  static const String _preco = 'preco';
  static const String _cidades = 'cidades';
  static const String _imagem = 'image';
  static const String _descricao = 'descricao';

  Future saveAnuncio(Anuncio anuncio) async {
    final DocumentReference save =
        await firestore.collection(_tableName).doc(anuncio.id);
    final Map<String, dynamic> anuncioMap = {};
    anuncioMap[_id] = anuncio.id;
    anuncioMap[_titulo] = anuncio.titulo;
    anuncioMap[_tipoAnunciante] = anuncio.tipo_anunciante;
    anuncioMap[_quantRasas] = anuncio.quant_rasas;
    anuncioMap[_entrega] = anuncio.entrega;
    anuncioMap[_preco] = anuncio.preco;
    anuncioMap[_cidades] = anuncio.cidades;
    anuncioMap[_imagem] = anuncio.imagem;
    anuncioMap[_descricao] = anuncio.descricao;
    return save.set(anuncioMap);
  }

  Future<List<Anuncio>> findAllAnuncio() async {
    final QuerySnapshot query = await firestore.collection(_tableName).get();
    final List<Anuncio> anuncios = [];
    for (var doc in query.docs) {
      final String urlImagem =
          await storage.ref(doc.get(_imagem)).getDownloadURL();
      final Map<dynamic, dynamic> cidades = doc.get(_cidades);
      final Map<String, int> cidadesConvertido = cidades.cast<String, int>();
      final Anuncio anuncio = Anuncio(
        id: doc.get(_id),
        titulo: doc.get(_titulo),
        tipo_anunciante: doc.get(_tipoAnunciante),
        quant_rasas: doc.get(_quantRasas),
        entrega: doc.get(_entrega),
        preco: doc.get(_preco),
        cidades: cidadesConvertido,
        imagem: urlImagem,
        descricao: doc.get(_descricao),
      );
      anuncios.add(anuncio);
    }
    return anuncios;
  }

  Future<UploadTask> uploadImagemAnuncio(String path, String imagemRef) async {
    File file = File(path);
    try {
      return storage.ref(imagemRef).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  Future deleteAnuncio(Anuncio anuncio) async {
    final delete = await firestore.collection(_tableName).doc(anuncio.id);
    await storage.refFromURL(anuncio.imagem).delete();
    return delete.delete();
  }
}

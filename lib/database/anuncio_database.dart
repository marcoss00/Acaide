import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/anuncio.dart';

class AnuncioDatabase {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static const String _tableName = 'anuncios';
  static const String _id = 'id';
  static const String _idUsuario = 'id_usuario';
  static const String _titulo = 'titulo';
  static const String _tipoAnunciante = 'tipo_anunciante';
  static const String _quantRasas = 'quant_rasas';
  static const String _entrega = 'entrega';
  static const String _preco = 'preco';
  static const String _cidades = 'cidades';
  static const String _imagem = 'image';
  static const String _descricao = 'descricao';
  static const String _dataCriacao = 'data_criacao';
  static const String _fotoPerfilUsuario = 'foto_perfil_usuario';
  static const String _nomeUsuario = 'nome_usuario';
  static const String _telefoneUsuario = 'telefone_usuario';

  Future saveAnuncio(Anuncio anuncio) async {
    final DocumentReference save = await firestore
        .collection("/usuarios/${anuncio.idUsuario}/" + _tableName)
        .doc(anuncio.id);
    final Map<String, dynamic> anuncioMap = {};
    anuncioMap[_id] = anuncio.id;
    anuncioMap[_idUsuario] = anuncio.idUsuario;
    anuncioMap[_titulo] = anuncio.titulo;
    anuncioMap[_tipoAnunciante] = anuncio.tipo_anunciante;
    anuncioMap[_quantRasas] = anuncio.quant_rasas;
    anuncioMap[_entrega] = anuncio.entrega;
    anuncioMap[_preco] = anuncio.preco;
    anuncioMap[_cidades] = anuncio.cidades;
    anuncioMap[_imagem] = anuncio.imagem;
    anuncioMap[_descricao] = anuncio.descricao;
    anuncioMap[_dataCriacao] = anuncio.dataCriacao;
    anuncioMap[_fotoPerfilUsuario] = anuncio.fotoPerfilUsuario;
    anuncioMap[_nomeUsuario] = anuncio.nomeUsuario;
    anuncioMap[_telefoneUsuario] = anuncio.telefoneUsuario;
    return save.set(anuncioMap);
  }

  Future<List<Anuncio>> findAllAnuncio() async {
    final QuerySnapshot queryUser =
        await firestore.collection("/usuarios").get();
    final List<Anuncio> anuncios = [];
    for (var doc in queryUser.docs) {
      final QuerySnapshot queryAnuncio = await firestore
          .collection("/usuarios/" + doc.get("id") + "/anuncios")
          .orderBy("data_criacao", descending: true)
          .get();
      for (var doc in queryAnuncio.docs) {
        final String urlImagem =
            await storage.ref(doc.get(_imagem)).getDownloadURL();
        final String urlFotoPerfilUsuario =
            await storage.ref(doc.get(_fotoPerfilUsuario)).getDownloadURL();
        final Map<dynamic, dynamic> cidades = doc.get(_cidades);
        final Map<String, int> cidadesConvertido = cidades.cast<String, int>();
        final Timestamp dataCriacaoConvertido = doc.get(_dataCriacao);
        final Anuncio anuncio = Anuncio(
          id: doc.get(_id),
          idUsuario: doc.get(_idUsuario),
          titulo: doc.get(_titulo),
          tipo_anunciante: doc.get(_tipoAnunciante),
          quant_rasas: doc.get(_quantRasas),
          entrega: doc.get(_entrega),
          preco: doc.get(_preco),
          cidades: cidadesConvertido,
          imagem: urlImagem,
          descricao: doc.get(_descricao),
          dataCriacao: dataCriacaoConvertido.toDate(),
          fotoPerfilUsuario: urlFotoPerfilUsuario,
          nomeUsuario: doc.get(_nomeUsuario),
          telefoneUsuario: doc.get(_telefoneUsuario),
        );
        final dataAtual = DateTime.now();
        final dataInicioAnuncio = dataCriacaoConvertido.toDate();
        final dataFimAnuncio = DateTime.utc(
          dataInicioAnuncio.year,
          dataInicioAnuncio.month,
          dataInicioAnuncio.day + 1,
          dataInicioAnuncio.hour,
          dataInicioAnuncio.minute,
          dataInicioAnuncio.second,
          dataInicioAnuncio.millisecond,
          dataInicioAnuncio.microsecond,
        );
        if (dataAtual.isAfter(dataFimAnuncio)) {
          deleteAnuncio(anuncio);
        } else {
          anuncios.add(anuncio);
        }
      }
    }
    anuncios.sort((a, b) {
      return b.dataCriacao.compareTo(a.dataCriacao);
    });
    return anuncios;
  }

  Future<List<Anuncio>> findAllAnuncioFiltrado(
      List<Object?> cidadesFiltro) async {
    final Map<String, int> cidadesSelecionadasMap = Map.fromIterable(
        cidadesFiltro,
        key: (cidade) => cidade.nome,
        value: (cidade) => cidade.id);
    final QuerySnapshot queryUser =
        await firestore.collection("/usuarios").get();
    final List<Anuncio> anuncios = [];
    for (var doc in queryUser.docs) {
      final QuerySnapshot queryAnuncio = await firestore
          .collection("/usuarios/" + doc.get("id") + "/anuncios")
          .orderBy("data_criacao", descending: true)
          .get();
      for (var doc in queryAnuncio.docs) {
        bool encontrado = false;
        final Map<dynamic, dynamic> cidades = doc.get(_cidades);
        final Map<String, int> cidadesConvertido = cidades.cast<String, int>();
        cidadesConvertido.forEach((cidadeAnuncio, value) {
          cidadesSelecionadasMap.forEach((cidadeSelecionada, value) {
            if (cidadeAnuncio == cidadeSelecionada) {
              encontrado = true;
            }
          });
        });
        if (encontrado) {
          final String urlImagem =
              await storage.ref(doc.get(_imagem)).getDownloadURL();
          final Timestamp dataCriacaoConvertido = doc.get(_dataCriacao);
          final String urlFotoPerfilUsuario =
              await storage.ref(doc.get(_fotoPerfilUsuario)).getDownloadURL();
          final Anuncio anuncio = Anuncio(
            id: doc.get(_id),
            idUsuario: doc.get(_idUsuario),
            titulo: doc.get(_titulo),
            tipo_anunciante: doc.get(_tipoAnunciante),
            quant_rasas: doc.get(_quantRasas),
            entrega: doc.get(_entrega),
            preco: doc.get(_preco),
            cidades: cidadesConvertido,
            imagem: urlImagem,
            descricao: doc.get(_descricao),
            dataCriacao: dataCriacaoConvertido.toDate(),
            fotoPerfilUsuario: urlFotoPerfilUsuario,
            nomeUsuario: doc.get(_nomeUsuario),
            telefoneUsuario: doc.get(_telefoneUsuario),
          );
          final dataAtual = DateTime.now();
          final dataInicioAnuncio = dataCriacaoConvertido.toDate();
          final dataFimAnuncio = DateTime.utc(
            dataInicioAnuncio.year,
            dataInicioAnuncio.month,
            dataInicioAnuncio.day + 1,
            dataInicioAnuncio.hour,
            dataInicioAnuncio.minute,
            dataInicioAnuncio.second,
            dataInicioAnuncio.millisecond,
            dataInicioAnuncio.microsecond,
          );
          if (dataAtual.isAfter(dataFimAnuncio)) {
            deleteAnuncio(anuncio);
          } else {
            anuncios.add(anuncio);
          }
        }
      }
    }
    anuncios.sort((a, b) {
      return b.dataCriacao.compareTo(a.dataCriacao);
    });
    return anuncios;
  }

  Future<List<Anuncio>> findAnuncioUsuario(String idUsuario) async {
    final QuerySnapshot query = await firestore
        .collection("/usuarios/${idUsuario}/" + _tableName)
        .orderBy("data_criacao", descending: true)
        .get();
    final List<Anuncio> anuncios = [];
    for (var doc in query.docs) {
      final String urlImagem =
          await storage.ref(doc.get(_imagem)).getDownloadURL();
      final Map<dynamic, dynamic> cidades = doc.get(_cidades);
      final Map<String, int> cidadesConvertido = cidades.cast<String, int>();
      final Timestamp dataCriacaoConvertido = doc.get(_dataCriacao);
      final String urlFotoPerfilUsuario =
          await storage.ref(doc.get(_fotoPerfilUsuario)).getDownloadURL();
      final Anuncio anuncio = Anuncio(
        id: doc.get(_id),
        idUsuario: doc.get(_idUsuario),
        titulo: doc.get(_titulo),
        tipo_anunciante: doc.get(_tipoAnunciante),
        quant_rasas: doc.get(_quantRasas),
        entrega: doc.get(_entrega),
        preco: doc.get(_preco),
        cidades: cidadesConvertido,
        imagem: urlImagem,
        descricao: doc.get(_descricao),
        dataCriacao: dataCriacaoConvertido.toDate(),
        fotoPerfilUsuario: urlFotoPerfilUsuario,
        nomeUsuario: doc.get(_nomeUsuario),
        telefoneUsuario: doc.get(_telefoneUsuario),
      );
      final dataAtual = DateTime.now();
      final dataInicioAnuncio = dataCriacaoConvertido.toDate();
      final dataFimAnuncio = DateTime.utc(
        dataInicioAnuncio.year,
        dataInicioAnuncio.month,
        dataInicioAnuncio.day + 1,
        dataInicioAnuncio.hour,
        dataInicioAnuncio.minute,
        dataInicioAnuncio.second,
        dataInicioAnuncio.millisecond,
        dataInicioAnuncio.microsecond,
      );
      if (dataAtual.isAfter(dataFimAnuncio)) {
        deleteAnuncio(anuncio);
      } else {
        anuncios.add(anuncio);
      }
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
    final delete = await firestore
        .collection("/usuarios/${anuncio.idUsuario}/" + _tableName)
        .doc(anuncio.id);
    await storage.refFromURL(anuncio.imagem).delete();
    return delete.delete();
  }

  Future deleteImagemAnuncio(String url) async {
    return await storage.refFromURL(url).delete();
  }

  Future getRef(String url) async {
    final String ref = await storage.refFromURL(url).fullPath;
    return ref;
  }
}

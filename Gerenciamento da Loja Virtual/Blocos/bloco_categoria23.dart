import 'dart:io';
import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class BlocoCategoria extends BlocBase {
  final _controladorTitulo = BehaviorSubject<String>();
  final _controladorImagem = BehaviorSubject();
  final _controladorDeletar = BehaviorSubject<bool>();

  Stream<String> get saidaTitulo => _controladorTitulo.stream.transform(
    StreamTransformer<String, String>.fromHandlers(
      handleData: (titulo, sink) {
        if (titulo.isEmpty)
          sink.addError('Insira um título');
        else
          sink.add(titulo);
      },
    ),
  );

  Stream get saidaImagem => _controladorImagem.stream;

  Stream<bool> get saidaDeletar => _controladorDeletar.stream;

  Stream<bool> get submitValid =>
      Rx.combineLatest2(saidaTitulo, saidaImagem, (a, b) => true);

  DocumentSnapshot? categoria;

  String? titulo;

  File? imagem;

  BlocoCategoria(this.categoria) {
    if (categoria != null) {
      final dados = categoria!.data() as Map<String, dynamic>;
      titulo = dados['title'];
      _controladorTitulo.add(dados['title']);
      _controladorImagem.add(dados['icon']);
      _controladorDeletar.add(true);
    } else {
      _controladorDeletar.add(false);
    }
  }

  void setImage(File arquivo) {
    imagem = arquivo;
    _controladorImagem.add(arquivo);
  }

  void setTitle(String titulo) {
    this.titulo = titulo;
    _controladorTitulo.add(titulo);
  }

  void deletar(){
    categoria!.reference.delete();
  }

  Future salvarDados() async {
    final dados = categoria!.data() as Map<String, dynamic>;
    if(imagem == null && categoria != null && titulo == dados['title']) return;

    Map<String, dynamic> dadosParaSalvar = {};

    if(imagem != null){
      UploadTask task = FirebaseStorage.instance.ref().child('icons')
          .child(titulo!).putFile(imagem!);
      TaskSnapshot snap = await task;
      dadosParaSalvar['icon'] = await snap.ref.getDownloadURL();
    }
    if(categoria == null || titulo != dados['title']){
      dadosParaSalvar['title'] = titulo;
    }
    if(categoria == null){
      await FirebaseFirestore.instance.collection('products').doc(titulo!.toLowerCase())
          .set(dadosParaSalvar);
    } else {
      await categoria!.reference.update(dadosParaSalvar);
    }
  }

  @override
  void dispose() {
    _controladorTitulo.close();
    _controladorImagem.close();
    _controladorDeletar.close();
  }
}

import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BlocoProdutos extends BlocBase {
  final _controladorDados = BehaviorSubject<Map<String, dynamic>>();
  final _carregandoControlador = BehaviorSubject<bool>();
  final _criadoControlador = BehaviorSubject<bool>();

  Stream<Map<String, dynamic>> get saidaDados => _controladorDados.stream;
  Stream<bool> get saidaCarregando => _carregandoControlador.stream;
  Stream<bool> get saidaCriado => _criadoControlador.stream;

  String? categoriaId;
  DocumentSnapshot? produto;

  late Map<String, dynamic> dadosNaoSalvos;

  BlocoProdutos({this.categoriaId, this.produto}) {
    if (produto != null) {
      final dados = produto!.data() as Map<String, dynamic>?;

      dadosNaoSalvos = Map.of(dados!);
      dadosNaoSalvos['images'] = List.of(dados['images']);
      dadosNaoSalvos['sizes'] = List.of(dados['sizes']);
      _criadoControlador.add(true);
    } else {
      dadosNaoSalvos = {
        'title': null,
        'description': null,
        'price': null,
        'images': [],
        'sizes': [],
      };
      _criadoControlador.add(false);
    }

    _controladorDados.add(dadosNaoSalvos);
  }

  void salvarTitulo(String? titulo) {
    dadosNaoSalvos['title'] = titulo;
    _controladorDados.add(dadosNaoSalvos);
  }

  void salvarDescricao(String? descricao) {
    dadosNaoSalvos['description'] = descricao;
    _controladorDados.add(dadosNaoSalvos);
  }

  void salvarPreco(String? preco) {
    if (preco != null && preco.isNotEmpty) {
      dadosNaoSalvos['price'] = double.tryParse(preco) ?? 0.0;
    }
    _controladorDados.add(dadosNaoSalvos);
  }

  void salvarImagens(List<dynamic>? imagens) {
    if (imagens != null) {
      dadosNaoSalvos['images'] = imagens;
      _controladorDados.add(dadosNaoSalvos);
    }
  }

  void salvarTamanhos(List tamanhos) {
    if (tamanhos != null) {
      dadosNaoSalvos['images'] = tamanhos;
      _controladorDados.add(dadosNaoSalvos);
    }
  }


  Future<bool> salvarProduto() async {
    _carregandoControlador.add(true);

    try {
      if (produto != null) {
        await _uploadImagens(produto!.id);
        await produto!.reference.update(dadosNaoSalvos);
      } else {
        // Primeiro salva o produto com informações básicas
        DocumentReference dr = await FirebaseFirestore.instance
            .collection('products')
            .doc(categoriaId)
            .collection('items')
            .add({
          'title': dadosNaoSalvos['title'],
          'description': dadosNaoSalvos['description'],
          'price': dadosNaoSalvos['price'],
          'images': [], // inicia vazio!
          'sizes': dadosNaoSalvos['sizes'] ?? [],
        });

        // Depois faz upload das imagens e atualiza
        await _uploadImagens(dr.id);
        await dr.update({
          'images': dadosNaoSalvos['images'],
        });
      }
      _criadoControlador.add(true);
      _carregandoControlador.add(false);
      return true;
    } catch (e) {
      print("Erro ao salvar produto: $e");
      _carregandoControlador.add(false);
      return false;
    }
  }


  Future<void> _uploadImagens(String produtoId) async {
    for (int i = 0; i < dadosNaoSalvos['images'].length; i++) {
      if (dadosNaoSalvos['images'][i] is File) {
        File imagem = dadosNaoSalvos['images'][i];

        // Cria o caminho da imagem no Firebase Storage
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('products')
            .child(produtoId)
            .child(DateTime.now().millisecondsSinceEpoch.toString());

        // Faz upload da imagem
        UploadTask uploadTask = ref.putFile(imagem);

        // Espera o upload terminar
        TaskSnapshot snapshot = await uploadTask;

        // Pega a URL da imagem salva no Storage
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Atualiza a lista substituindo o File pela URL
        dadosNaoSalvos['images'][i] = downloadUrl;
      }
    }
  }

  void deletarProduto(){
    produto!.reference.delete();
  }



  @override
  void dispose() {
    _controladorDados.close();
    _carregandoControlador.close();
    _criadoControlador.close();
  }
}

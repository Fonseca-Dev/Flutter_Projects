import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Widgets/categoria_tile14.dart';

class TabProdutos extends StatefulWidget {
  const TabProdutos({super.key});

  @override
  State<TabProdutos> createState() => _TabProdutosState();
}

class _TabProdutosState extends State<TabProdutos>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: StreamBuilder<QuerySnapshot>(
        //Para obter a lista do FireBase uma vez e em tempo real
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
      
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            );
          return ListView.builder(
            //Criação de categorias na tela
            //Lista de categorias
            itemCount: snapshot.data!.docs.length, //Pega a qtde de categorias
            itemBuilder: (context, index) {
              //index é o item que será desenhado na tela
              return CategoriaTile(snapshot.data!.docs[index]);
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/Widgets/dialog_editar_categoria22.dart';

import '../Telas/tela_produtos15.dart';

class CategoriaTile extends StatelessWidget {
  final DocumentSnapshot categoria;

  CategoriaTile(this.categoria);

  @override
  Widget build(BuildContext context) {
    final data = categoria.data() as Map<String, dynamic>?;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: (){
              showDialog(
                  context: context,
                  builder: (context) => DialogEditarCategoria(
                    categoria: categoria,
                  )
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(data!['icon']),
              backgroundColor: Colors.transparent,
            ),
          ),
          title: Text(
            data['title'],
            style: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: [
            FutureBuilder<QuerySnapshot>(
              //Para obter uma lista de produtos do firebase
              future: categoria.reference.collection('items').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return Column(
                  children:
                      snapshot.data!.docs.map((doc) {
                          final itemData = doc.data() as Map<String, dynamic>;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                itemData['images'][0],
                              ),
                            ),
                            title: Text(itemData['title']),
                            trailing: Text(
                              "R\$ ${itemData['price'].toStringAsFixed(2)}",
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => TelaProdutos(
                                        categoriaId: categoria.id,
                                        produto: doc,
                                      ),
                                ),
                              );
                            },
                          );
                        }).toList()
                        ..add(
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.add, color: Colors.pinkAccent),
                            ),
                            title: Text('Adicionar'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => TelaProdutos(
                                        categoriaId: categoria.id,
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

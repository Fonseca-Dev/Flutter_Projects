import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Blocos/bloco_usuario7.dart';

class CabecalhoPedido extends StatelessWidget {
  final DocumentSnapshot pedido;

  CabecalhoPedido(this.pedido);

  @override
  Widget build(BuildContext context) {
    final data = pedido.data() as Map<String, dynamic>?;

    final _blocoUsuario = BlocProvider.getBloc<BlocoUsuario>();

    if (data == null) {
      return Text('Dados do pedido indisponíveis');
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_blocoUsuario.carregarUsuario(data['clientId'])['name']}',
              ),
              Text(
                '${_blocoUsuario.carregarUsuario(data['clientId'])['address']}',
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Produtos: R\$ ${data['productsPrice'].toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text('Total: R\$ ${data['totalPrice'].toStringAsFixed(2)}'),
          ],
        ),
      ],
    );
  }
}

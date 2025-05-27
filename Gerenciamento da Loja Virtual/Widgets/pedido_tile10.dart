import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'cabecalho_pedido11.dart';

class PedidoTile extends StatelessWidget {
  final DocumentSnapshot pedido;

  final estados = [
    '',
    'Em preparação',
    'Em transporte',
    'Aguardando Entrega',
    'Entregue',
  ];

  PedidoTile(this.pedido);

  @override
  Widget build(BuildContext context) {
    final data = pedido.data() as Map<String, dynamic>?;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(pedido.id),
          initiallyExpanded: data!['status'] != 4,
          title: Text(
            '#${pedido.id.substring(pedido.id.length - 7)} - '
                '${estados[data['status']]}',
            style: TextStyle(color: (data['status']) != 4 ? Colors.grey.shade800 : Colors.green),
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CabecalhoPedido(pedido),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: (data['products'] as List<dynamic>? ?? []).map((p) {
                      final product = p['product'] as Map<String, dynamic>?;
                      return ListTile(
                        title: Text(
                          '${product?['title'] ?? 'Produto'} ${p['size'] ?? ''}',
                        ),
                        subtitle: Text(
                          '${p['category'] ?? ''}/${p['pid'] ?? ''}',
                        ),
                        trailing: Text(
                          '${p['quantity']?.toString() ?? '0'}',
                          style: TextStyle(fontSize: 20),
                        ),
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection('users').doc(pedido['clientId']).
                          collection('orders').doc(pedido.id).delete();
                          pedido.reference.delete();
                        },
                        child: Text(
                          'Excluir',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: data['status'] > 1 ? () {
                          pedido.reference.update({'status' : data['status'] - 1});
                        } : null,
                        child: Text(
                          'Regredir',
                          style: TextStyle(color: Colors.grey.shade800),
                        ),
                      ),
                      TextButton(
                        onPressed: data['status'] < 4 ? () {
                          pedido.reference.update({'status' : data['status'] + 1});
                        } : null,
                        child: Text(
                          'Avançar',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

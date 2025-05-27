import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartaoPedido extends StatelessWidget {
  final String pedidoId;

  CartaoPedido(this.pedidoId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('orders')
                  .doc(pedidoId)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!.data() as Map<String, dynamic>?;

            if (data == null) {
              return Center(child: Text("Erro ao carregar pedido"));
            }

            int status = data['status'] ?? 0; // Se 'status' não existir, assume 0.

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Código do pedido: ${snapshot.data!.id}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(_buildProductsText(snapshot.data!)),
                SizedBox(height: 4.0),
                Text(
                  'Status do Pedido:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCircle('1', 'Preparação', status, 1),
                    Container(
                      height: 1.0,
                      width: 40.0,
                      color: Colors.grey[500],
                    ),
                    _buildCircle('2', 'Transporte', status, 2),
                    Container(
                      height: 1.0,
                      width: 40.0,
                      color: Colors.grey[500],
                    ),
                    _buildCircle('3', 'Entrega', status, 3),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = "Descrição:\n";

    final data = snapshot.data() as Map<String, dynamic>?;

    if (data != null && data['products'] != null && data['products'] is List) {
      List products = data['products'];

      for (var p in products) {
        print("🔍 Produto encontrado: $p");

        var quantity = p['quantity'] ?? 0;
        var product = p['products'] as Map<String, dynamic>?; // CORREÇÃO AQUI!

        if (product != null) {
          var title = product['title'] ?? 'Produto desconhecido';
          var price = (product['price'] ?? 0.0) as double;

          print(
            "✅ Adicionando ao texto: $quantity x $title (R\$ ${price.toStringAsFixed(2)})",
          );

          text += '$quantity x $title (R\$ ${price.toStringAsFixed(2)})\n';
        }
      }
    } else {
      text += "Nenhum produto encontrado.\n";
    }

    double totalPrice = (data?['totalPrice'] ?? 0.0) as double;
    text += 'Total: R\$ ${totalPrice.toStringAsFixed(2)}';

    return text;
  }

  Widget _buildCircle(
    String titulo,
    String subtitulo,
    int status,
    int thisStatus,
  ) {
    Color? corFundo;
    Widget child;

    if (status < thisStatus) {
      corFundo = Colors.grey[500];
      child = Text(titulo, style: TextStyle(color: Colors.white));
    } else if (status == thisStatus) {
      corFundo = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: [
          Text(titulo, style: TextStyle(color: Colors.white)),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      );
    } else {
      corFundo = Colors.green;
      child = Icon(Icons.check, color: Colors.white,);
    }

    return Column(
      children: [
        CircleAvatar(radius: 20.0, backgroundColor: corFundo, child: child),
        Text(subtitulo)
      ],
    );
  }
}

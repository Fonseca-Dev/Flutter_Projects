import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/models/cart_model.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      CartModel.of(context).updatePrices();
      return Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              cartProduct.productData!.images![0],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.grey,
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cartProduct.productData?.title ?? 'Título Indisponível',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    'Tamanho: ${cartProduct.size}',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    'R\$ ${(cartProduct.productData!.price ?? 0.0).toStringAsFixed(2)}',
                    // Valor padrão de 0.0 se price for null
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: cartProduct.quantity! > 1 ? () {
                          CartModel.of(context).decProduct(cartProduct);
                        } : null,
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(cartProduct.quantity.toString()),
                      IconButton(
                        onPressed: () {
                          CartModel.of(context).incProduct(cartProduct);
                        },
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                      ),
                      TextButton(
                        onPressed: () {
                          CartModel.of(context).removeCartItem(cartProduct);
                        },
                        child: Text(
                          'Remover',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child:
          cartProduct.productData == null
              ? FutureBuilder<DocumentSnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection('products')
                        .doc(cartProduct.category)
                        .collection('items')
                        .doc(cartProduct.pid)
                        .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    cartProduct.productData = ProductData.fromDocument(
                      snapshot.data!,
                    );
                    return _buildContent();
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container(
                      height: 70.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container(
                      height: 70.0,
                      alignment: Alignment.center,
                      child: Text("Erro ao carregar produto"),
                    );
                  }
                },
              )
              : _buildContent(),
    );
  }
}

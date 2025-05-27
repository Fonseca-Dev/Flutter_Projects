import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatelessWidget {

  final VoidCallback buy;

  CartPrice(this.buy);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ScopedModelDescendant<CartModel>(
          builder: (context, child, model) {

            double price = model.getProductsPrice();
            double discount = model.getDiscount();
            double ship = model.getShipPrice();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Resumo do Pedido',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('Subtotal'), Text('R\$ ${price.toStringAsFixed(2)}')],
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('Desconto'), Text('R\$ -${discount.toStringAsFixed(2)}')],
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('Entrega'), Text('R\$ ${ship.toStringAsFixed(2)}')],
                ),
                SizedBox(height: 8.0),
                SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'R\$ ${(price-discount+ship).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                ElevatedButton(
                  onPressed: buy,
                  child: Text(
                    'Finalizar Pedido',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/product_data.dart';

import '../screens/product_screen.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final ProductData product;

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>ProductScreen(product))
        );
      },
      child: Card(
        child:
            type == 'grid'
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 0.8,
                      child: Image.network(
                        product.images![0],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              product.title ?? 'Sem título',
                              // Se for null, mostra 'Sem título',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'R\$ ${product.price?.toStringAsFixed(2) ?? '0.00'}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                : Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Image.network(
                        product.images![0],
                        fit: BoxFit.cover,
                        height: 250.0,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title ?? 'Sem título',
                              // Se for null, mostra 'Sem título',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'R\$ ${product.price?.toStringAsFixed(2) ?? '0.00'}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/login_screen.dart';

import 'cart_screen.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  ProductScreen(this.product);

  @override
  State<ProductScreen> createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;

  String? size;

  int _currentIndex = 0; // Variável para controlar a página atual do carrossel

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? 'Sem Título'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: CarouselSlider(
              items:
                  product.images!.map((url) {
                    return Container(
                      width:
                          double.infinity, // Faz a imagem ocupar toda a largura
                      height:
                          300, //
                      child: Image.network(
                        url,
                        fit:
                            BoxFit
                                .cover, // Faz a imagem cobrir o espaço sem distorcer
                      ),
                    );
                  }).toList(),
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                aspectRatio: 0.9,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index; // Atualiza o índice da página atual
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 10.0),
          // Indicador de página
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                product.images!.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentIndex == index
                              ? primaryColor // Cor do indicador ativo
                              : Colors.grey, // Cor do indicador inativo
                    ),
                  );
                }).toList(),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.title!,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  'R\$ ${product.price!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Tamanho',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
                ),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5,
                    ),
                    children:
                        product.sizes!.map((s) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                size = s;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4.0),
                                ),
                                border: Border.all(
                                  color:
                                      s == size
                                          ? primaryColor
                                          : Colors.grey[500]!,
                                  width: 3.0,
                                ),
                              ),
                              width: 50.0,
                              alignment: Alignment.center,
                              child: Text(s),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 44.0,
                  child: ElevatedButton(
                    onPressed:
                        size != null
                            ? () {
                              if (UserModel.of(context).isLoggedIn()) {

                                CartProduct cartProduct = CartProduct();
                                cartProduct.size = size;
                                cartProduct.quantity = 1;
                                cartProduct.pid = product.id;
                                cartProduct.category = product.category;
                                cartProduct.productData = product;

                                CartModel.of(context).addCartItem(cartProduct);

                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => CartScreen()));
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              }
                            }
                            : null,
                    child: Text(UserModel.of(context).isLoggedIn() ?
                      'Adicionar ao carrinho' : 'Entre para comprar',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          size != null
                              ? MaterialStateProperty.all(primaryColor)
                              : MaterialStateProperty.all(Colors.grey[500]),
                      foregroundColor:
                          size != null
                              ? MaterialStateProperty.all(Colors.white)
                              : MaterialStateProperty.all(Colors.grey[600]),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Descrição',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                Text(product.description!, style: TextStyle(fontSize: 16.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

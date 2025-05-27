import 'package:flutter/material.dart';
import 'package:lojavirtual/widgets/cart_button.dart';

import '../abas/aba_locais.dart';
import '../abas/home_tab.dart';
import '../abas/pedidos_tab.dart';
import '../abas/products_tab.dart';

import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: IconThemeData(color: Colors.white), // Cor do ícone do Drawer
      ),
      child: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Scaffold(
            body: HomeTab(),
            drawer: CustomDrawer(_pageController),
            floatingActionButton: CartButton(),
          ),
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              title: Text('Produtos'),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            body: ProductsTab(),
            floatingActionButton: CartButton(),
          ),
          Scaffold(
            appBar: AppBar(title: Text('Lojas'), centerTitle: true),
            body: AbaLocais(),
            drawer: CustomDrawer(_pageController),
          ),
          Scaffold(
            appBar: AppBar(title: Text('Meus Pedidos'), centerTitle: true),
            body: PedidosTab(),
            drawer: CustomDrawer(_pageController),
          ),
        ],
      ),
    );
  }
}

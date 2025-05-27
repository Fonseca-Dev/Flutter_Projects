import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerente_loja/Blocos/bloco_pedido12.dart';
import 'package:gerente_loja/Blocos/bloco_usuario7.dart';
import 'package:gerente_loja/Tabs/tab_produtos13.dart';
import 'package:gerente_loja/Tabs/tab_usuarios6.dart';

import '../Tabs/tab_pedidos9.dart';
import '../Widgets/dialog_editar_categoria22.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  PageController? _controladorPagina;
  int _pagina = 0;

  BlocoUsuario? _blocoUsuario;
  BlocoPedido? _blocoPedidos;

  @override
  void initState() {
    super.initState();

    _controladorPagina = PageController();
    _blocoUsuario = BlocoUsuario();
    _blocoPedidos = BlocoPedido();
  }

  @override
  void dispose() {
    _controladorPagina!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [Bloc((i) => BlocoUsuario()), Bloc((i) => BlocoPedido())],
      dependencies: [],
      child: Builder(
        builder: (context) {
          final blocoPedido =
              BlocProvider.getBloc<BlocoPedido>(); // pega a instância injetada

          return Scaffold(
            backgroundColor: Colors.grey.shade800,
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.pinkAccent),
              child: BottomNavigationBar(
                onTap: (p) {
                  _controladorPagina!.animateToPage(
                    p,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white54,
                currentIndex: _pagina,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Clientes',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart),
                    label: 'Pedidos',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: 'Produtos',
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: PageView(
                controller: _controladorPagina,
                onPageChanged: (page) {
                  setState(() {
                    _pagina = page;
                  });
                },
                children: [TabUsuarios(), TabPedidos(), TabProdutos()],
              ),
            ),
            floatingActionButton: _construtorFloating(
              blocoPedido,
            ), // passa o bloco correto
          );
        },
      ),
    );
  }

  Widget? _construtorFloating(BlocoPedido blocoPedido) {
    switch (_pagina) {
      case 0:
        return null;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
              child: Icon(Icons.arrow_downward, color: Colors.pinkAccent),
              backgroundColor: Colors.white,
              label: 'Concluídos Abaixo',
              labelStyle: TextStyle(fontSize: 14),
              onTap: () {
                blocoPedido.definirCriterioPedido(
                  CriterioOrdenacao.CONCLUIDOS_ULTIMO,
                );
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.arrow_upward, color: Colors.pinkAccent),
              backgroundColor: Colors.white,
              label: 'Concluídos Acima',
              labelStyle: TextStyle(fontSize: 14),
              onTap: () {
                blocoPedido.definirCriterioPedido(
                  CriterioOrdenacao.CONCLUIDOS_PRIMEIRO,
                );
              },
            ),
          ],
        );
      case 2:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => DialogEditarCategoria(),
            );
          },
        );
    }
    return null;
  }
}

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/Blocos/bloco_pedido12.dart';

import '../Widgets/pedido_tile10.dart';

class TabPedidos extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final _blocoPedidos = BlocProvider.getBloc<BlocoPedido>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
        stream: _blocoPedidos.pedidosOut,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
              ),
            );
          else if (snapshot.data!.length == 0)
            return Center(
              child: Text(
                'Nenhum pedido encontrado!',
                style: TextStyle(color: Colors.pinkAccent),
              ),
            );

          return ListView.builder(
            itemBuilder: (context, index) {
              return PedidoTile(snapshot.data![index]);
            },
            itemCount: snapshot.data!.length,
          );
        },
      ),
    );
  }
}

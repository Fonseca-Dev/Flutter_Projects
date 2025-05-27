import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UsuarioTile extends StatelessWidget {
  final Map<String, dynamic> usuario;

  UsuarioTile(this.usuario);

  @override
  Widget build(BuildContext context) {
    if (usuario.containsKey('gasto'))
      return ListTile(
        title: Text(usuario['name'], style: TextStyle(color: Colors.white)),
        subtitle: Text(usuario['email'], style: TextStyle(color: Colors.white)),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Pedidos: ${usuario['pedidos']}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Gasto: R\$ ${usuario['gasto'].toStringAsFixed(2)}',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    else
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            height: 20,
            child: Shimmer.fromColors(
              child: Container(
                color: Colors.white.withAlpha(50),
                margin: EdgeInsets.symmetric(vertical: 4),
              ),
              baseColor: Colors.white,
              highlightColor: Colors.grey,
            ),
          ),
          SizedBox(
            width: 50,
            height: 20,
            child: Shimmer.fromColors(
              child: Container(
                color: Colors.white.withAlpha(50),
                margin: EdgeInsets.symmetric(vertical: 4),
              ),
              baseColor: Colors.white,
              highlightColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

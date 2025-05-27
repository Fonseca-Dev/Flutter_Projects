import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_model.dart';

import '../screens/login_screen.dart';
import '../tiles/cartao_pedido.dart';

class PedidosTab extends StatelessWidget {
  const PedidosTab({super.key});

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser!.uid;

      return FutureBuilder<QuerySnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection('orders')
                .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          else {
            return ListView(
              children:
                  snapshot.data!.docs.map((doc) => CartaoPedido(doc.id)).toList().reversed.toList(),
            );
          }
        },
      );
    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.view_list,
              size: 80.0,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 16.0),
            Text(
              'Faça o login para acompanhar!',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text('Entrar', style: TextStyle(fontSize: 18.0)),
            ),
          ],
        ),
      );
    }
  }
}

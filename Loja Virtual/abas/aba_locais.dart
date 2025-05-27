import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../tiles/cartao_local.dart';

class AbaLocais extends StatelessWidget {
  const AbaLocais({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('locais').get(),
        builder: (context, snapshot){
          if(!snapshot.hasData || snapshot.data == null)
            return Center(
              child: CircularProgressIndicator(),
            );

          final docs = snapshot.data!.docs; // Agora garantimos que não é nulo

          return ListView(
              children: docs.map((doc) => CartaoLocal(doc)).toList(),
            );
        }
    );
  }
}

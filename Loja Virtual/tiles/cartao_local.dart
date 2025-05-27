import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CartaoLocal extends StatelessWidget {
  final DocumentSnapshot dados;

  CartaoLocal(this.dados);

  @override
  Widget build(BuildContext context) {
    final data = dados.data() as Map<String, dynamic>?; // Conversão segura
    if (data == null) {
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text("Erro ao carregar dados do local")),
        ),
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 150.0,
            child: Image.network(
              data['imagem'] ?? '', // Se for nulo, usa uma string vazia,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['titulo'] ?? 'Título indisponível',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                Text(
                  data['endereco'] ?? 'Endereço indisponível',
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: (){
                  launch('https://www.google.com/maps/search/?api=1&query=${data['latitude']},'
                      '${data['longitude']}');
                },
                child: Text(
                  'Ver no Mapa',
                  style: TextStyle(color: Colors.blue),
                ),
                style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero)),
              ),
              TextButton(
                onPressed: (){
                  launch('tel:${data['telefone']}');
                },
                child: Text(
                  'Ligar',
                  style: TextStyle(color: Colors.blue),
                ),
                style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

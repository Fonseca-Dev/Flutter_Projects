import 'package:flutter/material.dart';
import 'package:gerente_loja/Telas/tela_login1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:gerente_loja/Blocos/bloco_pedido12.dart';
import 'package:gerente_loja/Blocos/bloco_usuario7.dart';
import 'package:gerente_loja/Telas/tela_principal5.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Necessário para usar Firebase.initializeApp
  await Firebase.initializeApp(); // Inicializa o Firebase
  runApp(
    BlocProvider(
      blocs: [
        Bloc((i) => BlocoUsuario(), singleton: true),
        Bloc((i) => BlocoPedido(), singleton: true),
      ],
      dependencies: [],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.pinkAccent),
      debugShowCheckedModeBanner: false,
      home: TelaLogin(),
    );
  }
}

import 'package:chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before anything else
  await Firebase.initializeApp();

  // Now you can access Firebase Firestore
  // FirebaseFirestore.instance.collection('col').snapshots().listen((querySnapshot) {
  //   querySnapshot.docs.forEach((documentSnapshot) {
  //     print(documentSnapshot.data());  // Access document data here
  //   });
  // });

  FirebaseFirestore.instance.collection('col').doc('doc2').snapshots().listen((dado){
    print(dado.data());
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(color: Colors.blue)
      ),
      home: ChatScreen(),
    );
  }
}

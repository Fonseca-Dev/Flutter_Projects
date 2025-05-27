import 'dart:io';

import 'package:chat/text_composer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isloading = false;

  User? _currentUser;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  Future<User?> _getUser() async {
    if (_currentUser != null) return _currentUser;

    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      // Handle the case where sign-in might have failed or the user canceled
      if (googleSignInAccount == null) {
        return null;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final UserCredential authResults =
      await FirebaseAuth.instance.signInWithCredential(credential);

      final User user = authResults.user!;

      return user;
    } catch (error) {
      return null;
    }
  }


  void _sendMessage({String? text, XFile? imgFile}) async {
    final User? user = await _getUser();

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Não foi possível fazer o login. Tente novamente!'),
        backgroundColor: Colors.red,
      ));
    }

    Map<String, dynamic> data = {
      'uid': user!.uid,
      'senderName': user.displayName,
      'senderPhotoUrl': user.photoURL,
      'time': Timestamp.now(),
    };

    if (imgFile != null) {
      File file = File(imgFile.path);

      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(user.uid + DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(file);

      setState(() {
        _isloading = true;
      });

      TaskSnapshot taskSnapshot = await task;
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imgUrl'] = url;

      setState(() {
        _isloading = false;
      });
    }

    if (text != null) data['text'] = text;

    await Firebase.initializeApp();
    FirebaseFirestore.instance.collection('messages').add(data);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(
            _currentUser != null ? 'Olá, ${_currentUser!.displayName}' : 'Chat App'
          ),
          centerTitle: true,
          elevation: 0.0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          _currentUser != null ? IconButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
              googleSignIn.signOut();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Você saiu com sucesso!'),
              ));
            },
            icon: Icon(Icons.exit_to_app),
          )
        : Container()],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
              FirebaseFirestore.instance.collection('messages').orderBy('time').snapshots(),
              builder: (context, snapshot) {
                // Add a null check for snapshot.data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text('No messages found.'));
                }

                List<DocumentSnapshot> documents =
                snapshot.data!.docs.reversed.toList(); // Safe access
                return ListView.builder(
                  itemCount: documents.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    var data = documents[index].data() as Map<String, dynamic>;
                    return ChatMessage(
                        data,
                        data['uid'] == _currentUser?.uid
                    );
                  },
                );
              },
            ),
          ),
          _isloading ? LinearProgressIndicator() : Container(),
          TextComposer(_sendMessage),
        ],
      ),
    );
  }
}

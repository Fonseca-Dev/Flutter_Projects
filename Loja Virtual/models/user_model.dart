import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model{

  FirebaseAuth _auth = FirebaseAuth.instance;

  User? firebaseUser;

  Map<String, dynamic> userData = {};

  bool isLoading = false;
  
  static UserModel of(BuildContext context) => ScopedModel.of<UserModel>(context);


  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  void signUp({required Map<String, dynamic> userData, required String pass, required VoidCallback onSuccess, required VoidCallback onFail}){
    isLoading =true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
        email: userData ['email'],
        password: pass
    ).then((userCredential) async{
      firebaseUser = userCredential.user;

      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){
      onFail();
      isLoading = false;

    });

  }

  void singIn({required String email, required String pass, required VoidCallback onSuccess, required VoidCallback onFail}) async{
    isLoading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(email: email, password: pass).then(
            (userCredential) async{
              firebaseUser = userCredential.user;

              await _loadCurrentUser();

              onSuccess();
              isLoading = false;
              notifyListeners();

            }).catchError((e){
              onFail();
              isLoading = false;
              notifyListeners();
    });

  }

  void signOut() async{
    await _auth.signOut();

    userData = {};
    firebaseUser = null;

    notifyListeners();
  }

  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);

  }

  bool isLoggedIn(){
    return firebaseUser != null;
  }

  Future<Null> _saveUserData (Map<String, dynamic> userData) async{
    this.userData = userData;
    await FirebaseFirestore.instance.collection('users').doc(firebaseUser!.uid).set(userData);

  }

  Future<void> _loadCurrentUser() async {
    if (firebaseUser == null) {
      firebaseUser = _auth.currentUser;
    }

    if (firebaseUser != null) {
      if (userData.isEmpty) {
        DocumentSnapshot<Map<String, dynamic>> docUser = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(firebaseUser!.uid) // Use `!` to ensure non-null
            .get();

        userData = docUser.data() ?? {}; // Ensure it doesn't return null
      }
    }

    notifyListeners(); // Ensure UI updates after loading user data
  }


}
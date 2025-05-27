import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerente_loja/Validadores/validador_de_login4.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum EstadoLogin {PREENCHENDO, PROCESSANDO, SUCESSO, FALHA}

class BlocoLogin extends BlocBase with ValidadordeLogin{ //Esse with foi para trazer os validadores para dentro do bloc

  //Declaração de controladores
  final _controladoremail = BehaviorSubject<String>();
  final _controladorsenha = BehaviorSubject<String>();
  final _controladorestado = BehaviorSubject<EstadoLogin>(); //Controlador que informar o estado do login para a tela de Login

  Stream<String> get outEmail => _controladoremail.stream.transform(validadordeEmail); //Pegando o e-mail e trasnformando em um e-mail validado
  Stream<String> get outSenha => _controladorsenha.stream.transform(validadordeSenha); //Pegando a senha e tranformando em uma senha validada
  Stream<EstadoLogin> get outEstado => _controladorestado.stream;

  Stream<bool> get outSubmitValid => Rx.combineLatest2(
    outEmail,
    outSenha,
        (email, senha) => true, //se tiver dado nas duas (email e senha) retorna true
  );

  Function(String) get changeEmail => _controladoremail.sink.add; //Tudo que vier no chanceEmail é enviado ao _controladoremail.sink
  Function(String) get changeSenha => _controladorsenha.sink.add; //Tudo que vier no chanceSenha é enviado ao _controladorsenha.sink

  StreamSubscription? _streamSubscription;

  BlocoLogin(){
    _streamSubscription = FirebaseAuth.instance.authStateChanges().listen((user)async{
      if(user != null){
        if(await verificaPrivelegios(user)){
          _controladorestado.add(EstadoLogin.SUCESSO);
        } else {
          FirebaseAuth.instance.signOut();
          _controladorestado.add(EstadoLogin.FALHA);
        }
      } else {
        _controladorestado.add(EstadoLogin.PREENCHENDO);
      }
    });
  }

  void submit(){
    final email = _controladoremail.value;
    final senha = _controladorsenha.value;

    _controladorestado.add(EstadoLogin.PROCESSANDO); //Informando a tela de login que estamos processando os dados de logine senha

    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: senha).catchError((e){
      _controladorestado.add(EstadoLogin.FALHA);
      return Future<UserCredential>.value(); // ou Future<UserCredential>.value(null);
    });//Função que retorna o usuário logado ou erro
  }

  Future<bool> verificaPrivelegios(User user) async{
    return await FirebaseFirestore.instance.collection('admins').doc(user.uid).get(). //Pegando um documento cujo o nome é o uid
    then((doc){
      if(doc.data() != null){ //Caso o usuário tiver o uid (admin) retorna true
        return true;
      } else {
        return false;
      }
    }).catchError((e){
      return false;
    });

  }

  @override
  void dispose() {
    _controladoremail.close();
    _controladorsenha.close();
    _controladorestado.close();

    _streamSubscription!.cancel();
  }
}

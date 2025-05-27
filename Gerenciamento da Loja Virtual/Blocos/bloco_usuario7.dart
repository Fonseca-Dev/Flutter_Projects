import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class BlocoUsuario extends BlocBase {

  final _controladorusuarios = BehaviorSubject<List>();

  Stream<List> get outUsuarios => _controladorusuarios.stream;

  Map<String, Map<String, dynamic>> _usuarios = {};

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BlocoUsuario(){
    _addUsuariosListener();
  }

  void onChangedSearch (String search){
    if(search.trim().isEmpty){
      _controladorusuarios.add(_usuarios.values.toList());
    }
    else {
      _controladorusuarios.add(_filtrar(search.trim()));
    }
  }

  List<Map<String, dynamic>> _filtrar(String search){
    List<Map<String, dynamic>> usuariosFiltrados = List.from(_usuarios.values.toList());
    usuariosFiltrados.retainWhere((usuario){
      return usuario['name'].toUpperCase().contains(search.toUpperCase());
    });
    return usuariosFiltrados;
  }

  void _addUsuariosListener(){
    _firestore.collection('users').snapshots().listen((snapshot){
      snapshot.docChanges.forEach((change){
        String uid = change.doc.id;

        switch(change.type){
          case DocumentChangeType.added:
            _usuarios[uid] = change.doc.data()!;
            _contabilizaGastosUsuario(uid);
            break;
          case DocumentChangeType.modified:
            _usuarios[uid]!.addAll(change.doc.data()!);
            _controladorusuarios.add(_usuarios.values.toList());
            break;
          case DocumentChangeType.removed:
            _usuarios.remove(uid);
            _calcelarContabilizaGastosUsuario(uid);
            _controladorusuarios.add(_usuarios.values.toList());
            break;
        }
      });
    });
  }

  void _contabilizaGastosUsuario(String uid){
    _usuarios[uid]!['subscription'] = _firestore.collection('users').doc(uid).collection('orders').snapshots().listen((pedidos) async{ //Obtendo os pedidos do usuário pelo uid dele

      int numeroPedidos = pedidos.docs.length; //Contabilizando a qtde de pedidos

      double gasto = 0.0;

      for(DocumentSnapshot d in pedidos.docs){
       DocumentSnapshot pedido = await _firestore.collection('orders').doc(d.id).get();

       if(pedido.data() == null) continue;

       gasto += (pedido.data() as Map<String, dynamic>)['totalPrice'];
      }

      _usuarios[uid]!.addAll({'gasto': gasto, 'pedidos': numeroPedidos});

      _controladorusuarios.add(_usuarios.values.toList());

    });
  }

  Map<String, dynamic> carregarUsuario (String uid){ //Pega o usuário
    return _usuarios[uid]!; // Retorna os dados dele
  }

  void _calcelarContabilizaGastosUsuario(String uid){
    _usuarios[uid]!['subscription'].cancel();
  }

  @override
  void dispose() {
    _controladorusuarios.close();
  }
}
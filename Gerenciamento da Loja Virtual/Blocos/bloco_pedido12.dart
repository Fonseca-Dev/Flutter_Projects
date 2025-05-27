import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum CriterioOrdenacao {CONCLUIDOS_PRIMEIRO, CONCLUIDOS_ULTIMO}

class BlocoPedido extends BlocBase {

  final _controladorPedidos = BehaviorSubject<List>();

  Stream<List> get pedidosOut => _controladorPedidos.stream;

  List<DocumentSnapshot> _pedidos = [];

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CriterioOrdenacao? _criterio;

  BlocoPedido(){
    _addPedidosListener();
  }

  void _addPedidosListener(){
    _firestore.collection('orders').snapshots().listen((snapshot){
      snapshot.docChanges.forEach((change){
        String oid = change.doc.id;

        switch(change.type){
          case DocumentChangeType.added:
            _pedidos.add(change.doc);
            break;
          case DocumentChangeType.modified:
            _pedidos.removeWhere((pedido) => pedido.id == oid);
            _pedidos.add(change.doc);
            break;
          case DocumentChangeType.removed:
            _pedidos.removeWhere((pedido) => pedido.id == oid);
            break;
        }
      });

      _ordernar();

    });
  }

  void definirCriterioPedido(CriterioOrdenacao criterio){
    _criterio = criterio;
    _ordernar();
  }

  void _ordernar() {
    if (_criterio == null) {
      _controladorPedidos.add(_pedidos); // sem ordenação
      return;
    }
    switch (_criterio!) {
      case CriterioOrdenacao.CONCLUIDOS_PRIMEIRO:
        _pedidos.sort((a, b) {
          int statusA = (a.data() as Map<String, dynamic>)['status'];
          int statusB = (b.data() as Map<String, dynamic>)['status'];

          if (statusA < statusB) return 1;
          else if (statusA > statusB) return -1;
          else return 0;
        });
        break;

      case CriterioOrdenacao.CONCLUIDOS_ULTIMO:
        _pedidos.sort((a, b) {
          int statusA = (a.data() as Map<String, dynamic>)['status'];
          int statusB = (b.data() as Map<String, dynamic>)['status'];

          if (statusA > statusB) return 1;
          else if (statusA < statusB) return -1;
          else return 0;
        });
        break;
    }

    _controladorPedidos.add(_pedidos);
  }


  @override
  void dispose() {

    _controladorPedidos.close();
  }
}
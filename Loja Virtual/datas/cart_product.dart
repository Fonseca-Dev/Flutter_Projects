import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/datas/product_data.dart';

class CartProduct {

  String? cid;
  String? category;
  String? pid;
  int? quantity;
  String? size;
  ProductData? productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot snapshot){
    var data = snapshot.data() as Map<String, dynamic>;

    cid = snapshot.id;
    category = data['category'];
    pid = data['pid'];
    quantity = data['quantity'];
    size = data['size'];
  }

  Map<String, dynamic> toMap() {
    return{
      'category': category,
      'pid':pid,
      'quantity':quantity,
      'size':size,
      'products':productData!.toResumedMap()
    };
  }


}
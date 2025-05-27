import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;

  List<CartProduct> products = [];

  String? couponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  CartModel(this.user) {
    if (user.isLoggedIn()) _loadCarItems();
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .add(cartProduct.toMap())
        .then((doc) {
          cartProduct.cid = doc.id;
        });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .delete();
    products.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    if (cartProduct.quantity != null && cartProduct.quantity! > 0) {
      cartProduct.quantity = cartProduct.quantity! - 1;
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.firebaseUser!.uid)
          .collection('cart')
          .doc(cartProduct.cid)
          .update(cartProduct.toMap());
      notifyListeners(); // Atualiza a UI após a mudança
    }
  }

  void incProduct(CartProduct cartProduct) {
    if (cartProduct.quantity != null && cartProduct.quantity! > 0) {
      cartProduct.quantity = cartProduct.quantity! + 1;
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.firebaseUser!.uid)
          .collection('cart')
          .doc(cartProduct.cid)
          .update(cartProduct.toMap());
      notifyListeners(); // Atualiza a UI após a mudança
    }
  }

  void setCoupon(String? couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices(){
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null)
        price += (c.quantity ?? 0) * (c.productData?.price ?? 0.0);
    }
    return price;
  }
  double getDiscount() {
    return getProductsPrice() * discountPercentage/100;
  }
  double getShipPrice() {
    return 9.99;
  }
  
  Future<String> finishOrder() async{
    if(products.length == 0) return '';
    
    isLoading = true;
    notifyListeners();
    
    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();
    
    DocumentReference refOrder = await FirebaseFirestore.instance.collection('orders').add({
      'clientId': user.firebaseUser!.uid,
      'products': products.map((cartProduct)=>cartProduct.toMap()).toList(),
      'shipPrice':shipPrice,
      'productsPrice': productsPrice,
      'discount': discount,
      'totalPrice': productsPrice - discount + shipPrice,
      'status': 1
    });
    
    await FirebaseFirestore.instance.collection('users').doc(user.firebaseUser!.uid)
    .collection('orders').doc(refOrder.id).set({
      'orderId':refOrder.id
    });

    QuerySnapshot query = await FirebaseFirestore.instance.collection('users').doc(user.firebaseUser!.uid)
    .collection('cart').get();

    for(DocumentSnapshot doc in query.docs){
      doc.reference.delete();
    }

    products.clear();
    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.id;
  }
  

  void _loadCarItems() async {
    QuerySnapshot query =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.firebaseUser!.uid)
            .collection('cart')
            .get();
    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }
}

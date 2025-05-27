import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  // Declarando os campos
  String? category;
  String? id;
  String? title;
  String? description;
  double? price;
  List<dynamic>? images;
  List<dynamic>? sizes;

  // Construtor nomeado que cria um objeto a partir de um DocumentSnapshot
  ProductData.fromDocument(DocumentSnapshot snapshot) {
    // Ajustado para o novo acesso aos dados do Firestore
    var data = snapshot.data() as Map<String, dynamic>;

    id = snapshot.id;
    category = data['category'] ?? '';
    title = data['title'] ?? '';
    description = data['description'] ?? '';
    price = (data['price'] ?? 0).toDouble();
    images = List<String>.from(data['images'] ?? []);
    sizes = List<String>.from(data['sizes'] ?? []);
  }
  Map<String, dynamic> toResumedMap(){
    return{
      'title':title,
      'description':description,
      'price':price
    };
  }

}

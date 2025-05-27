import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('products').get(),
      // .get() is necessary to retrieve the data
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          // Safely access the data and check if it's not null
          final data = snapshot.data?.docs ?? [];

          // Using ListTile.divideTiles with safe data access
          var dividedTiles =
              ListTile.divideTiles(
                tiles:
                    data.map((doc) {
                      return CategoryTile(doc);
                    }).toList(),
                color: Colors.grey[500],
              ).toList();

          return ListView(
            children: dividedTiles, // Use the divided tiles
          );
        }
      },
    );
  }
}

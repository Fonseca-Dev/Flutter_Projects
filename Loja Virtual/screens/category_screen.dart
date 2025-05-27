import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/product_data.dart';

import '../tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          title: Text(
            (snapshot.data() as Map<String, dynamic>)['title'] ?? 'No Title',
          ),
          centerTitle: true,
          bottom: TabBar(
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4.0, color: Colors.white),
              insets: EdgeInsets.symmetric(
                horizontal: 110.0,
              ), // Aumente ou diminua para ajustar a largura
            ),
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.grid_on, color: Colors.white)),
              Tab(icon: Icon(Icons.list, color: Colors.white)),
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('products')
                  .doc(snapshot.id)
                  .collection('items')
                  .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    padding: EdgeInsets.all(4.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      ProductData data = ProductData.fromDocument(snapshot.data!.docs[index]);
                      data.category = this.snapshot.id;
                      return ProductTile('grid', data);
                    },
                  ),
                  ListView.builder(
                      padding: EdgeInsets.all(4.0),
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        ProductData data = ProductData.fromDocument(snapshot.data!.docs[index]);
                        data.category = this.snapshot.id;
                        return ProductTile('list', data);
                      }
                  )
                ],
              );
          },
        ),
      ),
    );
  }
}

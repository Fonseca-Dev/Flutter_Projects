import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/screens/category_screen.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    // Safely get the data, with null check
    var data = snapshot.data() as Map<String, dynamic>?;

    // Check if data is null before accessing its properties
    if (data == null) {
      return SizedBox.shrink(); // Return an empty widget if data is null
    }

    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(data["icon"] ?? ""), // Provide a fallback empty string if "icon" is null
      ),
      title: Text(data['title'] ?? "No Title"), // Provide a fallback title if "title" is null
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoryScreen(snapshot)));
      },
    );
  }
}

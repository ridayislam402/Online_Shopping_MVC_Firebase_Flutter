import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/pages/product_details_page.dart';
import 'package:online_shopping/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';

class SearchPage4 extends SearchDelegate {

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context));
  }

  @override
  Widget buildResults(BuildContext context) {
    final plist = Provider.of<ProductProvider>(context,listen: false);
    final pr=plist.filteredProductList;
    if (query != null && pr.contains(query.toUpperCase())) {
      return ListTile(
        title: Text(query),
        onTap: () {},
      );
    } else if (query == "") {
      return Text("");
    } else {
      return ListTile(
        title: Text("No results found"),
        onTap: () {},
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final plist = Provider.of<ProductProvider>(context,listen: false);
    return StreamBuilder(
        stream: Provider.of<ProductProvider>(context,listen: false).getProductByName(query.toUpperCase()),
        // FirebaseFirestore.instance.collection("Products").where("name", isGreaterThanOrEqualTo: inputText).snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: Text("Loading"),
            );
          }
          final plist = Provider.of<ProductProvider>(context,listen: false);
          final pr=plist.filteredProductList;
          return
            ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                var data = ProductModel.fromMap(document.data() as Map<String, dynamic>);
                return InkWell(
                    onTap: () => Navigator.pushNamed(context, ProductDetailsPage.routeName,arguments: data.id),
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(data.name),
                        leading: Image.network(data.imageUrl),
                        subtitle: Text(data.description!),

                      ),
                    ),
                  );
              }).toList(),
            );
        });
  }
}
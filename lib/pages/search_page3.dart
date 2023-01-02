import 'package:flutter/material.dart';
import 'package:online_shopping/providers/product_provider.dart';
import 'package:provider/provider.dart';

class SearchPage3 extends SearchDelegate {

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
    return ListView.builder(
        itemCount: plist.filteredProductList.length,
        itemBuilder: (context, index) {
        final product = plist.filteredProductList[index];
          return ListTile(
            title: Text(product.name),
            trailing: Icon(
              Icons.arrow_forward_ios,
            ),
            onTap: () {},
          );
        });
  }
}
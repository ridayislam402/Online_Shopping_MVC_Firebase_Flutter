import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:online_shopping/pages/login_page2.dart';
import 'package:online_shopping/pages/product_details_page.dart';
import 'package:online_shopping/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../providers/card_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName='/search2';

 //final ProductModel productModel;

 // const SearchScreen({Key? key, required this.productModel}) : super(key: key);


  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var inputText = "";
  @override
  Widget build(BuildContext context) {
  final productProvider = Provider.of<ProductProvider>(context,listen: false);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    inputText = val.toUpperCase();
                    print(inputText);
                  });
                },
              ),
              Expanded(
                child: Container(
                  child: StreamBuilder(
                      stream: Provider.of<ProductProvider>(context,listen: false).getProductByName(inputText),
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

                            Map<String, dynamic> data = //ProductModel.fromMap(snapshot.data!.data()!);
                            document.data() as Map<String, dynamic>;
                     //   final  product = ProductModel.fromMap(document.data()!);

                            return

                             InkWell(
                               onTap: () => Navigator.pushNamed(context, ProductDetailsPage.routeName,arguments: data["id"]),
                               child: Card(
                                elevation: 5,
                                child: ListTile(
                                  title: Text(data['name']),
                                  leading: Image.network(data['imageUrl']),

                                ),
                            ),
                             );
                          }).toList(),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
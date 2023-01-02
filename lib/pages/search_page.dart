import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/utils/constants.dart';
import 'package:provider/provider.dart';

import '../customwidgets/product_item.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';

class SearchPage extends StatefulWidget {
  static const String routeName='/search';
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    String searchproduct='';
    return Scaffold(
    //  backgroundColor: appBarColor,
      body: Consumer<ProductProvider>(
          builder: (context, provider, _) => provider.productList.isEmpty
              ? const Center(
            child: Text('No item found'),
          )
              : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream//: (searchproduct != '')?FirebaseFirestore.instance.collection("Products").where('name',isEqualTo: searchproduct).snapshots()
          :FirebaseFirestore.instance.collection("Products").where('name',isEqualTo: searchproduct).snapshots(),
            builder: (context, snapshot) {
      if (snapshot.hasData) {
        final product = snapshot.data!.docs;//ProductModel.fromMap(snapshot.data!.docs);
       // provider.getPurchaseByProduct(pid);
        return Column(
          children: [
            SizedBox(height: 30,),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchproduct = value;
                  print(searchproduct);
                },);

              },
            ),
            Expanded(
              child: ListView.builder(
                //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65),
                  itemCount: product.length,
                  itemBuilder: (context, index) {
                  final productl = product[index];
                  return Text('product name ${productl['name']}');
                },),
            ),
          ],
        );

      }
      return const Center(
        child: CircularProgressIndicator(),
      );
            }

              )
      ),
    );
  }
}
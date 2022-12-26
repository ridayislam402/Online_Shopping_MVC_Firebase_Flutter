import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/category_model.dart';
import '../models/date_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';

class ProductProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  //List<PurchaseModel> purchaseListOfSpecificProduct = [];
  List<ProductModel> productList = [];
  List<ProductModel> filteredProductList = [];



  getAllCategories() {
    DbHelper.getAllCategories().listen((event) {
      categoryList = List.generate(event.docs.length, (index) =>
          CategoryModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  getAllProduct() {
    DbHelper.getAllProduct().listen((event) {
      productList = List.generate(event.docs.length, (index) =>
          ProductModel.fromMap(event.docs[index].data()));
      filteredProductList=productList;
      notifyListeners();
    });
  }


  Future<String> uploadImage(String path) async {
    final imageName = DateTime
        .now()
        .microsecondsSinceEpoch
        .toString();
    final photoRef = FirebaseStorage.instance.ref().child('Picture/$imageName');
    final uploadTask = photoRef.putFile(File(path));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }


  CategoryModel getCategoryModelByCatName(String name){
    return categoryList.firstWhere((element) => element.name == name);
  }

  List<String> getCategoryFilterList() {
    return <String>[
      'Featured',
      'All',
      ... categoryList.map((e) => e.name!).toList(),
    ];
  }

  filterProductsByCategory(String category) {
    if(category == 'Featured') {
      filteredProductList = getFeaturedProducts();
    } else if(category == 'All') {
      filteredProductList =  productList;
    } else {
      filteredProductList = productList.where((element) => element.category == category).toList();
    }
    notifyListeners();
  }

  List<ProductModel> getFeaturedProducts() {
    return productList.where((element) => element.featured == true).toList();
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cart_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../models/user_model.dart';

class DbHelper {
  static const String collectionAdmin = 'Admins';
  static const String collectionCategory = 'Categories';
  static const String collectionProduct = 'Products';
  static const String collectionPurchase = 'Purchase';
  static const String collectionUser = 'User';
  static const String collectionOrder = 'Order';
  static const String collectionCart = 'Cart';
  static const String collectionOrderDetails = 'OrderDetails';
  static const String collectionOrderSettings = 'Settings';
  static const String documentOrderConstant = 'OrderConstant';

  static FirebaseFirestore _db = FirebaseFirestore.instance;



  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories(){
    return _db.collection(collectionCategory).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProduct(){
    return _db.collection(collectionProduct).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCartItemsByUser(String uid) =>
      _db.collection(collectionUser)
          .doc(uid)
          .collection(collectionCart).snapshots();



  static Future<void> addUser(UserModel userModel){
    return _db.collection(collectionUser).doc(userModel.uid).set(userModel.toMap());
  }

  static Future<void> addCartItem(CartModel cartModel, String uid){
    return _db.collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.productId)
        .set(cartModel.toMap());
  }

  static Future<void> removeCartItem(String pid, String uid){
    return _db.collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(pid)
        .delete();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(String id) =>
      _db.collection(collectionProduct).doc(id).snapshots();


  static Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() =>
      _db.collection(collectionOrderSettings).doc(documentOrderConstant).snapshots();
}
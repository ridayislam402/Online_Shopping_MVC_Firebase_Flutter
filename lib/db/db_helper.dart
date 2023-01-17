

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_shopping/models/checkout_model.dart';
import 'package:online_shopping/models/user_model_only_nm.dart';
import 'package:online_shopping/utils/constants.dart';

import '../models/cart_model.dart';
import '../models/category_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../models/rating_model.dart';
import '../models/user_model.dart';

class DbHelper {
  static const String collectionAdmin = 'Admins';
  static const String collectionCategory = 'Categories';
  static const String collectionProduct = 'Products';
  static const String collectionPurchase = 'Purchase';
  static const String collectionUser = 'User';
  static const String collectionOrder = 'Order';
  static const String collectionCart = 'Cart';
  static const String collectionCheckout = 'Checkout';
  static const String collectionOrderDetails = 'OrderDetails';
  static const String collectionOrderSettings = 'Settings';
  static const String documentOrderConstant = 'OrderConstant';
  static const String collectionRating = 'Rating';

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

  //checkout
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCheckoutItemsByUser(String uid) =>
      _db.collection(collectionUser)
          .doc(uid)
          .collection(collectionCheckout).snapshots();



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

  //checkout
  static Future<void> addCheckoutItem(CheckoutModel checkoutModel, String uid){
    return _db.collection(collectionUser)
        .doc(uid)
        .collection(collectionCheckout)
        .doc(checkoutModel.productId)
        .set(checkoutModel.toMap());
  }

  static Future<void> removeCartItem(String pid, String uid){
    return _db.collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(pid)
        .delete();
  }

  //cancel Order
  static Future<void> cancelOrder(String orderid){
    return _db.collection(collectionOrder)
        .doc(orderid)
        .update({'orderStatus': OrderStatus.cancelled});
  }

  // checkout
  static Future<void> removeCheckoutItem(String pid, String uid){
    return _db.collection(collectionUser)
        .doc(uid)
        .collection(collectionCheckout)
        .doc(pid)
        .delete();
  }

  static Future<void> clearCartItems(String uid, List<CartModel> cartList){
    final wb = _db.batch();
    for(var cart in cartList) {
      final doc = _db.collection(collectionUser)
          .doc(uid)
          .collection(collectionCart)
          .doc(cart.productId);
      wb.delete(doc);
    }
    return wb.commit();
  }

  static Future<void> clearCheckoutItems(String uid, List<CheckoutModel> cartList){
    final wb = _db.batch();
    for(var cart in cartList) {
      final doc = _db.collection(collectionUser)
          .doc(uid)
          .collection(collectionCheckout)
          .doc(cart.productId);
      wb.delete(doc);
    }
    return wb.commit();
  }

  static Future<void> updateCartItemQuantity(num quantity, String pid, String uid){
    return _db.collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(pid)
        .update({cartProductQuantity : quantity});
  }

  static Future<void> updateCheckoutItemQuantity(num quantity, String pid, String uid){
    return _db.collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(pid)
        .update({checkoutProductQuantity : quantity});
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(String id) =>
      _db.collection(collectionProduct).doc(id).snapshots();


  static Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() =>
      _db.collection(collectionOrderSettings).doc(documentOrderConstant).snapshots();

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserOnce(String uid) =>
      _db.collection(collectionUser).doc(uid).get();

  static Future<void> addOrder(OrderModel orderModel, List<CheckoutModel> cartList, UserModel_only_namemobile nameMobile) async {
    final wb = _db.batch();
    final orderDoc = _db.collection(collectionOrder).doc();
    orderModel.orderId = orderDoc.id;
    wb.set(orderDoc, orderModel.toMap());
    final userDoc = _db.collection(collectionUser).doc(orderModel.userId);
    wb.update(userDoc, {'address' : orderModel.deliveryAddress.toMap()});
    wb.update(userDoc, {'name' : nameMobile.name,
                         'mobile' : nameMobile.mobile});
    for(var cartM in cartList) {
      final detailsDoc = orderDoc.collection(collectionOrderDetails).doc(cartM.productId);
      wb.set(detailsDoc, cartM.toMap());
      final newStock = cartM.stock - cartM.quantity;
      final proDoc = _db.collection(collectionProduct).doc(cartM.productId);
      wb.update(proDoc, {productStock : newStock});
      final snapshot = await _db.collection(collectionCategory)
          .where(categoryName, isEqualTo: cartM.category).get();
      final catDoc = snapshot.docs.first.reference;
      final previousCount = snapshot.docs.first.data()[categoryProductCount];
      wb.update(catDoc, {categoryProductCount : previousCount - cartM.quantity});
    }
    return wb.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrders(String uid) {
    return _db.collection(collectionOrder)
        .where(orderUserIDKey, isEqualTo: uid)
        .snapshots();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getOrderDetails(String orderId) {
    return _db.collection(collectionOrder)
        .doc(orderId)
        .collection(collectionOrderDetails)
        .get();
  }

  static Future<void> rateProduct(RatingModel ratingModel) {
    return _db.collection(collectionProduct)
        .doc(ratingModel.productId)
        .collection(collectionRating)
        .doc(ratingModel.userId)
        .set(ratingModel.toMap());
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllRatingsByProduct(String productId) =>
      _db.collection(collectionProduct)
          .doc(productId)
          .collection(collectionRating)
          .get();

  static Future<void> updateProduct(String id, Map<String, dynamic> map) {
    return _db.collection(collectionProduct).doc(id)
        .update(map);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getProductByName(String name) =>
      _db.collection(collectionProduct).where("name",isGreaterThanOrEqualTo: name).snapshots();
}
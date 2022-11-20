import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../db/db_helper.dart';
import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier{
  List<CartModel> cartList = [];

  getAllCartItems() {
    DbHelper.getAllCartItemsByUser(AuthService.user!.uid).listen((snapshot) {
      cartList = List.generate(snapshot.docs.length, (index) => CartModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> addToCart(CartModel cartModel) {
    return DbHelper.addCartItem(cartModel, AuthService.user!.uid);
  }

  Future<void> removeFromCart(String productId) {
    return DbHelper.removeCartItem(productId, AuthService.user!.uid);
  }

  bool isInCart(String productId) {
    bool flag = false;
    for(var cart in cartList) {
      if(cart.productId == productId) {
        flag = true;
        break;
      }
    }
    return flag;
  }
}
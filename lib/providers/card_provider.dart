import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../db/db_helper.dart';
import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier{
  List<CartModel> cartList = [];
  int get totalItemsInCart => cartList.length;
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

  Future<void> clearCart() =>
      DbHelper.clearCartItems(AuthService.user!.uid, cartList);

  increaseQuantity(CartModel cartModel) async {
    DbHelper.updateCartItemQuantity(cartModel.quantity + 1, cartModel.productId!, AuthService.user!.uid);
  }

  decreaseQuantity(CartModel cartModel) async {
    if(cartModel.quantity > 1) {
      DbHelper.updateCartItemQuantity(cartModel.quantity - 1, cartModel.productId!, AuthService.user!.uid);
    }
  }
  num itemPriceWithQuantity(CartModel cartModel) =>
      cartModel.salePrice * cartModel.quantity;

  num getCartSubtotal() {
    num total = 0;
    for(var cartM in cartList) {
      total += cartM.salePrice * cartM.quantity;
    }
    return total;
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
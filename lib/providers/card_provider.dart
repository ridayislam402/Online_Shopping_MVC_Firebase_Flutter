import 'package:flutter/material.dart';
import 'package:online_shopping/models/checkout_model.dart';

import '../auth/auth_service.dart';
import '../db/db_helper.dart';
import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier{
  List<CartModel> cartList = [];
  List<CheckoutModel> checkout = [];
  int get totalItemsInCart => cartList.length;
  int get totalItemsInCheckout => checkout.length;
  getAllCartItems() {
    DbHelper.getAllCartItemsByUser(AuthService.user!.uid).listen((snapshot) {
      cartList = List.generate(snapshot.docs.length, (index) => CartModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
//checkout
  getAllCheckoutItems() {
    DbHelper.getAllCheckoutItemsByUser(AuthService.user!.uid).listen((snapshot) {
      checkout = List.generate(snapshot.docs.length, (index) => CheckoutModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> addToCart(CartModel cartModel) {
    return DbHelper.addCartItem(cartModel, AuthService.user!.uid);
  }
  //checkout
  Future<void> addToCheckout(CheckoutModel checkoutModel) {
    return DbHelper.addCheckoutItem(checkoutModel, AuthService.user!.uid);
  }

  Future<void> removeFromCart(String productId) {
    return DbHelper.removeCartItem(productId, AuthService.user!.uid);
  }



  //checkout
  Future<void> removeFromCheckout(String productId) {
    return DbHelper.removeCheckoutItem(productId, AuthService.user!.uid);
  }

  Future<void> clearCart() =>
      DbHelper.clearCartItems(AuthService.user!.uid, cartList);

  //Checkout
  Future<void> clearCheckout() =>
      DbHelper.clearCheckoutItems(AuthService.user!.uid, checkout);

  increaseQuantity(CartModel cartModel) async {
    DbHelper.updateCartItemQuantity(cartModel.quantity + 1, cartModel.productId!, AuthService.user!.uid);
  }

  //checkout
  /*increaseQuantity(CartModel cartModel) async {
    DbHelper.updateCartItemQuantity(cartModel.quantity + 1, cartModel.productId!, AuthService.user!.uid);
  }*/

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
  //checkout
  num getCheckoutSubtotal() {
    num total = 0;
    for(var cartM in checkout) {
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
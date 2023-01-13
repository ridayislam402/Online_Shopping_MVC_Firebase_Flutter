

import 'package:flutter/material.dart';
import 'package:online_shopping/models/checkout_model.dart';
import 'package:online_shopping/models/user_model_only_nm.dart';

import '../auth/auth_service.dart';
import '../db/db_helper.dart';
import '../models/cart_model.dart';
import '../models/expansion_item.dart';
import '../models/order_constants_model.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier{
  List<OrderModel> orderList = [];
  List<ExpansionItem> itemList = [];
  OrderConstantsModel orderConstantsModel = OrderConstantsModel();

  Future<void> getOrderConstants() async {
    DbHelper.getOrderConstants().listen((snapshot) {
      if(snapshot.exists) {
        orderConstantsModel = OrderConstantsModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  getOrderByUser() {
    DbHelper.getAllOrders(AuthService.user!.uid).listen((event) {
      orderList = List.generate(event.docs.length, (index) =>
          OrderModel.fromMap(event.docs[index].data()));
      _generateExpansionList();
      notifyListeners();
    });
  }

  void _generateExpansionList() async {
    List<ExpansionItem> tempList = [];
    for(final order in orderList) {
      final snapshot = await DbHelper.getOrderDetails(order.orderId!);
      final cartList = List.generate(snapshot.docs.length, (index) => CartModel.fromMap(snapshot.docs[index].data()));
      tempList.add(ExpansionItem(orderModel: order, cartList: cartList));
    }
    itemList = tempList;
    notifyListeners();
  }

  num getDiscountAmount(num subtotal) {
    return (subtotal * orderConstantsModel.discount) / 100;
  }

  num getVatAmount(num subtotal) {
    final priceAfterDiscount = subtotal - getDiscountAmount(subtotal);
    return (priceAfterDiscount * orderConstantsModel.vat) / 100;
  }

  num getGrandTotal(num subtotal) {
    return (subtotal - getDiscountAmount(subtotal))
        + getVatAmount(subtotal) + orderConstantsModel.deliveryCharge;
  }

  Future<void> addNewOrder(OrderModel orderModel, List<CheckoutModel> checkoutlist, UserModel_only_namemobile nameMobile) async {
    await DbHelper.addOrder(orderModel, checkoutlist, nameMobile);
    return DbHelper.clearCheckoutItems(orderModel.userId!, checkoutlist);
  }



}
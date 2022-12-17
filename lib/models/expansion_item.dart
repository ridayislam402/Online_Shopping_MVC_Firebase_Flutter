import 'package:online_shopping/models/order_model.dart';

import 'cart_model.dart';

class ExpansionItem {
  OrderModel orderModel;
  List<CartModel> cartList;
  bool isExpanded;

  ExpansionItem({
    required this.orderModel,
    required this.cartList,
    this.isExpanded = false,
  });
}

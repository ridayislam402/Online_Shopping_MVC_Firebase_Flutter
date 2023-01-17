import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class OrderPage extends StatefulWidget {
  static const String routeName = '/myorders';
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) {
          return provider.orderList.isEmpty ?
          const Center(child : Text('You have no orders')) :
          SingleChildScrollView(
            child: Container(
              child: buildPanel(provider),
            ),
          );
        } ,
      ),
    );
  }

  Widget buildPanel(OrderProvider provider) {
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          provider.itemList[panelIndex].isExpanded = !isExpanded;
        });
      },
      children: provider.itemList.map<ExpansionPanel>((item) {
        return ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(getFormattedDateTime(item.orderModel.orderDate.timestamp.toDate(), 'dd/MM/yyyy hh:mm:s a')),
              subtitle: Text(item.orderModel.orderStatus),
              trailing: Text('$currencySymbol${item.orderModel.grandTotal}'),
              leading: item.orderModel.orderStatus == OrderStatus.cancelled ? null:
              ElevatedButton(
                  onPressed: () {
                    showOrderCancelDialog(context: context, item: item, provider: provider);
                    // provider.cancelOrder(item.orderModel.orderId!);
                  }, child: Text('Cancel Order')),
            );
          },
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: item.cartList.length,
            itemBuilder: (context, index) {
              final cart = item.cartList[index];
              return ListTile(
                title: Text(cart.productName!),
                subtitle: Text('Quantity: ${cart.quantity}'),
                trailing: Text('$currencySymbol${cart.salePrice}'),

              );
            },
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

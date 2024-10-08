import 'package:flutter/material.dart';
import 'package:online_shopping/pages/checkout_page.dart';
import 'package:online_shopping/utils/helper_functions.dart';
import 'package:provider/provider.dart';

import '../customwidgets/cart_item.dart';
import '../providers/card_provider.dart';
import '../utils/constants.dart';

class CartPage extends StatelessWidget {
  static const String routeName='/cart';
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        title: Text('My Cart'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, provider, _) => IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Clear items',
              onPressed: () {
                showCartDialog(context: context, provider: provider,);
               // provider.clearCart();
              },
            ),
          )
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: provider.cartList.length,
                itemBuilder: (context, index) {
                  final cartM = provider.cartList[index];
                  return CartItem(
                    cartModel: cartM,
                    priceWithQuantity: provider.itemPriceWithQuantity(cartM),
                    onIncrease: () {
                      provider.increaseQuantity(cartM);
                    },
                    onDecrease: () {
                      provider.decreaseQuantity(cartM);
                    },
                    onDelete: () {
                      provider.removeFromCart(cartM.productId!);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                color: Colors.grey.shade300,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Subtotal: $currencySymbol${provider.getCheckoutSubtotal()}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      SizedBox(height: 50,
                        child: ElevatedButton(
                          onPressed:
                            provider.totalItemsInCheckout == 0 ?
                            null : () => Navigator.pushNamed(context, CheckoutPage.routeName),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appBarColor,
                            onPrimary: Colors.white
                          ),
                          child: const Text('Checkout'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}

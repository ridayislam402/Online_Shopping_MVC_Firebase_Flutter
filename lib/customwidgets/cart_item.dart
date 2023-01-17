
import 'package:flutter/material.dart';
import 'package:online_shopping/models/checkout_model.dart';
import 'package:online_shopping/providers/card_provider.dart';
import 'package:online_shopping/utils/helper_functions.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';
import '../utils/constants.dart';

class CartItem extends StatefulWidget {
  final CartModel cartModel;

  final num priceWithQuantity;
  final VoidCallback onIncrease, onDecrease, onDelete;
  const CartItem({
    Key? key,
    required this.cartModel,
    required this.priceWithQuantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
bool radio=false;
var value;
var idc=null;
bool _isVisible = true;
  @override
  Widget build(BuildContext context) {
   var cartP= Provider.of<CartProvider>(context,listen: false);
    Provider.of<CartProvider>(context,listen: false)
        .getAllCheckoutItems();
    final checkoutModel = CheckoutModel(
      productId: widget.cartModel.productId,
      productName: widget.cartModel.productName,
      salePrice: widget.cartModel.salePrice,
      imageUrl: widget.cartModel.imageUrl,
      stock: widget.cartModel.stock,
      category: widget.cartModel.category,
      quantity: widget.cartModel.quantity,
    );
    /*for(int i=0;i<cartP.checkout.length;i++){
      if(widget.cartModel.productId==checkoutModel.productId){
        idc=checkoutModel.productId;
      }
    }*/

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Row(
          children: [
            Radio(
              value: widget.cartModel.productId,
              groupValue: idc,
              toggleable: true,
              onChanged: (value) {
              setState(() {
                _isVisible=false;
                print('test check');
                value= widget.cartModel.productId;

                print('cart $value');

                if(idc == null){
                      cartP.addToCheckout(checkoutModel);
                      cartP.getAllCheckoutItems();
                  idc=checkoutModel.productId;
                  print('checkout $idc');
                  //idc=null;

                }else{
                  idc=null;
                  _isVisible=true;
                  Provider.of<CartProvider>(context,listen: false).removeFromCheckout(checkoutModel.productId!);
                }

              },);
              //idc=5;
              //Future.delayed(const Duration(seconds: 3), () => idc=5);

            },
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(widget.cartModel.imageUrl!),
                    ),
                    title: Text(widget.cartModel.productName!),
                    subtitle: Text('$currencySymbol${widget.cartModel.salePrice}'),
                    trailing: Text(
                      '$currencySymbol${widget.priceWithQuantity}',
                      style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                    child: Row(
                      children: [
                        Visibility(
                          visible: _isVisible,
                          child: IconButton(
                            icon: Icon(
                              Icons.remove_circle,
                              color: Theme.of(context).primaryColor,
                              size: 35,
                            ),
                            onPressed: widget.onDecrease,
                          ),
                        ),
                        Text(
                          '${widget.cartModel.quantity}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Visibility(
                          visible: _isVisible,
                          child: IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              color: Theme.of(context).primaryColor,
                              size: 35,
                            ),
                            onPressed: widget.onIncrease,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).errorColor,
                            size: 35,
                          ),
                          onPressed: () => showRemoveCartItemDialog(context: context,  provider: cartP, pid: widget.cartModel),
                          //widget.onDelete,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

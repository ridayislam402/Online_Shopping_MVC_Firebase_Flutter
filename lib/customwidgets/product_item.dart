import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:online_shopping/pages/login_page2.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../pages/product_details_page.dart';
import '../providers/card_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class ProductItem extends StatefulWidget {
  final ProductModel productModel;

  const ProductItem({Key? key, required this.productModel}) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.productModel.stock != 0) Navigator.pushNamed(
          context,
          ProductDetailsPage.routeName,
          arguments: widget.productModel.id,
        );
      },
      child: Card(
        color: Colors.greenAccent,
        elevation: 5,
        child: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: Key(widget.productModel.id.toString()),
                child: FadeInImage.assetNetwork(
                  placeholder: 'images/placeholder.png',
                  image: widget.productModel.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(8),
                color: appBarColor.withOpacity(0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productModel.name,
                      style:
                      const TextStyle(fontSize: 20, color: Colors.white70),
                    ),
                    Text(
                      '$currencySymbol${widget.productModel.salesPrice}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: widget.productModel.rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ignoreGestures: true,
                          itemSize: 15,
                          unratedColor: Colors.white,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (value) {

                          },
                        ),
                        const SizedBox(width: 10,),
                        Text(widget.productModel.rating.toStringAsFixed(1), style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              child:
              Consumer<CartProvider>(builder: (context, provider, child) {
                final isInCart = provider.isInCart(widget.productModel.id!);
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: appBarColor),
                  icon: Icon(
                    isInCart
                        ? Icons.remove_shopping_cart
                        : Icons.add_shopping_cart,
                    color: Colors.amberAccent,
                  ),
                  onPressed: () {
                    if(AuthService.user == null){
                      showbackDialog(context: context);
                      //Navigator.pushNamed(context, LoginPage2.routeName);
                    }else{
                      if (AuthService.user!.isAnonymous) {
                        showMsg(context, 'Sign In before you add items to Cart');
                        return;
                      }
                      if (isInCart) {
                        provider.removeFromCart(widget.productModel.id!);
                      } else {
                        final cartModel = CartModel(
                          productId: widget.productModel.id,
                          productName: widget.productModel.name,
                          salePrice: widget.productModel.salesPrice,
                          imageUrl: widget.productModel.imageUrl,
                          stock: widget.productModel.stock,
                          category: widget.productModel.category,
                        );
                        provider.addToCart(cartModel);
                      }
                    }

                  },
                  label: Text(isInCart ? 'Remove' : 'Add'),
                );
              }),
            ),
            if (widget.productModel.stock == 0)
              Container(
                alignment: Alignment.center,
                color: Colors.grey.withOpacity(0.5),
                child: const Text(
                  'Out of Stock',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

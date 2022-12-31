
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:online_shopping/auth/auth_service.dart';
import 'package:online_shopping/pages/login_page2.dart';
import 'package:online_shopping/providers/card_provider.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/product_details';

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  //const ProductDetailsPage({Key? key,ProductModel productModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double rating = 0.0;
    final pid = ModalRoute.of(context)!.settings.arguments as String;
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final cartprovider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: provider.getProductById(pid),
        builder: (context, snapshot) {

          if(snapshot.hasData) {
            final product = ProductModel.fromMap(snapshot.data!.data()!);
            final isInCart = cartprovider.isInCart(product.id!);
            return ListView(
              children: [
                FadeInImage.assetNetwork(
                  placeholder: 'images/placeholder.png',
                  image: product.imageUrl,
                  fadeInCurve: Curves.bounceInOut,
                  fadeInDuration: const Duration(seconds: 3),
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                ListTile(
                  title: Text(product.name, style: TextStyle(fontSize: 20,color: Colors.white)),
                ),
                ListTile(
                  title: Text('$currencySymbol${product.salesPrice}', style: TextStyle(fontSize: 30,color: Colors.white),),
                ),
                ListTile(
                  title: Text('Product Description', style: TextStyle(fontSize: 20,color: Colors.white),),
                  subtitle: Text(product.description ?? 'Not Available',style: TextStyle(color: Colors.white)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Card(
                    elevation: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Rate this Product', style: TextStyle(fontSize: 20),),
                          RatingBar.builder(
                            initialRating: rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: appBarColor,
                            ),
                            onRatingUpdate: (value) {
                              rating = value;
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appBarColor,
                            ),
                            onPressed: () async {
                              if(AuthService.user == null){
                                Navigator.pushNamed(context, LoginPage2.routeName);
                              }else{
                                EasyLoading.show(status: 'Please wait');
                                await provider.rateProduct(pid, rating);
                                showMsg(context, 'Thanks for your rating');
                                EasyLoading.dismiss();
                              }

                            },
                            child: const Text('Submit'),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50,
                  child: ElevatedButton(

                    onPressed: () {

                      if(AuthService.user == null){
                        Navigator.pushNamed(context, LoginPage2.routeName);
                      }else {
                        if (AuthService.user!.isAnonymous) {
                          showMsg(context,
                              'Sign In before you add items to Cart');
                          return;
                        }
                        if (isInCart) {
                          cartprovider.removeFromCart(
                              product.id!);
                        } else {
                          final cartModel = CartModel(
                            productId: product.id,
                            productName: product.name,
                            salePrice: product.salesPrice,
                            imageUrl: product.imageUrl,
                            stock: product.stock,
                            category: product.category,
                          );
                          cartprovider.addToCart(cartModel);
                        }
                      }
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        onPrimary: appBarColor
                    ),
                    child: Text(isInCart ? 'Remove from Cart' : 'Add to Cart', style: TextStyle(color: Colors.white,fontSize: 15),),
                  ),
                )
              ],
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),

    );
  }
}

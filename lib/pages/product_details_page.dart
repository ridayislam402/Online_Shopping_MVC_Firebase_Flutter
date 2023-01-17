
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:online_shopping/auth/auth_service.dart';
import 'package:online_shopping/pages/login_page2.dart';
import 'package:online_shopping/pages/search_page.dart';
import 'package:online_shopping/providers/card_provider.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';
import 'cart_page.dart';

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
        actions: [
          IconButton(
              onPressed: () {
                 showSearch(context: context, delegate: SearchPage4());
              }, icon: Icon(Icons.search,size: 30,)),

         // SizedBox(height: 5,),
          InkWell(
            onTap: () {
              if(AuthService.user==null){
                showbackDialog(context: context);
              }else {
                Provider.of<CartProvider>(context, listen: false)
                    .clearCheckout();
                Navigator.pushNamed(context, CartPage.routeName);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  Icon(
                    Icons.shopping_cart,
                    size: 30,
                  ),
                  Positioned(
                    right: -4,
                    top: -1,
                    child: Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.grey, shape: BoxShape.circle),
                      child: FittedBox(
                        child: Consumer<CartProvider>(
                            builder: (context, provider, _) =>
                                Text('${provider.totalItemsInCart}')),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          SizedBox(width: 10,),

        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: provider.getProductById(pid),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            final product = ProductModel.fromMap(snapshot.data!.data()!);
            final isInCart = cartprovider.isInCart(product.id!);

            return Column(
              children: [
                if (product.stock == 0)
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

                Expanded(
                  child: Stack(
                    children: [
                      FullScreenWidget(
                        child: Hero(
                          tag: Key(product.id.toString()),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'images/placeholder.png',
                            image: product.imageUrl,
                            fadeInCurve: Curves.bounceInOut,
                            fadeInDuration: const Duration(seconds: 3),
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  Container(
                    margin: EdgeInsets.only(top: 280),
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Container(
                        //
                          //margin: EdgeInsets.only(top: 200),
                          padding: EdgeInsets.only(
                           // top: 100,
                            left: 20.0,
                            right: 20.0,
                          ),
                          // height: 500,
                          decoration: BoxDecoration(
                            color: appBarColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(product.name, style: TextStyle(fontSize: 20,color: Colors.white)),
                                trailing: Text('$currencySymbol${product.salesPrice}', style: TextStyle(fontSize: 30,color: Colors.white),),
                              ),
                              SizedBox(height: 30,),
                              /*ListTile(
                                title: Text('$currencySymbol${product.salesPrice}', style: TextStyle(fontSize: 30,color: Colors.white),),
                              ),*/
                              ListTile(
                                title: Text('Product Description', style: TextStyle(fontSize: 20,color: Colors.white),),
                                subtitle: Text(product.description ?? 'Not Available',style: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(height: 50,),
                              if (product.stock != 0)Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Container(
                                  color: Colors.white,
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
                                              // Navigator.pushNamed(context, LoginPage2.routeName);
                                              showbackDialog(context: context);
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
                            ],
                          ),
                        )
                      ],
                    ),
                  ),


                    ],
                  ),
                ),

                if (product.stock != 0)
                  Material(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {
                        if(AuthService.user == null){
                          // Navigator.pushNamed(context, LoginPage2.routeName);
                          showbackDialog(context: context);
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
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 28),
                       // child: Text('Login',style: TextStyle(color: appBarColor,fontSize: 16),),
                        child: Text(isInCart ? 'Remove from Cart' : 'Add to Cart', style: TextStyle(color: Colors.white,fontSize: 15),),
                      ),


                    ),
                  ),
                SizedBox(height: 10,)
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

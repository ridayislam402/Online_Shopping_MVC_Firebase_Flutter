import 'package:flutter/material.dart';
import 'package:online_shopping/customwidgets/product_item.dart';
import 'package:provider/provider.dart';

import '../customwidgets/main_drawer.dart';
import '../providers/card_provider.dart';
import '../providers/product_provider.dart';

class ProductPage extends StatelessWidget {
  static const String routeName = '/product';
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).getAllProduct();
    Provider.of<CartProvider>(context, listen: false).getAllCartItems();
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Consumer<ProductProvider>(
      builder: (context, provider, _) => provider.productList.isEmpty
    ? const Center(
    child: Text('No item found'),
    )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.65),
          itemCount: provider.productList.length,

          itemBuilder: (context, index) {
            final product = provider.productList[index];
            return ProductItem(productModel: product);
          },)
      ),
    );
  }
}

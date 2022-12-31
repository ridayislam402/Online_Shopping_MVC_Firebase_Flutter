
import 'package:flutter/material.dart';
import 'package:online_shopping/auth/auth_service.dart';
import 'package:online_shopping/pages/cart_page.dart';
import 'package:provider/provider.dart';
import '../customwidgets/category_list_view.dart';
import '../customwidgets/main_drawer.dart';
import '../customwidgets/product_item.dart';
import '../providers/card_provider.dart';
import '../providers/order_provider.dart';
import '../providers/product_provider.dart';

class ProductPage extends StatelessWidget {
  static const String routeName = '/product';

  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).getAllProduct();
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    AuthService.user==null?null:Provider.of<CartProvider>(context, listen: false).getAllCartItems();
    AuthService.user==null?null:Provider.of<OrderProvider>(context, listen: false).getOrderByUser();
    AuthService.user==null?null:Provider.of<CartProvider>(context, listen: false).getAllCheckoutItems();

    return Scaffold(
      backgroundColor: Colors.red,
      drawer: MainDrawer(),
      /*AppBar(
        elevation: 0,
        title: const Text('Products'),
        actions: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, CartPage.routeName),
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
                  )
                ],
              ),
            ),
          )
        ],
      ),*/
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) => _buildSliverList(context, provider),
      ),
    );
  }

  Widget _buildSliverList(BuildContext context, ProductProvider provider) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text('Products'),
          floating: true,
          expandedHeight: 170,
          flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: ListView(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  CategoryListView(
                    provider: provider,
                    onSelect: (category) {
                      provider.filterProductsByCategory(category);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      '${provider.filteredProductList.length} item(s) found',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )),
          actions: [
            InkWell(
              onTap: () {
                Provider.of<CartProvider>(context,listen: false).clearCheckout();
                Navigator.pushNamed(context, CartPage.routeName);
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
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        SliverGrid.count(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          children: provider.filteredProductList
              .map((e) => ProductItem(productModel: e))
              .toList(),
        ),
      ],
    );
  }

  GridView buildGridView(ProductProvider provider) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.65),
      itemCount: provider.productList.length,
      itemBuilder: (context, index) {
        final product = provider.productList[index];
        return ProductItem(productModel: product);
      },
    );
  }
}

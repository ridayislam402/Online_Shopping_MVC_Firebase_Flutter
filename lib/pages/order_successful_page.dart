import 'package:flutter/material.dart';
import 'package:online_shopping/pages/launcher_page.dart';
import 'package:online_shopping/pages/order_page.dart';
import 'package:online_shopping/utils/constants.dart';

class OrderSuccessfulPage extends StatelessWidget {
  static const String routeName = '/order_successful';

  const OrderSuccessfulPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final result = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        title: const Text('Order Successful'),
      ),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.done, size: 150,color: Colors.white,),
          SizedBox(height: 20,),
          if(result!=null)Text('Total Payment $currencySymbol$result Successfull', style: TextStyle(fontSize: 20, color: Colors.white),),

          SizedBox(height: 20,),


          Text('Your order has been placed successfully', style: TextStyle(fontSize: 20, color: Colors.white),),
          SizedBox(height: 20,),
          Text('Thank you !!!', style: TextStyle(fontSize: 20, color: Colors.white),),
          SizedBox(height: 20,),
          SizedBox(height: 45,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, LauncherPage.routeName),
                child: Text('Get More Product',style: TextStyle(fontSize: 15),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  onPrimary: Colors.black,
                ),
              )
          ),
          SizedBox(height: 20,),
          SizedBox(height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, OrderPage.routeName),
                child: Text('My Orders',style: TextStyle(),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  onPrimary: Colors.black,
                ),
              )
          ),

        ],
      ),),
    );
  }
}
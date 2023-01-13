import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_shopping/pages/cart_page.dart';
import 'package:online_shopping/pages/checkout_page.dart';
import 'package:online_shopping/pages/launcher_page.dart';
import 'package:online_shopping/pages/login_page.dart';
import 'package:online_shopping/pages/login_page2.dart';
import 'package:online_shopping/pages/order_page.dart';
import 'package:online_shopping/pages/order_successful_page.dart';
import 'package:online_shopping/pages/product_details_page.dart';
import 'package:online_shopping/pages/product_page.dart';
import 'package:online_shopping/pages/signup_page.dart';
import 'package:online_shopping/pages/user_page.dart';
import 'package:online_shopping/pages/welcome_page.dart';
import 'package:online_shopping/providers/card_provider.dart';
import 'package:online_shopping/providers/order_provider.dart';
import 'package:online_shopping/providers/product_provider.dart';
import 'package:online_shopping/providers/user_provider.dart';
import 'package:online_shopping/utils/constants.dart';
import 'package:provider/provider.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ProductProvider(),),
    ChangeNotifierProvider(create: (context) => OrderProvider(),),
    ChangeNotifierProvider(create: (context) => UserProvider(),),
    ChangeNotifierProvider(create: (context) => CartProvider(),)
  ],child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Online Shopping',
      theme: ThemeData(
        primaryColor: appBarColor,
        textTheme: GoogleFonts.latoTextTheme(),
        appBarTheme: AppBarTheme(
            backgroundColor: appBarColor,
            iconTheme: IconThemeData(
              color: Colors.red,
            )
        ),
        primarySwatch: Colors.blue,
      ),
      initialRoute: LauncherPage.routeName,
      builder: EasyLoading.init(),
      routes: {
        LauncherPage.routeName : (context) => LauncherPage(),
      //  DashbordPage.routeName : (context) => DashbordPage(),
        LoginPage.routeName : (context) => LoginPage(),
        ProductPage.routeName : (context) => ProductPage(),
        CartPage.routeName : (context) => CartPage(),
        CheckoutPage.routeName : (context) => CheckoutPage(),
        OrderSuccessfulPage.routeName : (context) => OrderSuccessfulPage(),
        WelcomePage.routeName : (context) => WelcomePage(),
        LoginPage2.routeName : (context) => LoginPage2(),
        OrderPage.routeName : (context) => OrderPage(),
        SignUpPage.routeName : (context) => SignUpPage(),
        UserPage.routeName : (context) => UserPage(),
        ProductDetailsPage.routeName : (context) => ProductDetailsPage(),
       // SearchPage.routeName : (context) => SearchPage(),
       // SearchScreen.routeName : (context) => SearchScreen(),




        // NewProductPage.routeName : (context) => NewProductPage(),
       // ProductDetailsPage.routeName : (context) => ProductDetailsPage(),

      },
    );
  }
}


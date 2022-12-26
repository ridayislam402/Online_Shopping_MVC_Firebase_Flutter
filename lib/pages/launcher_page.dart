
import 'package:flutter/material.dart';
import 'package:online_shopping/pages/login_page.dart';
import 'package:online_shopping/pages/product_page.dart';
import 'package:online_shopping/pages/welcome_page.dart';

import '../auth/auth_service.dart';



class LauncherPage extends StatefulWidget {
  static const String routeName='/launcher';
  const LauncherPage({Key? key}) : super(key: key);

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if(AuthService.user == null) {
        Navigator.pushReplacementNamed(context, WelcomePage.routeName);
      } else {
        Navigator.pushReplacementNamed(context, ProductPage.routeName);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();

  }
}

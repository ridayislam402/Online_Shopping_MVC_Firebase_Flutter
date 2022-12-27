
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/pages/login_page2.dart';
import 'package:online_shopping/pages/welcome_page.dart';

class UserPage extends StatelessWidget {
  static const String routeName = '/user';
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //This ProfileScreen widget is from firebase_ui_auth package
    return ProfileScreen(
      appBar: AppBar(title: const Text('My Profile'),),
      providers: [EmailAuthProvider()],
      actions: [
        SignedOutAction((context) => Navigator.pushNamedAndRemoveUntil(context, LoginPage2.routeName,ModalRoute.withName(WelcomePage.routeName))),
      ],
      /*children: [
        const FlutterLogo(size: 100,),
        Text('PencilBox', style: Theme.of(context).textTheme.headline4,)
      ],*/
    );
  }
}

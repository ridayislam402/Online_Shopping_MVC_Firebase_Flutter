import 'dart:io';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/pages/login_page2.dart';
import 'package:online_shopping/pages/user_page2.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../models/user_model.dart';
import '../pages/launcher_page.dart';
import '../pages/order_page.dart';
import '../pages/user_page.dart';
import '../providers/user_provider.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String? imageUrl;
  bool isFirst = true;
  late UserModel userModel;
  late final userProvider;
  String? _localImagePath;

  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context);
    userProvider.getUserByUid().then((value) {
      setState(() {
        userModel = value;

        if(userModel!.image! != null){
          imageUrl = userModel.image!;
        }
      });
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Stack(
            children: [

              Container(
                height: 400,
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: FittedBox(
                      fit: BoxFit.fill,
                      child:
                      Image.network('https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg')
                  ),
                ),
              ),
              Positioned.fill(
                  child: Center(
                    child: CircleAvatar(
                      radius: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(360),
                        child: SizedBox.expand(
                          child: FittedBox(
                              fit: BoxFit.fill,
                              child: imageUrl == null
                                  ?Icon(Icons.image) :
                              Image.network(imageUrl.toString())

                          ),
                        ),
                      ),
                    ),
                  )
              ),


            ],
          ),
          
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, ProfilePage.routeName);
            },
            leading: Icon(Icons.person),
            title: const Text('My Profile'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, OrderPage.routeName);
            },
            leading: Icon(Icons.shopping_bag),
            title: const Text('My Orders'),
          ),
          ListTile(
            onTap: () {
              AuthService.logout().then((value) =>
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginPage2.routeName, ModalRoute.withName(LoginPage2.routeName)));
            },
            leading: const Icon(Icons.logout),
            title: const Text('LOGOUT'),
          ),
        ],
      ),
    );
  }
}

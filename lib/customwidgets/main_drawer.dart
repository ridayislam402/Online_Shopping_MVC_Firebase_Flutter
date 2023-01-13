import 'package:flutter/material.dart';
import 'package:online_shopping/pages/login_page2.dart';

import '../auth/auth_service.dart';
import '../pages/launcher_page.dart';
import '../pages/order_page.dart';
import '../pages/user_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200,
            color: Theme.of(context).primaryColor,
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, UserPage.routeName);
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

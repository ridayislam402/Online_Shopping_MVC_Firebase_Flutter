
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_shopping/pages/login_page2.dart';
import 'package:online_shopping/pages/signup_page.dart';
import 'package:online_shopping/providers/card_provider.dart';
import 'package:online_shopping/utils/constants.dart';
import 'package:provider/provider.dart';

String getFormattedDateTime(DateTime dateTime, String pattern) =>
    DateFormat(pattern).format(dateTime);

showMsg(BuildContext context, String msg,) =>
    ScaffoldMessenger
        .of(context)
        .showSnackBar(SnackBar(content: Text(msg)));


void showbackDialog({
  required BuildContext context,

}) {
  //final _descController = TextEditingController();
  showDialog(
  //  barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: appBarColor,
      title: Text('Please Login First',style: TextStyle(color: Colors.white),),
      content: Padding(
        padding: EdgeInsets.all(8),
        child: ElevatedButton(onPressed: () {
          Navigator.pushNamed(context, LoginPage2.routeName);
        },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,),
            child: Text('Login')),
      ),
      actions: [
        Text(""
            "Don't have an Account?",style: TextStyle(color: Colors.white),),
        ElevatedButton(onPressed: () {
          Navigator.pushNamed(context, SignUpPage.routeName);
        },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,),
            child: Text('Signup'))
      ],
    ),
  );
}

void showCartDialog({
  required BuildContext context,
  required CartProvider provider,

}) {
  //final _descController = TextEditingController();
  showDialog(
    //  barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: appBarColor,
      title: Text('Are You Sure?',style: TextStyle(color: Colors.white),),
      content: Padding(
        padding: EdgeInsets.all(8),
        child: Text('Clear All The Cart Item', style: TextStyle(color: Colors.white),),
      ),
      actions: [
        TextButton(onPressed: () {
          Navigator.pop(context);
        }, child: Text('Cancel')),
        ElevatedButton(onPressed: () {
          provider.clearCart();
          Navigator.pop(context);
        },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,),
            child: Text('Yes'))
      ],
    ),
  );
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_shopping/pages/login_page2.dart';
import 'package:online_shopping/utils/constants.dart';

class WelcomePage extends StatelessWidget {
  static const String routeName='/welcome';
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBarColor,
        body: Stack(
          children: [
            Positioned(
                top: 0,
                left: 0,
                child: Image.asset('images/main_top.png',height: 120,)
            ),
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Welcome', style: TextStyle(fontSize: 40, color: Colors.white)),
                  const SizedBox(height : 50,),
                  SvgPicture.asset('images/chat.svg',height: 320,),
                  const SizedBox(height: 10,),


                  SizedBox(height: 10),
                  SizedBox(height: 40,
                      child: ElevatedButton(
                        onPressed:() {

                        },
                        child: Text('Skip',),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          onPrimary: Colors.black,
                        ),)),
                  SizedBox(height: 15),
                  SizedBox(height: 50,
                      width: 100,
                      child: ElevatedButton(
                        onPressed:() {
                      Navigator.pushNamed(context, LoginPage2.routeName);
                        },
                        child: Text('Login',style: TextStyle(fontSize: 20),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          onPrimary: Colors.black,
                        ),)),
                  SizedBox(height: 15),
                  SizedBox(height: 40,
                      child: ElevatedButton(
                        onPressed:() {

                        },
                        child: Text('SignUp'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          onPrimary: Colors.black,
                        ),)),

                  // Text(text),
                ],),
            )
          ],)
    );
  }
}

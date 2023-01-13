import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_shopping/pages/launcher_page.dart';
import 'package:online_shopping/pages/signup_page.dart';
import 'package:online_shopping/utils/constants.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../providers/user_provider.dart';
class LoginPage2 extends StatefulWidget {
  static const String routeName='/login';

  @override
  State<LoginPage2> createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
  //const LoginPage2({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isObscureText = true, isLogin = true;
  final formKey = GlobalKey<FormState>();
  String errMsg = '';
  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Form(
          key: formKey,
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset('images/main_top.png',height: 120,)
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40,),
                      const Text('Please Login First', style: TextStyle(fontSize: 30, color: Colors.white)),
                      const SizedBox(height : 40,),
                      SvgPicture.asset('images/signup.svg',height: 320,),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:  BorderSide(
                                      color: Colors.white60
                                  )
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:  BorderSide(
                                      color: Colors.white60
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:  BorderSide(
                                      color: Colors.white60
                                  )
                              ),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:  BorderSide(
                                      color: Colors.white60
                                  )
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              fillColor: Colors.white,
                              hintText: 'Email ....',
                              prefixIcon: const Icon(Icons.email,color: Colors.black,),
                              filled: true),
                          validator: (value) {
                            if(value == null || value.isEmpty) {
                              return 'This field must not be empty';
                            }
                            return null;
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: TextFormField(
                          obscureText: isObscureText,
                          controller: passController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:  BorderSide(
                                      color: Colors.white60
                                  )
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:  BorderSide(
                                      color: Colors.white60
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:  BorderSide(
                                      color: Colors.white60
                                  )
                              ),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:  BorderSide(
                                      color: Colors.white60
                                  )
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            //  prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    isObscureText ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() {
                                  isObscureText = !isObscureText;
                                }),
                              ),
                              fillColor: Colors.white,
                              hintText: 'password ....',
                              prefixIcon: Icon(Icons.vpn_key_sharp,color: Colors.black,),
                              filled: true),

                          validator: (value) {
                            if(value == null || value.isEmpty) {
                              return 'This field must not be empty';
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: 10),
                      Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        child: InkWell(
                          onTap: () {
                            isLogin=true;
                            authenticate();
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 28),
                            child: Text('Login',style: TextStyle(color: appBarColor,fontSize: 16),),
                          ),


                        ),
                      ),

                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an Account ?",style: TextStyle(color: Colors.white),),
                          TextButton(
                              onPressed: () {
                              Navigator.pushNamed(context, SignUpPage.routeName);
                          }, child: Text('SignUp', style: TextStyle(fontSize: 20,color: Colors.green),))
                        ],
                      )
                     // Text(text),
                    ],),
                )
              ],)

        )
    );
  }
  authenticate() async {
    if(formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait');
      bool status;
      try {
        if(isLogin) {
          status = await AuthService.login(emailController.text, passController.text);
        } else {
          status = await AuthService.register(emailController.text, passController.text);
          if(mounted) {
            await Provider.of<UserProvider>(context, listen: false)
                .addNewUserlogin(AuthService.user!.uid,  AuthService.user!.email!, Timestamp.fromDate(AuthService.user!.metadata.creationTime!));

          }
        }
        if(status) {
          if(mounted) {
            EasyLoading.dismiss();
            Navigator.pushReplacementNamed(context, LauncherPage.routeName);

          }
        } else {

        }
      } on FirebaseAuthException catch (error) {
        setState(() {
          errMsg = error.message!;
        });
      }
    }
  }
}
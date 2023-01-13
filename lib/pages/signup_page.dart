import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:online_shopping/models/address_model.dart';
import 'package:online_shopping/pages/login_page2.dart';
import 'package:online_shopping/utils/constants.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../providers/user_provider.dart';
import 'launcher_page.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/signup';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //const SignUpPage({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final zcodeController = TextEditingController();
  bool isObscureText = true, isLogin = true;
  final formKey = GlobalKey<FormState>();
  String errMsg = '';
  bool isVisible = false;
  String? city, area;


  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
    mobileController.dispose();
    addressController.dispose();
    zcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SignUp'),),
      backgroundColor: appBarColor,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 20,),
              const Text('SignUp', style: TextStyle(fontSize: 40, color: Colors.white)),
              const SizedBox(height : 50,),
            //  SvgPicture.asset('images/login.svg',height: 320,),
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
                  }
                ),
              ),
              TextButton(onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                },);

              }, child: Text('Please Add Your Information',style: TextStyle(fontSize: 15,color: Colors.green,decoration: TextDecoration.underline),)),
              Visibility(
                visible: isVisible,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: DropdownButtonFormField<String>(
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
                            //hintText: 'Email ....',
                            // prefixIcon: const Icon(Icons.email,color: Colors.black,),
                            filled: true),
                        isExpanded: true,
                        hint: const Text('Select City '),
                        value: city,
                        items: cityArea.keys
                            .toList()
                            .map((c) => DropdownMenuItem<String>(
                          value: c,
                          child: Text(c),

                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            city = value;
                            area = null;
                          });
                        },
                        /*validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a City';
                          }
                          return null;
                        },*/
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: DropdownButtonFormField<String>(
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
                            //hintText: 'Email ....',
                            // prefixIcon: const Icon(Icons.email,color: Colors.black,),
                            filled: true),
                        isExpanded: true,
                        hint: const Text('Select Area '),
                        value: area,
                        items: cityArea[city]
                            ?.map((a) => DropdownMenuItem<String>(
                          value: a,
                          child: Text(a),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            area = value;
                          });
                        },

                        /*validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an Area';
                          }
                          return null;
                        },*/
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: nameController,
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
                            hintText: 'Enter Your Name',
                            // prefixIcon: const Icon(Icons.email,color: Colors.black,),
                            filled: true),

                        /*validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide a Name';
                          }
                          return null;
                        },*/
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: mobileController,
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
                            hintText: 'Enter Your Number',
                            // prefixIcon: const Icon(Icons.email,color: Colors.black,),
                            filled: true),
                        /*validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide a Mobile Number';
                          }
                          return null;
                        },*/
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: addressController,
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
                            hintText: 'Enter Delivery Address',
                            // prefixIcon: const Icon(Icons.email,color: Colors.black,),
                            filled: true),

                        /*validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide a Street Address';
                          }
                          return null;
                        },*/
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: zcodeController,
                        keyboardType: TextInputType.number,
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
                            hintText: 'Enter Zip Code',
                            // prefixIcon: const Icon(Icons.email,color: Colors.black,),
                            filled: true),
                        /*validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide a Zip Code';
                          }
                          return null;
                        },*/
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 20,),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: () {
                    isLogin = false;
                    authenticate();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 28),
                    child: Text('Register',style: TextStyle(color: appBarColor,fontSize: 16),),
                  ),


                ),
              ),
              SizedBox(height: 20,),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Aleady have an Account ?",style: TextStyle(color: Colors.white),),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginPage2.routeName);
                      }, child: Text('Login', style: TextStyle(fontSize: 20,color: Colors.green),))
                ],
              )
            ],
          ),
        ),
      ),
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
            if(isVisible){
              final addresss= AddressModel(streetAddress: addressController.text, area: area!, city: city!, zipCode: zcodeController.text);
              await Provider.of<UserProvider>(context, listen: false)
                  .addNewUser(AuthService.user!.uid, nameController.text, mobileController.text,addresss, AuthService.user!.email!, Timestamp.fromDate(AuthService.user!.metadata.creationTime!));
            }else{
              await Provider.of<UserProvider>(context, listen: false)
                  .addNewUserlogin(AuthService.user!.uid,  AuthService.user!.email!, Timestamp.fromDate(AuthService.user!.metadata.creationTime!));
            }
          }
        }
        if(status) {
          if(mounted) {
         //  await addressm();
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

  addressm() async{

  }

}

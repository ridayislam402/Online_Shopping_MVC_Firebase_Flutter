import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/models/address_model.dart';
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email Address',
                    prefixIcon: const Icon(Icons.email),

                  ),
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          isObscureText ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() {
                        isObscureText = !isObscureText;
                      }),
                    ),
                  ),
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

              }, child: Text('Please Add Your Information',style: TextStyle(fontSize: 15,color: Colors.blue,decoration: TextDecoration.underline),)),
              Visibility(
                visible: isVisible,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true
                        ),
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
                            fillColor: Colors.white,
                            filled: true
                        ),
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
                          hintText: 'Enter Your Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
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
                          hintText: 'Enter Your Number',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
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
                          hintText: 'Enter delivery address',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
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
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter Zip Code', ),
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
              SizedBox(height: 50,
                child: ElevatedButton(
                  onPressed:
                      () {
                        isLogin = false;
                        authenticate();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      onPrimary: Colors.black,
                  ),
                  child: const Text('SignUp'),
                ),
              ),
              SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }
  authenticate() async {
    if(formKey.currentState!.validate()) {
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
            }

          }
        }
        if(status) {
          if(mounted) {
         //  await addressm();
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

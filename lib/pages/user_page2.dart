
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_shopping/models/address_model.dart';
import 'package:online_shopping/models/user_model.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profilepage';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _localImagePath;

  ImageSource _imageSource = ImageSource.camera;
  String? city, area;
  final addressController = TextEditingController();
  final zcodeController = TextEditingController();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  bool isFirst = true;
  final _formKey = GlobalKey<FormState>();

  late UserModel userModel;
  late final userProvider;
  String? imageUrl;
  @override
  void didChangeDependencies() {
    if (isFirst) {
      userProvider = Provider.of<UserProvider>(context);
      userProvider.getUserByUid().then((value) {
        setState(() {
          userModel = value;
          if (userModel!.address != null) {
            nameController.text = userModel!.name!;
            mobileController.text = userModel!.mobile!;
            addressController.text = userModel!.address!.streetAddress;
            zcodeController.text = userModel!.address!.zipCode;
            city = userModel!.address!.city;
            area = userModel!.address!.area;
          }
          if(userModel!.image! != null){
            imageUrl = userModel.image!;
          }
        });
      });
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    addressController.dispose();
    zcodeController.dispose();
    nameController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: appBarColor,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
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
                      Positioned(
                        right: 0,
                        top: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                 _imageSource = ImageSource.camera;
                                  _getImage();
                              },
                              icon: Icon(Icons.camera),
                              label: Text('Camera',style: TextStyle(color: Colors.white),),
                            ),
                            SizedBox(width: 10,),
                            TextButton.icon(
                              onPressed: () {
                                  _imageSource = ImageSource.gallery;
                                  _getImage();
                              },
                              icon: Icon(Icons.photo),
                              label: Text('Gallery'),
                            )
                          ],
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
                                    child: _localImagePath == null
                                        ? imageUrl==null?Icon(Icons.image):Image.network(imageUrl.toString()) :
                                    Image.file(
                                      File(_localImagePath!),

                                    )
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),


                    ],
                  ),
                //  Text('data',style: TextStyle(color: Colors.blue,fontSize: 30),),
                  TextFormField(
                    controller: nameController,
                    style: TextStyle(fontSize: 30,color: appBarColor),
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
                        hintText: 'Enter your Name',
                        //  prefixIcon: const Icon(Icons.email,color: Colors.black,),
                        filled: true),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide your Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 20),
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
                        hintText: 'Enter Phone Number',
                        //  prefixIcon: const Icon(Icons.email,color: Colors.black,),
                        filled: true),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide your Phone Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
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
                        // hintText: 'Email ....',
                        //  prefixIcon: const Icon(Icons.email,color: Colors.black,),
                        filled: true),
                    onChanged: (value) {
                      setState(() {
                        city = value;
                        area = null;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a City';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    hint: const Text('Select Area '),
                    value: area,
                    items: cityArea[city]
                        ?.map((a) => DropdownMenuItem<String>(
                      value: a,
                      child: Text(a),
                    ))
                        .toList(),
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
                        // hintText: 'Email ....',
                        //  prefixIcon: const Icon(Icons.email,color: Colors.black,),
                        filled: true),
                    onChanged: (value) {
                      setState(() {
                        area = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an Area';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  TextFormField(
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
                        hintText: 'Enter delivery address',
                        //  prefixIcon: const Icon(Icons.email,color: Colors.black,),
                        filled: true),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a Street Address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
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
                        //  prefixIcon: const Icon(Icons.email,color: Colors.black,),
                        filled: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a Zip Code';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {
                       _saveUser();
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 28),
                        child: Text('Update',style: TextStyle(color: appBarColor,fontSize: 16),),
                      ),


                    ),
                  ),
               //   ElevatedButton(onPressed: _saveOrder, child: Text('Update'))
                  SizedBox(height: 20,)

                ],
              ),
            ),
          ),
        )
    );
  }

  void _getImage() async{
    final selectedImage = await ImagePicker().pickImage(source: _imageSource,imageQuality: 75);
    if(selectedImage != null){
      setState(() async{
        EasyLoading.show(status: 'Please Wait...');
        _localImagePath = selectedImage.path;
        final imageUrl =await  Provider.of<UserProvider>(context,listen: false).uploadImage(_localImagePath!);
        await Provider.of<UserProvider>(context,listen: false).updateUserDet(gUserimage, imageUrl).then((value) {
          setState(() {
            EasyLoading.dismiss();
          });
        });

      });
    }
  }

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {
      final addressModel = AddressModel(streetAddress: addressController.text, area: area!, city: city!, zipCode: zcodeController.text);
     await Provider.of<UserProvider>(context,listen: false).updateUserDet2(gUserAddress , addressModel);
     await Provider.of<UserProvider>(context,listen: false).updateUserDet(gUserName, nameController.text);
     await Provider.of<UserProvider>(context,listen: false).updateUserDet(gUserMobile, mobileController.text);
      final imageUrl = await Provider.of<UserProvider>(context,listen: false).uploadImage(_localImagePath!);



    }
  }


}

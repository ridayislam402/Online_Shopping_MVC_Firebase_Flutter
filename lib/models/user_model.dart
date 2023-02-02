import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_shopping/models/address_model.dart';

const String gUserName = 'name';
const String gUserMobile = 'mobile';
const String gUserAddress = 'address';
const String gUserStreetAddress = 'streetAddress';
const String gUserArea = 'area';
const String gUserCity = 'city';
const String gUserZipCode = 'zipCode';
const String gUserimage = 'image';




class UserModel {
  String uid;
  String? name;
  String email;
  String? mobile;
  String? image;
  AddressModel? address;
  Timestamp userCreationTime;
  String? deviceToken;

  UserModel(
      {required this.uid,
        this.name,
        required this.email,
        this.mobile,
        this.image,
        this.address,
        required this.userCreationTime,
        this.deviceToken});

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'uid' : uid,
      'name' : name,
      'mobile' : mobile,
      'email' : email,
      'address' : address!=null? address!.toMap():address,
      'image' : image,
      'deviceToken' : deviceToken,
      'userCreationTime' : userCreationTime,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'],
    name: map['name'],
    mobile: map['mobile'],
    email: map['email'],
    address: map['address'] == null ? null : AddressModel.fromMap(map['address']),
    image: map['image'],
    deviceToken: map['deviceToken'],
    userCreationTime: map['userCreationTime'],
  );
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_shopping/models/address_model.dart';


class UserModel_only_namemobile {
  String uid;
  String? name;
  String? mobile;
  String? image;


  UserModel_only_namemobile(
      {required this.uid,
        this.name,
        this.mobile,
        this.image,
      });

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'uid' : uid,
      'name' : name,
      'mobile' : mobile,
      'image' : image,
    };
  }

  factory UserModel_only_namemobile.fromMap(Map<String, dynamic> map) => UserModel_only_namemobile(
    uid: map['uid'],
    name: map['name'],
    mobile: map['mobile'],
    image: map['image'],

  );
}
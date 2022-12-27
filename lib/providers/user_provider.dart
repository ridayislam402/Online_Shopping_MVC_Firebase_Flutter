import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/models/address_model.dart';

import '../auth/auth_service.dart';
import '../db/db_helper.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier{
  Future<void> addNewUser(String uid, String namef, String mobilef,AddressModel addresss, String email, Timestamp userCreationTime) {
    final user = UserModel(
      uid: uid,
      name: namef,
      mobile: mobilef,
      address: addresss,
      email: email,
      userCreationTime: userCreationTime,
    );
    return DbHelper.addUser(user);
  }
  Future<void> addNewUserlogin(String uid, String email, Timestamp userCreationTime) {
    final userr = UserModel(
      uid: uid,
      email: email,
      userCreationTime: userCreationTime,
    );
    return DbHelper.addUser(userr);
  }

  Future<UserModel> getUserByUid() async {
    final snapshot = await DbHelper.getUserOnce(AuthService.user!.uid);
    return UserModel.fromMap(snapshot.data()!);
  }
}

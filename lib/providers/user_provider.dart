import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../db/db_helper.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier{
  Future<void> addNewUser(String uid, String email, Timestamp userCreationTime) {
    final user = UserModel(
      uid: uid,
      email: email,
      userCreationTime: userCreationTime,
    );
    return DbHelper.addUser(user);
  }

  Future<UserModel> getUserByUid() async {
    final snapshot = await DbHelper.getUserOnce(AuthService.user!.uid);
    return UserModel.fromMap(snapshot.data()!);
  }
}

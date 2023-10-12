import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/helper/firebase_auth_helper.dart';
import 'package:smartx_flutter_app/helper/firestore_database_helper.dart';
import 'package:smartx_flutter_app/helper/shared_preference_helpert.dart';

import '../../models/user_model.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Rx<bool> isPasswordVisible = Rx<bool>(true);

  void toggleIsPasswordVisible() => isPasswordVisible(!isPasswordVisible.value);
  final Rx<String> isPasswordError = Rx<String>('');
  final Rx<String> isEmailError = Rx<String>('');
  final FirebaseAuthHelper _firebaseAuthHelper = FirebaseAuthHelper.instance();
  final SharedPreferenceHelper _sharedPreferenceHelper =
      SharedPreferenceHelper.instance;
  final FirestoreDatabaseHelper _firestoreDatabaseHelper =
      FirestoreDatabaseHelper.instance();

  Future<String?> signIn(String email, String password) async {
    try {
      await _firebaseAuthHelper.signIn(email, password);
      final user = _firebaseAuthHelper.currentUser;
      if (user == null) return null;
      final res = await _firestoreDatabaseHelper.getUser(user.uid);
      if (res == null) return null;

      await _sharedPreferenceHelper.insertUser(res);
      return '';
    } on FirebaseAuthException catch (e) {
      await _firebaseAuthHelper.signout();

      return _firebaseAuthHelper.getErrorMessage(e);
    } catch (_) {
      await _firebaseAuthHelper.signout();
      return null;
    }
  }

  Future<Object?> signInWithGoogle() async {
    
    try {
      final user = await _firebaseAuthHelper.googleSignIn();
     print(user.displayName);
      await _sharedPreferenceHelper
          .insertUser(UserModel(email: user.email ?? '',fcmToken: '', id: user.uid, firstName: user.displayName ?? '',lastName: ''));
     
    } on FirebaseAuthException catch (e) {
      return _firebaseAuthHelper.getDatabaseErrorMessage(e);
    } catch (_) {


      return null;
    }
  }
}

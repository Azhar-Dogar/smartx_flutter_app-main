import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebasestorage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smartx_flutter_app/util/constants.dart';


class Functions {
  static var userID = FirebaseAuth.instance.currentUser!.uid;
  static var instance = FirebaseFirestore.instance;
  static var userDoc = instance.collection("users").doc(userID);

  static int calculateAge(int birthYear) {
    DateTime currentDate = DateTime.now();
    int currentYear = currentDate.year;
    int age = currentYear - birthYear;
    return age;
  }
  static showSnackBar(BuildContext context, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Constants.colorPrimaryVariant,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static showLoaderDialog(BuildContext context, {String text = 'Loading'}) {
    AlertDialog alert = AlertDialog(
      content: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Constants.colorLight,
            ),
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  "$text...",
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'FuturaMedium',
                    fontSize: 18,
                  ),
                )),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showToast(
      BuildContext context,String msg
      ) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Constants.colorSecondaryVariant,
        textColor: Colors.white,
        fontSize: 16.0
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       msg,
      //       style: const TextStyle(
      //         color: Colors.white,
      //       ),
      //     ),
      //     backgroundColor: CColors.primary,
      //   ),
    );
  }
  static String getNonce({int length = 32}) {
    String _allValues =
    ("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz");

    String finalString = "";
    Random rand = Random.secure();
    for (int i = 0; i < length; i++) {
      finalString += _allValues[rand.nextInt(_allValues.length - 1)];
    }
    return finalString;
  }


  static Future<String> uploadImage(Uint8List file, String child,
      {String contentType = "image/jpeg"}) async {
    try {
      final firebasestorage.FirebaseStorage storage =
          firebasestorage.FirebaseStorage.instance;

      var reference = storage.ref().child(child);
      var r = await reference.putData(
          file, SettableMetadata(contentType: contentType));
      if (r.state == firebasestorage.TaskState.success) {
        String url = await reference.getDownloadURL();
        return url;
      } else {
        throw PlatformException(code: "404", message: "no download link found");
      }
    } catch (e) {
      rethrow;
    }
  }
}

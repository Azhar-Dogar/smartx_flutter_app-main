import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/common/app_button.dart';

import '../../common/app_text_field.dart';
import '../../util/constants.dart';
import '../../util/functions.dart';
class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Reset Password",
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
             AppTextField(hint: "Email", textInputType: TextInputType.text, isError: false,controller: email,),
            const SizedBox(height: 20,),
            AppButton(
                color: Constants.buttonColor,
                text:"Send", onClick:(){
              Functions.showLoaderDialog(context);
              FirebaseAuth.instance.sendPasswordResetEmail(email: email.text).then((value){
                Navigator.pop(context);
                Navigator.pop(context);
                Functions.showSnackBar(context,"Password reset instructions has been send to your email.");
              });
            })
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utility_extensions/extensions/context_extensions.dart';

import '../util/functions.dart';

class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({Key? key}) : super(key: key);

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  var password = TextEditingController();
  var newPassword = TextEditingController();
  var confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if(password.text.trim().length < 6){
              Functions.showToast(context, "Old password didn't matched");
            }else if(newPassword.text.trim().length < 6){
              Functions.showToast(context, "Password should contain at least 6 characters.");
            }else if(newPassword.text.trim() != confirmPassword.text.trim()){
              Functions.showToast(context, "Password didn't matched.");
            }else{
              changePassword();
            }
          },
          child: Text("Ok "),
        ),
      ],
      title: Text(
        "Reset Password",
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFieldWidget(
              controller: password,
              hint: "Current Password",
            ),
            TextFieldWidget(
              controller: newPassword,
              hint: "New Password",
            ),
            TextFieldWidget(
              controller: confirmPassword,
              hint: "Confirm Password",
            ),
          ],
        ),
      ),
    );
  }

  changePassword(){

    Functions.showLoaderDialog(context);
    AuthCredential credential = EmailAuthProvider.credential(
      email: FirebaseAuth.instance.currentUser!.email!,
      password: password.text,
    );

    FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential).then((value){
      FirebaseAuth.instance.currentUser!.updatePassword(newPassword.text.trim()).then((value){
        context.pop();
        context.pop();

        Functions.showSnackBar(context, "Password updated successfully.");
      }).catchError((e){
        context.pop();
        FirebaseAuthException exception = e;
        Functions.showToast(context, exception.message ?? "");
      });
    }).catchError((e){
      context.pop();
      FirebaseAuthException exception = e;
      Functions.showToast(context, exception.message!.replaceAll("The password is invalid or the user does not have a password.", "Old password didn't matched.") ?? "");
    });
  }
}


class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    required this.controller,
    required this.hint,
    this.secureText,
    this.prefixWidget,
    this.sufixWidget,
    this.enable,
    this.expand,
    this.maxLines,
    this.verticalPadding,
    this.keyboardType,
    this.inputFormatter,
    this.onSubmit,
    this.onChange,
    Key? key,
  }) : super(key: key);

  TextEditingController controller;
  String hint;
  int? maxLines;
  bool? expand;
  bool? secureText;
  Widget? prefixWidget;
  Widget? sufixWidget;
  bool? enable;
  void Function(String)? onSubmit;
  void Function(String)? onChange;
  double? verticalPadding;

  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatter;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines ?? 1,
      expands: expand ?? false,
      keyboardType: keyboardType,
      inputFormatters: inputFormatter,
      enabled: enable,
      onChanged: onChange,
      obscureText: secureText ?? false,

      controller: controller,
      decoration: InputDecoration(
        contentPadding: verticalPadding == null
            ? null
            : EdgeInsets.symmetric(
          vertical: verticalPadding!,
        ),
        // Adjust this value
        hintText: hint,

        prefixIcon: prefixWidget != null
            ? Padding(
          padding: const EdgeInsets.only(right: 15),
          child: prefixWidget,
        )
            : null,
        suffixIcon: sufixWidget,
      ),
    );
  }
}
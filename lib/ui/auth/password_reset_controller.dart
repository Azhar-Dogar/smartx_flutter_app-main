import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordResetController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  Rx<bool> isEmailSent = Rx<bool>(false);

  final Rx<String> isEmailError = Rx<String>('');
}

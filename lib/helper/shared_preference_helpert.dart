import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

late SharedPreferences? _sharedPreferences;

class SharedPreferenceHelper {
  static const String _USER = 'SharedPreferenceHelper.user';
  static const String _PASSWORD = 'password';

  static final SharedPreferenceHelper instance =
      SharedPreferenceHelper._internal();

  SharedPreferenceHelper._internal();

  static Future<void> initializeSharedPreferences() async =>
      _sharedPreferences = await SharedPreferences.getInstance();

  bool get isUserLoggedIn => _sharedPreferences?.containsKey(_USER) ?? false;

  Future<UserModel?> get user async {
    final userSerialization = _sharedPreferences?.getString(_USER);
    if (userSerialization == null) return null;
    try {
      return UserModel.fromJson(json.decode(userSerialization));
    } catch (_) {
      return null;
    }
  }

  Future<void> insertUser(UserModel user) async {
    final userSerialization = json.encode(user.toWithoutDateJson());
    _sharedPreferences?.setString(_USER, userSerialization);
  }

  Future<void> savePassword(String pass) async {
    _sharedPreferences?.setString(_PASSWORD, pass);
  }

  Future<String?> get getPassword async {
    return _sharedPreferences?.getString(_PASSWORD);
  }

  Future<void> clear() async => _sharedPreferences?.clear();
}

import 'package:banjuipos/screen/login/services/loginApi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ChangeNotifier {
  LoginController({this.api = const LoginApi()}) {}

  LoginApi api;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future signIn({
    required String username,
    required String password,
  }) async {
    final data = await LoginApi.login(
      username,
      password,
    );
    final SharedPreferences prefs = await _prefs;

    await prefs.setString('token', data);
    notifyListeners();
    return data;
  }

  Future<void> clearToken() async {
    SharedPreferences prefs = await _prefs;
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }
}

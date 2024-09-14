import 'dart:developer';

import 'package:banjuipos/screen/login/services/loginApi.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ChangeNotifier {
  LoginController({this.api = const LoginApi()}) {}

  LoginApi api;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future signIn({
    required String username,
    required String password,
    required int branch_id
  }) async {
    final data = await LoginApi.login(
      username,
      password,
      branch_id
    );
    final SharedPreferences prefs = await _prefs;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(data);
    //inspect(decodedToken);
    await prefs.setString('token', data);
    await prefs.setString('branchID', decodedToken['branch_id']);
    notifyListeners();
    return data;
  }

  Future<void> clearToken() async {
    SharedPreferences prefs = await _prefs;
    prefs = await SharedPreferences.getInstance();
    //await prefs.clear();
    await prefs.remove('token');

    notifyListeners();
  }
}

import 'dart:convert' as convert;
import 'package:banjuipos/constants.dart';
import 'package:banjuipos/models/customer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginApi {
  const LoginApi();

  static Future login(
    String username,
    String password,
  ) async {
    final url = Uri.https(publicUrl, 'api/auth/sign-in');
    final response = await http.post(url, body: {
      'username': username,
      'password': password,
    });
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      return data['accessToken'];
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //เปิดกะ
  static Future openShift() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {
      'Authorization': 'Bearer $token', 'Content-Type': 'application/json'
    };
    final url = Uri.https(publicUrl, '/api/shift');
    final response = await http.post(headers: headers, url, body: convert.jsonEncode({"change": 0, "cash": 0, "branchId": 0, "remark": ""}));
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return data;
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //ค้นหาสมาชิก Customer
  static Future<Customer> cutomerSearch({required String phoneNumber}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token'};
    final url = Uri.https(publicUrl, 'api/customer/find-phone', {
      "phoneNumber": '$phoneNumber',
    });
    final response = await http.get(
      url,
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return Customer.fromJson(data);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }
}

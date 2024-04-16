import 'dart:convert' as convert;
import 'package:banjuipos/constants.dart';
import 'package:banjuipos/models/category.dart';
import 'package:banjuipos/models/customer.dart';
import 'package:banjuipos/models/myorder.dart';
import 'package:banjuipos/models/order.dart';
import 'package:banjuipos/models/orderitems.dart';
import 'package:banjuipos/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductApi {
  const ProductApi();

  //เรียกดูข้อมูล Category
  static Future<List<Category>> getCategory() async {
    final url = Uri.https(publicUrl, '/api/category');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.get(
      headers: headers,
      url,
    );
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      final list = data as List;
      return list.map((e) => Category.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //ดูข้อมูลสินค้า ตามไอดี Category
  static Future<List<Product>> getProduct({required int id}) async {
    final url = Uri.https(publicUrl, '/api/product', {
      "categoryId": '$id',
      "sortBy": 'createdAt:DESC',
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.get(
      headers: headers,
      url,
    );
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      final list = data as List;
      return list.map((e) => Product.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  static Future<Product> getproductById({required int id}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final url = Uri.https(
      publicUrl,
      '/api/product/$id',
    );
    final response = await http.get(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);

      return Product.fromJson(data);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //สร้างออร์เดอร์
  static Future<Order> ceateOrders({required int shiftId, required double total, required List<OrderItems> orderItems, required int customerId, required int licensePlateId, required String selectedPayment}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final url = Uri.https(publicUrl, '/api/order');
    final response = await http.post(url,
        headers: headers,
        body: convert.jsonEncode({
          "shiftId": shiftId,
          "total": total,
          "customerId": customerId,
          "licensePlateId": licensePlateId,
          "orderItems": orderItems,
          "selectedPayment": selectedPayment
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return Order.fromJson(data);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //ดูรายการคำสั่งซื้อ
  static Future<MyOrder> getMyOrder({
    required int start,
    int length = 10,
    String? search = '',
  }) async {
    final url = Uri.https(publicUrl, '/api/order/datatables', {
      "page": '$start',
      "limit": '$length',
      "sortBy": 'createdAt:DESC',
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.get(
      headers: headers,
      url,
    );
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      return MyOrder.fromJson(data);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  static Future<List<Order>> getOrder() async {
    final url = Uri.https(publicUrl, '/api/order');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.get(
      headers: headers,
      url,
    );
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      final list = data as List;
      return list.map((e) => Order.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //Get order by id
  static Future<Order> getOrderById({required int id}) async {
    final url = Uri.https(publicUrl, '/api/order/$id');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.get(
      headers: headers,
      url,
    );
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      return Order.fromJson(data);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //ลบออร์เดอร์
  static Future deleteOrder({required int id}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final url = Uri.https(
      publicUrl,
      '/api/order/$id',
    );
    final response = await http.delete(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      //final data = convert.jsonDecode(response.body);
      return true;
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //ดูลูกค้าทั้งหมด
  static Future<List<Customer>> getCustomer() async {
    final url = Uri.https(publicUrl, '/api/customer');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.get(
      headers: headers,
      url,
    );
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      final list = data as List;
      return list.map((e) => Customer.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //ดูลูกค้าทั้งหมด by id
  static Future<Customer> getCustomerById({required int id}) async {
    final url = Uri.https(publicUrl, '/api/customer/$id');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.get(
      headers: headers,
      url,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return Customer.fromJson(data);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //แก้ใขข้อมูลลูกค้า by id
  static Future<Customer> editCustomerById({
    required int cusid,
    required String code,
    required String name,
    required int levelId,
    required String address,
    required String phoneNumber,
    required String tax,
    required int identityCardId,
    required String licensePlate,
  }) async {
    final url = Uri.https(publicUrl, '/api/customer/$cusid');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.put(
        headers: headers,
        url,
        body: {"code": code, "name": name, "levelId": levelId, "address": address, "phoneNumber": phoneNumber, "tax": tax, "identityCardId": identityCardId, "licensePlate": licensePlate});
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return Customer.fromJson(data);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //เพิ่มข้อมูลลูกค้าใหม่
  static Future<Customer> addCustomer({required String name, required String phoneNumber, required String licensePlate, required String address, required String code, required String tax}) async {
    final url = Uri.https(publicUrl, '/api/customer');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.post(
        headers: headers,
        url,
        body: convert.jsonEncode({"code": code, "name": name, "levelId": 1, "address": address, "phoneNumber": phoneNumber, "tax": tax, "identityCardId": null, "licensePlate": licensePlate}));
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return Customer.fromJson(data);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }
}

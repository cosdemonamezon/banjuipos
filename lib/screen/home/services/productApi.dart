import 'dart:convert' as convert;
import 'package:banjuipos/constants.dart';
import 'package:banjuipos/models/branch.dart';
import 'package:banjuipos/models/category.dart';
import 'package:banjuipos/models/customer.dart';
import 'package:banjuipos/models/customerbank.dart';
import 'package:banjuipos/models/licenseplates.dart';
import 'package:banjuipos/models/myorder.dart';
import 'package:banjuipos/models/nameprefix.dart';
import 'package:banjuipos/models/order.dart';
import 'package:banjuipos/models/orderitems.dart';
import 'package:banjuipos/models/panel.dart';
import 'package:banjuipos/models/payment.dart';
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

  //ดูข้อมูลสินค้า ตามไอดี ระดับของลูกค้า and ตามไอดี Category
  static Future<List<Product>> getProductByLevelAndCategory({required int categoryid, required int levelId}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final branch_id = prefs.getString('branchID');
    final url = Uri.https(publicUrl, '/api/product/datatables', {
      "page": '1',
      "limit": '100',
      "filter.productLevels.level.id": '$levelId',
      if (categoryid != 0) "filter.category.id": '$categoryid',
      "filter.branch.id": '$branch_id',
      "sortBy": 'createdAt:DESC',
    });

    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.get(
      headers: headers,
      url,
    );
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      final list = data['data'] as List;
      return list.map((e) => Product.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //ดูข้อมูลสินค้า ตามไอดี ระดับของลูกค้า
  static Future<List<Product>> getProductByLevelId({required int levelId}) async {
    final url = Uri.https(publicUrl, '/api/product', {
      "levelId": '$levelId',
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

  //คนหาข้อมูลขอลลูกค้า
  static Future<List<Product>> searchProducts({required String search, required int levelId}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final branch_id = prefs.getString('branchID');
    final url = Uri.https(publicUrl, '/api/product/datatables', {
      "search": '$search',
      "filter.productLevels.level.id": '$levelId',
      "filter.branch.id": '$branch_id',
      "sortBy": 'createdAt:DESC',
    });
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.get(
      headers: headers,
      url,
    );
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      final list = data['data'] as List;
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

  //เรียกดูประเภทการชำระเงิน
  static Future<List<Payment>> getPaymentMethod() async {
    final url = Uri.https(publicUrl, '/api/payment-method');
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
      return list.map((e) => Payment.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //สร้างออร์เดอร์
  static Future<Order> ceateOrders({
    required int shiftId,
    required double total,
    required List<OrderItems> orderItems,
    required int customerId,
    String? licensePlate,
    required String selectedPayment,
    required int paymentMethodId,
    required String bankName,
    required String accountName,
    required String accountNumber,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final branch_id = prefs.getString('branchID');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final url = Uri.https(publicUrl, '/api/order');
    final response = await http.post(url,
        headers: headers,
        body: convert.jsonEncode({
          "shiftId": shiftId,
          "total": total,
          "bankName": bankName,
          "accountName": accountName,
          "accountNumber": accountNumber,
          "customerId": customerId,
          "licensePlate": licensePlate,
          "paymentMethodId": paymentMethodId,
          "branchId": branch_id,
          "orderItems": orderItems,
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
  // static Future<MyOrder> getMyOrder({
  //   required int start,
  //   int length = 10,
  //   String? search = '',
  // }) async {
  //   final url = Uri.https(publicUrl, '/api/order/datatables', {
  //     "page": '$start',
  //     "limit": '$length',
  //     "sortBy": 'createdAt:DESC',
  //   });
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //   var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
  //   final response = await http.get(
  //     headers: headers,
  //     url,
  //   );
  //   if (response.statusCode == 200) {
  //     final data = convert.jsonDecode(response.body);
  //     return MyOrder.fromJson(data);
  //   } else {
  //     final data = convert.jsonDecode(response.body);
  //     throw Exception(data['message']);
  //   }
  // }

  // static Future<List<Order>> getOrder() async {
  //   final url = Uri.https(publicUrl, '/api/order');
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //   var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
  //   final response = await http.get(
  //     headers: headers,
  //     url,
  //   );
  //   if (response.statusCode == 200) {
  //     final data = convert.jsonDecode(response.body);
  //     final list = data as List;
  //     return list.map((e) => Order.fromJson(e)).toList().reversed.toList();
  //   } else {
  //     final data = convert.jsonDecode(response.body);
  //     throw Exception(data['message']);
  //   }
  // }

  static Future<MyOrder> getOrder({
    required int start,
    required int length,
    String? search = '',
    String? orderDate = '',
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final branch_id = prefs.getString('branchID');
    final url = Uri.https(publicUrl, '/api/order/datatables', {
      "page": '$start',
      "limit": '$length',
      "filter.branch.id": '$branch_id',
      "sortBy": 'createdAt:ASC',
    });
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

  static Future<MyOrder> getOrderByDate({
    required int start,
    required int length,
    String? search = '',
    required String orderDate,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final branch_id = prefs.getString('branchID');
    final url = Uri.https(publicUrl, '/api/order/datatables', {
      "page": '$start',
      "limit": '$length',
      "filter.branch.id": '$branch_id',
      "filter.orderDate": '$orderDate',
      "sortBy": 'createdAt:ASC',
    });
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

  //ยกเลิกออร์เดอร์
  static Future<Order> cancelOrder({required int id}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final url = Uri.https(
      publicUrl,
      '/api/order/$id/cancel',
    );
    final response = await http.post(
      url,
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
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
  static Future<List<Customer>> getCustomer({required String search}) async {
    final url = Uri.https(publicUrl, '/api/customer/datatables', {
      "search": '$search',
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
      final list = data["data"] as List;
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
  static Future<Customer> addCustomer({
    required String name,
    required String phoneNumber,
    required String licensePlate,
    required String address,
    required String code,
    required String tax,
    required int prefixId,
  }) async {
    final url = Uri.https(publicUrl, '/api/customer');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.post(
        headers: headers,
        url,
        body: convert.jsonEncode({
          //"code": code,
          "name": name,
          "levelId": 1,
          "address": address,
          "phoneNumber": phoneNumber,
          "tax": tax,
          "identityCardId": null,
          "prefixId": prefixId,
          "licensePlates": [
            {"id": null, "licensePlate": licensePlate}
          ],
          "banks": [],
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return Customer.fromJson(data);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //เพิ่มทะเบียนรถ
  static Future<LicensePlates> addLicensePlate({required String licensePlate, required int customerId}) async {
    final url = Uri.https(publicUrl, '/api/customer/$customerId/license-plate');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.post(
        headers: headers,
        url,
        body: convert.jsonEncode({
          "licensePlate": licensePlate,
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return LicensePlates.fromJson(data);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //เพิ่มธนาคารของลูกค้า
  static Future<CustomerBank> addCustomerBank({required int customerId, required String accountName, required String accountNumber, required String bank}) async {
    final url = Uri.https(publicUrl, '/api/customer/$customerId/bank');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.post(headers: headers, url, body: convert.jsonEncode({"id": null, "accountName": accountName, "accountNumber": accountNumber, "bank": bank}));
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return CustomerBank.fromJson(data);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  static Future<List<NamePrefix>> getNamePrefixs() async {
    final url = Uri.https(publicUrl, '/api/name-prefix');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.get(
      headers: headers,
      url,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      final list = data as List;
      return list.map((e) => NamePrefix.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  static Future<List<Panel>> getPanels() async {
    final url = Uri.https(publicUrl, '/api/panel');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.get(
      headers: headers,
      url,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      final list = data as List;
      return list.map((e) => Panel.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  static Future<Panel> getPanelById({required int panelId, required int levelId}) async {
    final url = Uri.https(publicUrl, '/api/panel/$panelId', {
      "levelId": '$levelId',
      "sortBy": 'createdAt:DESC',
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.get(
      headers: headers,
      url,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return Panel.fromJson(data);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  static Future<List<Branch>> getBranch() async {
    final url = Uri.https(publicUrl, '/api/branch');
    var headers = {'Content-Type': 'application/json'};
    final response = await http.get(
      headers: headers,
      url,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      final list = data as List;
      return list.map((e) => Branch.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }
}

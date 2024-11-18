import 'dart:developer';

import 'package:banjuipos/models/branch.dart';
import 'package:banjuipos/models/category.dart';
import 'package:banjuipos/models/customer.dart';
import 'package:banjuipos/models/myorder.dart';
import 'package:banjuipos/models/nameprefix.dart';
import 'package:banjuipos/models/order.dart';
import 'package:banjuipos/models/panel.dart';
import 'package:banjuipos/models/product.dart';
import 'package:banjuipos/screen/home/services/productApi.dart';
import 'package:flutter/material.dart';

class ProductController extends ChangeNotifier {
  ProductController({this.api = const ProductApi()});
  ProductApi api;

  List<Category> categorized = [];
  Category? category;

  List<Product> products = [];
  Product? product;

  List<Order> orders = [];
  Order? order;
  MyOrder? myOrder;

  List<Customer> customers = [];
  List<Customer> searchCustomers = [];
  List<Customer> showCustomers = [];
  Customer? customer;
  List<NamePrefix> namePrefixs = [];
  List<Panel> panels = [];
  Panel? panel;

  List<Branch> branchs = [];
  Branch? branch;

  getListPanel({required int levelId}) async {
    panels.clear();
    panels = await ProductApi.getPanels();
    if (panels.isNotEmpty) {
      //getPanelById(panelId: panels[0].id!);
      panel = await ProductApi.getPanelById(panelId: panels[0].id!, levelId: levelId);
      products.clear();
      products = panel!.products!;
    }
    notifyListeners();
  }

  getPanelById({required int panelId, required int levelId}) async {
    panel = await ProductApi.getPanelById(panelId: panelId, levelId: levelId);
    products.clear();
    products = panel!.products!;
    notifyListeners();
  }

  getListCategory({required int levelId}) async {
    categorized.clear();
    categorized = await ProductApi.getCategory();
    categorized.insert(0, Category(0, '00', 'ทั้งหมด'));
    //getProduct(categoryid: categorized[0].id!);
    products.clear();
    //products = await ProductApi.getProduct(id: categorized[0].id!);
    products = await ProductApi.getProductByLevelAndCategory(categoryid: categorized[0].id!, levelId: levelId);
    notifyListeners();
  }

  getProduct({required int categoryid}) async {
    products.clear();
    products = await ProductApi.getProduct(id: categoryid);
    notifyListeners();
  }

  getproductById({required int productId}) async {
    product = await ProductApi.getproductById(id: productId);
    notifyListeners();
  }

  // getListMyOrder({
  //   required int start,
  //   int length = 10,
  //   String? search = '',
  // }) async {
  //   myorders = await ProductApi.getMyOrder(start: start);
  //   notifyListeners();
  // }

  getListOrder({
    required int start,
    required int length,
    String? search = '',
  }) async {
    //orders.clear();
    myOrder = await ProductApi.getOrder(start: start, length: length);
    //print(orders.length);
    notifyListeners();
  }

  getListOrderByDate({
    required int start,
    required int length,
    String? search = '',
    required String orderDate,
  }) async {
    //orders.clear();
    myOrder = await ProductApi.getOrderByDate(start: start, length: length, orderDate: orderDate);
    //print(orders.length);
    notifyListeners();
  }

  // getListOrder() async {
  //   //orders.clear();
  //   orders = await ProductApi.getOrder();
  //   //orders.reversed;
  //   print(orders.length);
  //   notifyListeners();
  // }

  getOrderById({required int id}) async {
    order = await ProductApi.getOrderById(id: id);
    notifyListeners();
  }

  getListCustomer({required String search}) async {
    customers.clear();
    customers = await ProductApi.getCustomer(search: search);
    showCustomers = customers;
    notifyListeners();
  }

  getListNamePrefix() async {
    namePrefixs.clear();
    namePrefixs = await ProductApi.getNamePrefixs();
    notifyListeners();
  }

  getCustomerById({required int id}) async {
    customer = await ProductApi.getCustomerById(id: id);
    notifyListeners();
  }

  searchListCustomer({required String search}) async {
    // List<Customer> _customer = customers.where((customer) => customer.name == search || customer.licensePlate == search || customer.phoneNumber == search || customer.code == search).toList();
    // searchCustomers = _customer;
    // if (searchCustomers.isNotEmpty) {
    //   showCustomers = searchCustomers;
    // } else {
    //   showCustomers = customers;
    // }
    List<Customer> _customer = [];
    _customer.addAll(customers);
    _customer.retainWhere((customerone) {
      return customerone.phoneNumber!.contains(search);
    });
    showCustomers = _customer;
    notifyListeners();
  }

  getListBranch() async {
    branchs.clear();
    branchs = await ProductApi.getBranch();
    notifyListeners();
  }
}

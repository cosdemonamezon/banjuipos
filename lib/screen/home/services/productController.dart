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

  MyOrder? myorders;

  List<Order> orders = [];
  Order? order;

  List<Customer> customers = [];
  Customer? customer;
  List<NamePrefix> namePrefixs = [];
  List<Panel> panels = [];
  Panel? panel;

  getListPanel() async {
    panels.clear();
    panels = await ProductApi.getPanels();
    if (panels.isNotEmpty) {
      getPanelById(panelId: panels[0].id!);
    }
    notifyListeners();
  }

  getPanelById({required int panelId}) async{
    panel = await ProductApi.getPanelById(panelId: panelId);
    products.clear();
    products = panel!.products!;
    notifyListeners();
  }

  getListCategory() async {
    categorized.clear();
    categorized = await ProductApi.getCategory();
    categorized.insert(0, Category(0, '00', 'ทั้งหมด'));
    getProduct(categoryid: categorized[0].id!);
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

  getListMyOrder({
    required int start,
    int length = 10,
    String? search = '',
  }) async {
    myorders = await ProductApi.getMyOrder(start: start);
    notifyListeners();
  }

  getListOrder() async {
    //orders.clear();
    orders = await ProductApi.getOrder();
    notifyListeners();
  }

  getOrderById({required int id}) async {
    order = await ProductApi.getOrderById(id: id);
    notifyListeners();
  }

  getListCustomer() async {
    customers.clear();
    customers = await ProductApi.getCustomer();
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
    List<Customer> _customer = customers.where((customer) => customer.name == search).toList();
    customers = _customer;
    notifyListeners();
  }
}

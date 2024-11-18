import 'dart:developer';

import 'package:banjuipos/constants.dart';
import 'package:banjuipos/extension/formattedMessage.dart';
import 'package:banjuipos/models/account.dart';
import 'package:banjuipos/models/category.dart';
import 'package:banjuipos/models/customer.dart';
import 'package:banjuipos/models/customerbank.dart';
import 'package:banjuipos/models/licenseplates.dart';
import 'package:banjuipos/models/orderitems.dart';
import 'package:banjuipos/models/panel.dart';
import 'package:banjuipos/models/payment.dart';
import 'package:banjuipos/models/product.dart';
import 'package:banjuipos/models/selectproduct.dart';
import 'package:banjuipos/screen/home/printPreview.dart';
import 'package:banjuipos/screen/home/services/productApi.dart';
import 'package:banjuipos/screen/home/services/productController.dart';
import 'package:banjuipos/screen/home/widgets/AddCardOrder.dart';
import 'package:banjuipos/screen/home/widgets/AddCustomerBank.dart';
import 'package:banjuipos/screen/home/widgets/AddDetailPayment.dart';
import 'package:banjuipos/screen/home/widgets/CustomerDialog.dart';
import 'package:banjuipos/screen/home/widgets/CustomerPayment.dart';
import 'package:banjuipos/screen/home/widgets/GridProduct.dart';
import 'package:banjuipos/screen/home/widgets/SelectPaymentType.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:banjuipos/widgets/LoadingDialog.dart';
import 'package:banjuipos/widgets/NumPad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool open = true;
  bool printxx = false;
  bool openShift = false;
  bool opentax = false;
  bool openCallback = false;
  List<Category> category = [];
  Category? sclectedProduct;
  int qty = 1;
  List<SelectProduct> selectproducts = [];
  List<List<SelectProduct>> showSelect = [];
  List<List<Product>> showProduct = [];
  List<Product> products = [];
  List<OrderItems> orderItems = [];
  final TextEditingController _myNumber = TextEditingController();
  final TextEditingController searchProduct = TextEditingController();
  List<Customer> customers = [];
  Customer? customer;
  int point = 0; //ประกาศตัวแปรสำหรับ index ตัวแรก
  List<Widget> selectPoint = [];
  String selectedPayment = 'เงินสด';
  LicensePlates? licensePlate;
  List<String> licensePlates = [];
  int setpanel = 0;
  List<Payment> payments = [];
  Payment? payment;
  int keyPanel = 1;
  List<Panel> panels = [];
  Panel? panel;
  int plusOrMinus = 0;
  final oCcy = NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (keyPanel == 0) {
        await getlistPanel();
        setState(() {
          final _products = context.read<ProductController>().products;
          if (_products.isNotEmpty) {
            //final newProduct = Product.fromJson(_products.toJson());
            final newProduct = _products.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
            showProduct.insert(point, newProduct);
            products = showProduct[point];
          }
        });
      } else {
        await getlistCategory();
        setState(() {
          final _products = context.read<ProductController>().products;
          if (_products.isNotEmpty) {
            //final newProduct = Product.fromJson(_products.toJson());
            final newProduct = _products.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
            showProduct.insert(point, newProduct);
            products = showProduct[point];
          }
        });
      }
      await getPayments();
    });
    setState(() {
      selectPoint.add(Text(''));
      showSelect.insert(point, selectproducts);
      final _customer = Customer(null, null, null, null, null, null, null, null, null, null, null, null);
      customers.insert(point, _customer);
    });
  }

  void onSelectPayment(Payment payment) {
    setState(() {
      payment = payment;
      selectedPayment = payment.name!;
    });
  }

  void onSelectPanel(int _panel) async {
    setState(() {
      keyPanel = _panel;
    });
    if (keyPanel == 0) {
      await getlistPanel();
      setState(() {
        final _products = context.read<ProductController>().products;
        List<Product> _newpro = [];
        //LoadingDialog.close(context);
        setState(() {
          _newpro = _products;
          if (_newpro.isNotEmpty) {
            if (selectproducts.isNotEmpty) {
              //selectproducts.clear();
              for (var i = 0; i < selectproducts.length; i++) {
                for (var j = 0; j < _newpro.length; j++) {
                  if (selectproducts[i].product.id == _newpro[j].id) {
                    _newpro[j].weighQty = selectproducts[i].product.newWeighQty!;
                    _newpro[j].newWeighQty = selectproducts[i].product.newWeighQty;
                  } else {}
                }
              }
              final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();

              for (var i = 0; i < selectproducts.length; i++) {
                for (var j = 0; j < newProduct.length; j++) {
                  if (selectproducts[i].product.id == newProduct[j].id) {
                    selectproducts[i].product = newProduct[j];
                  }
                }
              }
              showProduct.insert(point, newProduct);
              showProduct.removeAt(point + 1);
              products = showProduct[point];
            } else {
              final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
              showProduct.insert(point, newProduct);
              showProduct.removeAt(point + 1);
              products = showProduct[point];
            }
          }
        });
        // if (_products.isNotEmpty) {
        //   if (selectproducts.isNotEmpty) {
        //     for (var i = 0; i < selectproducts.length; i++) {
        //       for (var j = 0; j < _products.length; j++) {
        //         if (selectproducts[i].product.id == _products[j].id) {
        //           _products[j].weighQty = selectproducts[i].product.weighQty;
        //           _products[j].newWeighQty = selectproducts[i].product.weighQty;
        //         } else {}
        //       }
        //     }
        //     final newProduct = _products.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
        //     showProduct.insert(point, newProduct);
        //     showProduct.removeAt(point + 1);
        //     products = showProduct[point];
        //   } else {
        //     final newProduct = _products.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
        //     showProduct.insert(point, newProduct);
        //     showProduct.removeAt(point + 1);
        //     products = showProduct[point];
        //   }
        // }
      });
    } else {
      await getlistCategory();
      setState(() {
        final _products = context.read<ProductController>().products;
        List<Product> _newpro = [];
        //LoadingDialog.close(context);
        setState(() {
          _newpro = _products;
          if (_newpro.isNotEmpty) {
            if (selectproducts.isNotEmpty) {
              //selectproducts.clear();
              for (var i = 0; i < selectproducts.length; i++) {
                for (var j = 0; j < _newpro.length; j++) {
                  if (selectproducts[i].product.id == _newpro[j].id) {
                    _newpro[j].weighQty = selectproducts[i].product.newWeighQty!;
                    _newpro[j].newWeighQty = selectproducts[i].product.newWeighQty;
                  } else {}
                }
              }
              final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();

              for (var i = 0; i < selectproducts.length; i++) {
                for (var j = 0; j < newProduct.length; j++) {
                  if (selectproducts[i].product.id == newProduct[j].id) {
                    selectproducts[i].product = newProduct[j];
                  }
                }
              }
              showProduct.insert(point, newProduct);
              showProduct.removeAt(point + 1);
              products = showProduct[point];
            } else {
              final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
              showProduct.insert(point, newProduct);
              showProduct.removeAt(point + 1);
              products = showProduct[point];
            }
          }
        });
        // if (_products.isNotEmpty) {
        //   if (selectproducts.isNotEmpty) {
        //     for (var i = 0; i < selectproducts.length; i++) {
        //       for (var j = 0; j < _products.length; j++) {
        //         if (selectproducts[i].product.id == _products[j].id) {
        //           _products[j].weighQty = selectproducts[i].product.weighQty;
        //           _products[j].newWeighQty = selectproducts[i].product.weighQty;
        //         } else {}
        //       }
        //     }
        //     final newProduct = _products.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
        //     showProduct.insert(point, newProduct);
        //     showProduct.removeAt(point + 1);
        //     products = showProduct[point];
        //   } else {
        //     final newProduct = _products.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
        //     showProduct.insert(point, newProduct);
        //     showProduct.removeAt(point + 1);
        //     products = showProduct[point];
        //   }
        // }
      });
    }
  }

  //ดึงข้อมูล Category
  Future<void> getlistCategory() async {
    try {
      //LoadingDialog.open(context);
      if (customer != null) {
        await context.read<ProductController>().getListCategory(levelId: customer!.level!.id!);
      } else {
        await context.read<ProductController>().getListCategory(levelId: 1);
      }
      final list = context.read<ProductController>().categorized;
      if (!mounted) return;
      //LoadingDialog.close(context);
      setState(() {
        category = list;
        sclectedProduct = list[0];
      });
    } on Exception catch (e) {
      if (!mounted) return;
      //LoadingDialog.close(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: '${e.getMessage}',
          pressYes: () {
            Navigator.pop(context, true);
          },
        ),
      );
    }
  }

  //ดึงข้อมูล Panel
  Future<void> getlistPanel() async {
    try {
      LoadingDialog.open(context);
      if (customer != null) {
        await context.read<ProductController>().getListPanel(levelId: customer!.level!.id!);
      } else {
        await context.read<ProductController>().getListPanel(levelId: 1);
      }
      final list = context.read<ProductController>().panels;
      if (!mounted) return;
      LoadingDialog.close(context);
      setState(() {
        panels = list;
        panel = list[0];
        // final _products = context.read<ProductController>().products;
        // showProduct.insert(point, _products);
      });
    } on Exception catch (e) {
      if (!mounted) return;
      LoadingDialog.close(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: '${e.getMessage}',
          pressYes: () {
            Navigator.pop(context, true);
          },
        ),
      );
    }
  }

  Future<void> getPayments() async {
    try {
      final _payments = await ProductApi.getPaymentMethod();
      if (_payments.isNotEmpty) {
        setState(() {
          payments = _payments;
          payment = payments[0];
          payment!.select = true;
          selectedPayment = payments[0].name!;
        });
      } else {}
      if (!mounted) return;
    } on Exception catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: '${e.getMessage}',
          pressYes: () {
            Navigator.pop(context, true);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 15,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: size.height * 0.08,
                        width: double.infinity,
                        color: kTabColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // SizedBox(
                            //   width: size.width * 0.02,
                            // ),

                            Row(
                              children: [
                                keyPanel == 1
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                                        child: DropdownButton<Category>(
                                          selectedItemBuilder: (e) => category.map<Widget>((item) {
                                            return Center(
                                              child: Text(
                                                item.name!,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                          ),
                                          underline: SizedBox(),
                                          items: category.map<DropdownMenuItem<Category>>((item) {
                                            return DropdownMenuItem<Category>(
                                              value: item,
                                              child: Text(
                                                item.name!,
                                                style: TextStyle(
                                                  fontFamily: 'IBMPlexSansThai',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          value: sclectedProduct,
                                          onChanged: (v) async {
                                            setState(() {
                                              sclectedProduct = v;
                                            });
                                            if (customer != null) {
                                              try {
                                                LoadingDialog.open(context);
                                                final _products = await ProductApi.getProductByLevelAndCategory(levelId: customer!.level!.id!, categoryid: sclectedProduct!.id!);
                                                List<Product> _newpro = [];
                                                LoadingDialog.close(context);
                                                setState(() {
                                                  _newpro = _products;
                                                  if (_newpro.isNotEmpty) {
                                                    if (selectproducts.isNotEmpty) {
                                                      //selectproducts.clear();
                                                      for (var i = 0; i < selectproducts.length; i++) {
                                                        for (var j = 0; j < _newpro.length; j++) {
                                                          if (selectproducts[i].product.id == _newpro[j].id) {
                                                            _newpro[j].weighQty = selectproducts[i].product.newWeighQty!;
                                                            _newpro[j].newWeighQty = selectproducts[i].product.newWeighQty;
                                                          } else {}
                                                        }
                                                      }
                                                      final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();

                                                      for (var i = 0; i < selectproducts.length; i++) {
                                                        for (var j = 0; j < newProduct.length; j++) {
                                                          if (selectproducts[i].product.id == newProduct[j].id) {
                                                            selectproducts[i].product = newProduct[j];
                                                          }
                                                        }
                                                      }
                                                      showProduct.insert(point, newProduct);
                                                      showProduct.removeAt(point + 1);
                                                      products = showProduct[point];
                                                    } else {
                                                      final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
                                                      showProduct.insert(point, newProduct);
                                                      showProduct.removeAt(point + 1);
                                                      products = showProduct[point];
                                                    }
                                                  }
                                                });
                                              } on Exception catch (e) {
                                                if (!mounted) return;
                                                LoadingDialog.close(context);
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialogYes(
                                                    title: 'แจ้งเตือน',
                                                    description: '${e.getMessage}',
                                                    pressYes: () {
                                                      Navigator.pop(context, true);
                                                    },
                                                  ),
                                                );
                                              }
                                            } else {
                                              //await context.read<ProductController>().getProduct(categoryid: sclectedProduct!.id!);
                                              //final _products = await ProductApi.getProduct(id: sclectedProduct!.id!);
                                              final _products = await ProductApi.getProductByLevelAndCategory(levelId: 1, categoryid: sclectedProduct!.id!);
                                              List<Product> _newpro = [];
                                              setState(() {
                                                _newpro = _products;
                                                //_newpro = _panel.products!;
                                                if (_newpro.isNotEmpty) {
                                                  //final newProduct = Product.fromJson(_products.toJson());
                                                  if (selectproducts.isNotEmpty) {
                                                    for (var i = 0; i < selectproducts.length; i++) {
                                                      for (var j = 0; j < _newpro.length; j++) {
                                                        if (selectproducts[i].product.id == _newpro[j].id) {
                                                          _newpro[j].weighQty = selectproducts[i].product.weighQty;
                                                          _newpro[j].newWeighQty = selectproducts[i].product.weighQty;
                                                        } else {}
                                                      }
                                                    }
                                                    final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
                                                    showProduct.insert(point, newProduct);
                                                    showProduct.removeAt(point + 1);
                                                    products = showProduct[point];
                                                  } else {
                                                    final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
                                                    showProduct.insert(point, newProduct);
                                                    showProduct.removeAt(point + 1);
                                                    products = showProduct[point];
                                                  }
                                                }
                                              });
                                            }
                                          },
                                        ),
                                      )
                                    : SizedBox(),
                                keyPanel == 0
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                                        child: DropdownButton<Panel>(
                                          selectedItemBuilder: (e) => panels.map<Widget>((itemPanel) {
                                            return Center(
                                              child: Text(
                                                itemPanel.name!,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                          ),
                                          underline: SizedBox(),
                                          items: panels.map<DropdownMenuItem<Panel>>((itemPanel) {
                                            return DropdownMenuItem<Panel>(
                                              value: itemPanel,
                                              child: Text(
                                                itemPanel.name!,
                                                style: TextStyle(
                                                  fontFamily: 'IBMPlexSansThai',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          value: panel,
                                          onChanged: (v) async {
                                            setState(() {
                                              panel = v;
                                            });
                                            //await context.read<ProductController>().getPanelById(panelId: panel!.id!);
                                            Panel? panels;
                                            if (customer != null) {
                                              final _panel = await ProductApi.getPanelById(panelId: panel!.id!, levelId: customer!.level!.id!);
                                              setState(() {
                                                panels = _panel;
                                              });
                                            } else {
                                              final _panel = await ProductApi.getPanelById(panelId: panel!.id!, levelId: 1);
                                              setState(() {
                                                panels = _panel;
                                              });
                                            }

                                            setState(() {
                                              List<Product> _newpro = [];
                                              _newpro = panels!.products!;
                                              setState(() {
                                                if (_newpro.isNotEmpty) {
                                                  if (selectproducts.isNotEmpty) {
                                                    //selectproducts.clear();
                                                    for (var i = 0; i < selectproducts.length; i++) {
                                                      for (var j = 0; j < _newpro.length; j++) {
                                                        if (selectproducts[i].product.id == _newpro[j].id) {
                                                          _newpro[j].weighQty = selectproducts[i].product.newWeighQty!;
                                                          _newpro[j].newWeighQty = selectproducts[i].product.newWeighQty;
                                                        } else {}
                                                      }
                                                    }
                                                    final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();

                                                    for (var i = 0; i < selectproducts.length; i++) {
                                                      for (var j = 0; j < newProduct.length; j++) {
                                                        if (selectproducts[i].product.id == newProduct[j].id) {
                                                          selectproducts[i].product = newProduct[j];
                                                        }
                                                      }
                                                    }
                                                    showProduct.insert(point, newProduct);
                                                    showProduct.removeAt(point + 1);
                                                    products = showProduct[point];
                                                  } else {
                                                    final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
                                                    showProduct.insert(point, newProduct);
                                                    showProduct.removeAt(point + 1);
                                                    products = showProduct[point];
                                                  }
                                                }
                                              });
                                              //_newpro = _panel.products!;
                                              // if (_newpro.isNotEmpty) {
                                              //   //final newProduct = Product.fromJson(_products.toJson());
                                              //   if (selectproducts.isNotEmpty) {
                                              //     for (var i = 0; i < selectproducts.length; i++) {
                                              //       for (var j = 0; j < _newpro.length; j++) {
                                              //         if (selectproducts[i].product.id == _newpro[j].id) {
                                              //           _newpro[j].weighQty = selectproducts[i].product.weighQty;
                                              //           _newpro[j].newWeighQty = selectproducts[i].product.weighQty;
                                              //         } else {}
                                              //       }
                                              //     }
                                              //     final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
                                              //     showProduct.insert(point, newProduct);
                                              //     showProduct.removeAt(point + 1);
                                              //     products = showProduct[point];
                                              //   } else {
                                              //     final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
                                              //     showProduct.insert(point, newProduct);
                                              //     showProduct.removeAt(point + 1);
                                              //     products = showProduct[point];
                                              //   }
                                              // }
                                            });
                                          },
                                        ),
                                      )
                                    : SizedBox(),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                                  child: Container(
                                    width: size.width * 0.12,
                                    height: size.height * 0.06,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              onSelectPanel(1);
                                            },
                                            child: Container(
                                              width: size.width * 0.05,
                                              height: size.height * 0.05,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: keyPanel == 1 ? Colors.blue : Color.fromARGB(255, 255, 255, 255),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "ทั้งหมด",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'IBMPlexSansThai',
                                                      color: keyPanel == 1 ? Color.fromARGB(255, 255, 255, 255) : Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              onSelectPanel(0);
                                            },
                                            child: Container(
                                              width: size.width * 0.06,
                                              height: size.height * 0.05,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: keyPanel == 0 ? Colors.blue : Color.fromARGB(255, 255, 255, 255)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "พาเนล",
                                                    style: TextStyle(fontSize: 16, fontFamily: 'IBMPlexSansThai', color: keyPanel == 0 ? Color.fromARGB(255, 255, 255, 255) : Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),

                            Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 241, 241, 241),
                                  border: Border(
                                    bottom: BorderSide(color: Colors.black),
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              width: size.width * 0.19,
                              child: TextFormField(
                                controller: searchProduct,
                                style: TextStyle(fontSize: 22),
                                decoration: InputDecoration(
                                  hintText: '',
                                  hintStyle: TextStyle(fontSize: 22),
                                  prefixIcon: GestureDetector(
                                      onTap: () async {
                                        if (searchProduct.text != "") {
                                          if (customer != null) {
                                            try {
                                              LoadingDialog.open(context);
                                              final _products = await ProductApi.searchProducts(
                                                levelId: customer!.level!.id!,
                                                search: searchProduct.text,
                                              );
                                              List<Product> _newpro = [];
                                              LoadingDialog.close(context);
                                              setState(() {
                                                searchProduct.clear();
                                                _newpro = _products;
                                                if (selectproducts.isNotEmpty) {
                                                  for (var i = 0; i < selectproducts.length; i++) {
                                                    for (var j = 0; j < _newpro.length; j++) {
                                                      if (selectproducts[i].product.id == _newpro[j].id) {
                                                        _newpro[j].weighQty = selectproducts[i].product.newWeighQty!;
                                                        _newpro[j].newWeighQty = selectproducts[i].product.newWeighQty;
                                                      } else {}
                                                    }
                                                  }
                                                  final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
                                                  showProduct.insert(point, newProduct);
                                                  showProduct.removeAt(point + 1);
                                                  products = showProduct[point];
                                                } else {
                                                  final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
                                                  showProduct.insert(point, newProduct);
                                                  showProduct.removeAt(point + 1);
                                                  products = showProduct[point];
                                                }
                                              });
                                            } on Exception catch (e) {
                                              if (!mounted) return;
                                              LoadingDialog.close(context);
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialogYes(
                                                  title: 'แจ้งเตือน',
                                                  description: '${e.getMessage}',
                                                  pressYes: () {
                                                    Navigator.pop(context, true);
                                                  },
                                                ),
                                              );
                                            }
                                          } else {
                                            try {
                                              LoadingDialog.open(context);
                                              final _products = await ProductApi.searchProducts(
                                                levelId: 1,
                                                search: searchProduct.text,
                                              );
                                              List<Product> _newpro = [];
                                              LoadingDialog.close(context);
                                              setState(() {
                                                searchProduct.clear();
                                                _newpro = _products;
                                                if (selectproducts.isNotEmpty) {
                                                  for (var i = 0; i < selectproducts.length; i++) {
                                                    for (var j = 0; j < _newpro.length; j++) {
                                                      if (selectproducts[i].product.id == _newpro[j].id) {
                                                        _newpro[j].weighQty = selectproducts[i].product.newWeighQty!;
                                                        _newpro[j].newWeighQty = selectproducts[i].product.newWeighQty;
                                                      } else {}
                                                    }
                                                  }
                                                  final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
                                                  showProduct.insert(point, newProduct);
                                                  showProduct.removeAt(point + 1);
                                                  products = showProduct[point];
                                                } else {
                                                  final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
                                                  showProduct.insert(point, newProduct);
                                                  showProduct.removeAt(point + 1);
                                                  products = showProduct[point];
                                                }
                                              });
                                            } on Exception catch (e) {
                                              if (!mounted) return;
                                              LoadingDialog.close(context);
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialogYes(
                                                  title: 'แจ้งเตือน',
                                                  description: '${e.getMessage}',
                                                  pressYes: () {
                                                    Navigator.pop(context, true);
                                                  },
                                                ),
                                              );
                                            }
                                          }
                                        }
                                      },
                                      child: Icon(Icons.search)),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                              child: GestureDetector(
                                onTap: () async {
                                  if (!mounted) return;
                                  final _customer = await showDialog(
                                    context: context,
                                    builder: (context) => CustomerDialog(),
                                  );
                                  if (_customer != null) {
                                    setState(() {
                                      customers.insert(point, _customer!);
                                      customers.removeAt(point + 1);
                                      customer = customers[point];
                                    });

                                    if (keyPanel == 1) {
                                      try {
                                        LoadingDialog.open(context);
                                        //final _products = await ProductApi.getProductByLevelId(levelId: customer!.level!.id!);
                                        final _products = await ProductApi.getProductByLevelAndCategory(levelId: customer!.level!.id!, categoryid: sclectedProduct!.id!);
                                        final _checkProducts = await ProductApi.getProductByLevelAndCategory(levelId: customer!.level!.id!, categoryid: 0);
                                        List<Product> _newpro = [];
                                        List<Product> _newcheck = [];
                                        LoadingDialog.close(context);
                                        setState(() {
                                          _newpro = _products;
                                          _newcheck = _checkProducts;
                                          if (_newpro.isNotEmpty) {
                                            if (selectproducts.isNotEmpty) {
                                              //selectproducts.clear();
                                              for (var i = 0; i < selectproducts.length; i++) {
                                                for (var j = 0; j < _newpro.length; j++) {
                                                  if (selectproducts[i].product.id == _newpro[j].id) {
                                                    _newpro[j].weighQty = selectproducts[i].product.newWeighQty!;
                                                    _newpro[j].newWeighQty = selectproducts[i].product.newWeighQty;
                                                  } else {}
                                                }
                                              }
                                              for (var i = 0; i < selectproducts.length; i++) {
                                                for (var j = 0; j < _newcheck.length; j++) {
                                                  if (selectproducts[i].product.id == _newcheck[j].id) {
                                                    _newcheck[j].weighQty = selectproducts[i].product.newWeighQty!;
                                                    _newcheck[j].newWeighQty = selectproducts[i].product.newWeighQty;
                                                  } else {}
                                                }
                                              }
                                              final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
                                              final checkProducts = _newcheck.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();

                                              for (var i = 0; i < selectproducts.length; i++) {
                                                for (var j = 0; j < checkProducts.length; j++) {
                                                  if (selectproducts[i].product.id == checkProducts[j].id) {
                                                    selectproducts[i].product = checkProducts[j];
                                                  }
                                                }
                                              }
                                              showProduct.insert(point, newProduct);
                                              showProduct.removeAt(point + 1);
                                              products = showProduct[point];
                                            } else {
                                              final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
                                              showProduct.insert(point, newProduct);
                                              showProduct.removeAt(point + 1);
                                              products = showProduct[point];
                                            }
                                          }
                                        });
                                      } on Exception catch (e) {
                                        if (!mounted) return;
                                        LoadingDialog.close(context);
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialogYes(
                                            title: 'แจ้งเตือน',
                                            description: '${e.getMessage}',
                                            pressYes: () {
                                              Navigator.pop(context, true);
                                            },
                                          ),
                                        );
                                      }
                                    } else {
                                      try {
                                        LoadingDialog.open(context);
                                        //final _products = await ProductApi.getProductByLevelId(levelId: customer!.level!.id!);
                                        final _panel = await ProductApi.getPanelById(panelId: panel!.id!, levelId: customer!.level!.id!);
                                        final _checkProducts = await ProductApi.getProductByLevelAndCategory(levelId: customer!.level!.id!, categoryid: 0);
                                        List<Product> _newpro = [];
                                        List<Product> _newcheck = [];
                                        LoadingDialog.close(context);
                                        setState(() {
                                          _newpro = _panel.products!;
                                          _newcheck = _checkProducts;
                                          if (_newpro.isNotEmpty) {
                                            if (selectproducts.isNotEmpty) {
                                              //selectproducts.clear();
                                              for (var i = 0; i < selectproducts.length; i++) {
                                                for (var j = 0; j < _newpro.length; j++) {
                                                  if (selectproducts[i].product.id == _newpro[j].id) {
                                                    _newpro[j].weighQty = selectproducts[i].product.newWeighQty!;
                                                    _newpro[j].newWeighQty = selectproducts[i].product.newWeighQty;
                                                  } else {}
                                                }
                                              }
                                              for (var i = 0; i < selectproducts.length; i++) {
                                                for (var j = 0; j < _newcheck.length; j++) {
                                                  if (selectproducts[i].product.id == _newcheck[j].id) {
                                                    _newcheck[j].weighQty = selectproducts[i].product.newWeighQty!;
                                                    _newcheck[j].newWeighQty = selectproducts[i].product.newWeighQty;
                                                  } else {}
                                                }
                                              }
                                              final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
                                              final checkProducts = _newcheck.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();

                                              for (var i = 0; i < selectproducts.length; i++) {
                                                for (var j = 0; j < checkProducts.length; j++) {
                                                  if (selectproducts[i].product.id == checkProducts[j].id) {
                                                    selectproducts[i].product = checkProducts[j];
                                                  }
                                                }
                                              }
                                              showProduct.insert(point, newProduct);
                                              showProduct.removeAt(point + 1);
                                              products = showProduct[point];
                                            } else {
                                              final newProduct = _newpro.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, e.newWeighQty)).toList();
                                              showProduct.insert(point, newProduct);
                                              showProduct.removeAt(point + 1);
                                              products = showProduct[point];
                                            }
                                          }
                                        });
                                      } on Exception catch (e) {
                                        if (!mounted) return;
                                        LoadingDialog.close(context);
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialogYes(
                                            title: 'แจ้งเตือน',
                                            description: '${e.getMessage}',
                                            pressYes: () {
                                              Navigator.pop(context, true);
                                            },
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  width: size.width * 0.11,
                                  height: size.height * 0.06,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                                  child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [Text('เพิ่มลูกค้า')],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: size.height * 0.01,
                // ),
                Row(
                  children: [
                    Wrap(
                      children: List.generate(
                          selectPoint.length,
                          (index) => Card(
                                surfaceTintColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: kButtonColor)),
                                child: SizedBox(
                                  width: size.width * 0.12,
                                  height: size.height * 0.055,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              point = index;
                                              selectproducts = showSelect[point];
                                              customer = customers[point];
                                              products = showProduct[point];
                                            });
                                          },
                                          child: Center(
                                              child: customers[index].licensePlate != null && customers[index].licensePlate != ""
                                                  ? Text(
                                                      '${customers[index].licensePlate}',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(color: point == index ? kButtonColor : kTabColor, fontFamily: 'IBMPlexSansThai', fontSize: 16, fontWeight: FontWeight.bold),
                                                    )
                                                  : Text(
                                                      'Order${index + 1}',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(color: point == index ? kButtonColor : kTabColor, fontFamily: 'IBMPlexSansThai', fontSize: 16, fontWeight: FontWeight.bold),
                                                    )),
                                        ),
                                      ),
                                      index != 0
                                          ? Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: size.width * 0.005),
                                                child: InkWell(
                                                    onTap: () async {
                                                      final _ok = await showDialog(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (BuildContext context) {
                                                          return AlertDialogYesNo(
                                                            title: 'แจ้งเตือน',
                                                            description: 'ต้องการลบออร์เดอร์นี้หรือไม่',
                                                            pressYes: () {
                                                              Navigator.pop(context, true);
                                                            },
                                                            pressNo: () {
                                                              Navigator.pop(context, false);
                                                            },
                                                          );
                                                        },
                                                      );
                                                      if (_ok == true) {
                                                        setState(() {
                                                          selectPoint.removeAt(index);
                                                          showSelect.removeAt(index);
                                                          customers.removeAt(index);
                                                          point = 0;
                                                          selectproducts = showSelect[point];
                                                          customer = customers[point];
                                                          products = showProduct[point];
                                                        });
                                                      }
                                                    },
                                                    child: Icon(Icons.cancel)),
                                              ),
                                            )
                                          // IconButton(
                                          //     onPressed: () async {
                                          //       final _ok = await showDialog(
                                          //         context: context,
                                          //         barrierDismissible: false,
                                          //         builder: (BuildContext context) {
                                          //           return AlertDialogYesNo(
                                          //             title: 'แจ้งเตือน',
                                          //             description: 'ต้องการลบออร์เดอร์นี้หรือไม่',
                                          //             pressYes: () {
                                          //               Navigator.pop(context, true);
                                          //             },
                                          //             pressNo: () {
                                          //               Navigator.pop(context, false);
                                          //             },
                                          //           );
                                          //         },
                                          //       );
                                          //       if (_ok == true) {
                                          //         setState(() {
                                          //           selectPoint.removeAt(index);
                                          //           showSelect.removeAt(index);
                                          //           customers.removeAt(index);
                                          //           point = 0;
                                          //           selectproducts = showSelect[point];
                                          //           customer = customers[point];
                                          //         });
                                          //       }
                                          //     },
                                          //     icon: Icon(Icons.cancel))
                                          : Expanded(
                                              flex: 3,
                                              child: SizedBox(
                                                height: size.height * 0.01,
                                                width: size.width * 0.030,
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              )),
                    ),
                    AddCardOrder(
                      onClickAdd: () {
                        setState(() {
                          if (selectPoint.length < 4) {
                            point = point + 1;
                            selectPoint.add(Text(''));
                            final List<SelectProduct> _selectproducts = [];
                            showSelect.insert(point, _selectproducts);
                            selectproducts = showSelect[point];
                            final _customer = Customer(null, null, null, null, null, null, null, null, null, null, null, null);
                            customers.insert(point, _customer);
                            customer = customers[point];
                            final _products = context.read<ProductController>().products;
                            final newProduct = _products.map((e) => Product(e.id, e.code, e.name, e.image, e.stqty, e.category, e.unit, e.price, 0)).toList();
                            for (var i = 0; i < newProduct.length; i++) {
                              newProduct[i].qty = 1;
                              newProduct[i].priceQTY = 0;
                              newProduct[i].weighQty = 0;
                            }
                            showProduct.insert(point, newProduct);
                            products = showProduct[point];
                          }
                        });
                      },
                    ),
                  ],
                ),
                selectPoint.length > 1
                    ? Row(
                        children: [
                          Text(
                            '**กรณที่ออกจากหน้าเมนูนี้ จะทำให้ order ที่สร้างไว้หายไป **',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ],
                      )
                    : SizedBox(),
                SizedBox(
                  height: size.height * 0.01,
                ),
                //ส่วนแสดงสินค้า
                products.isNotEmpty
                    ? SizedBox(
                        height: size.height * 0.80,
                        child: SingleChildScrollView(
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 10,
                                    mainAxisExtent: 140,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: products.length,
                                  itemBuilder: (_, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        if (customer != null) {
                                          if (customer!.name != null) {
                                            setState(() {
                                              plusOrMinus = 0;
                                            });
                                            _myNumber.clear();
                                            final addProduct = await showModalBottomSheet(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10.0),
                                                  topRight: Radius.circular(10.0),
                                                ),
                                              ),
                                              backgroundColor: Colors.white,
                                              context: context,
                                              isScrollControlled: true,
                                              useRootNavigator: true,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  height: size.height * 0.90,
                                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        SizedBox(height: 15),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              '${products[index].name}',
                                                              style: TextStyle(fontSize: 22),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Padding(
                                                          padding: EdgeInsets.all(5),
                                                          child: SizedBox(
                                                            height: size.height * 0.05,
                                                            child: Center(
                                                                child: TextField(
                                                              controller: _myNumber,
                                                              textAlign: TextAlign.center,
                                                              showCursor: false,
                                                              style: TextStyle(fontSize: 30),
                                                              // Disable the default soft keybaord
                                                              keyboardType: TextInputType.none,
                                                              decoration: InputDecoration.collapsed(hintText: '0'),
                                                            )),
                                                          ),
                                                        ),
                                                        Divider(),
                                                        SizedBox(height: 10),
                                                        NumPad(
                                                          buttonSize: size.height * 0.13,
                                                          buttonColor: Colors.grey,
                                                          iconColor: Colors.red,
                                                          controller: _myNumber,
                                                          delete: () {
                                                            if (_myNumber.text != null) {
                                                              if (_myNumber.text.length > 0) {
                                                                _myNumber.text = _myNumber.text.substring(0, _myNumber.text.length - 1);
                                                              }
                                                            }
                                                          },
                                                          plusOrMinus: plusOrMinus,
                                                          status: (value) {
                                                            plusOrMinus = value;
                                                            //print(plusOrMinus);
                                                          },
                                                          // do something with the input numbers
                                                          onSubmit: () {
                                                            //debugPrint('Your code: ${_myNumber.text}');
                                                            try {
                                                              // List<String> check = [];
                                                              // for (var character in _myNumber.text.runes) {
                                                              //   String singleCharacter = String.fromCharCode(character);
                                                              //   print(singleCharacter);
                                                              //   check.add(singleCharacter);
                                                              // }
                                                              //
                                                              //final a = check.contains('+');
                                                              if (selectproducts.isNotEmpty) {
                                                                List<SelectProduct> _selectproducts = [];
                                                                _selectproducts.addAll(selectproducts);
                                                                _selectproducts.retainWhere((selectproduct) {
                                                                  return selectproduct.product.code.toString().contains(showProduct[point][index].code.toString());
                                                                });
                                                                if (_selectproducts.isNotEmpty) {
                                                                  for (var i = 0; i < selectproducts.length; i++) {
                                                                    if (selectproducts[i].product.id == _selectproducts[0].product.id) {
                                                                      if (plusOrMinus == 0) {
                                                                        List<String> substring2 = _myNumber.text.split('+');
                                                                        setState(() {
                                                                          for (var j = 0; j < products.length; j++) {
                                                                            if (products[j].id == _selectproducts[0].product.id) {
                                                                              if (_selectproducts[0].product.weighQty == 0) {
                                                                                products[j].weighQty = _selectproducts[0].product.weighQty + sumQty(substring2);
                                                                                products[j].newWeighQty = products[j].newWeighQty! + products[j].weighQty;
                                                                                selectproducts[i].product.weighQty = products[j].weighQty;
                                                                                selectproducts[i].product.newWeighQty = products[j].newWeighQty;
                                                                              } else {
                                                                                products[j].weighQty = _selectproducts[0].product.weighQty + sumQty(substring2);
                                                                                products[j].newWeighQty = products[j].weighQty;
                                                                                selectproducts[i].product.weighQty = products[j].weighQty;
                                                                                selectproducts[i].product.newWeighQty = products[j].newWeighQty;
                                                                              }
                                                                            } else {}
                                                                          }

                                                                          selectproducts[i].qty = selectproducts[i].qty + sumQty(substring2);
                                                                          selectproducts[i].sumText = selectproducts[i].sumText.toString() + '+' + _myNumber.text;
                                                                        });
                                                                        //break;
                                                                        //Navigator.pop(context, _myNumber.text);
                                                                      } else {
                                                                        List<String> substring2 = _myNumber.text.split('-');
                                                                        setState(() {
                                                                          for (var j = 0; j < products.length; j++) {
                                                                            if (products[j].id == _selectproducts[0].product.id) {
                                                                              if (_selectproducts[0].product.weighQty == 0) {
                                                                                if (sumQty(substring2) > _selectproducts[0].product.weighQty) {
                                                                                  products[j].weighQty = sumQty(substring2) - _selectproducts[0].product.weighQty;
                                                                                  products[j].newWeighQty = products[j].newWeighQty! - products[j].weighQty;
                                                                                } else {
                                                                                  products[j].weighQty = _selectproducts[0].product.weighQty - sumQty(substring2);
                                                                                  products[j].newWeighQty = products[j].newWeighQty! - products[j].weighQty;
                                                                                }
                                                                              } else {
                                                                                if (sumQty(substring2) > _selectproducts[0].product.weighQty) {
                                                                                  products[j].weighQty = sumQty(substring2) - _selectproducts[0].product.weighQty;
                                                                                  products[j].newWeighQty = products[j].weighQty;
                                                                                } else {
                                                                                  products[j].weighQty = _selectproducts[0].product.weighQty - sumQty(substring2);
                                                                                  products[j].newWeighQty = products[j].weighQty;
                                                                                }
                                                                              }

                                                                              selectproducts[i].product.weighQty = products[j].weighQty;
                                                                              selectproducts[i].product.newWeighQty = products[j].newWeighQty;
                                                                            } else {}
                                                                          }
                                                                          selectproducts[i].newQty = selectproducts[i].newQty + sumQty(substring2);
                                                                          selectproducts[i].downText = selectproducts[i].downText.toString() + '-' + _myNumber.text;
                                                                        });
                                                                        //break;
                                                                        //Navigator.pop(context, _myNumber.text);
                                                                      }
                                                                    }
                                                                  }
                                                                  Navigator.pop(context, _myNumber.text);
                                                                } else {
                                                                  String text = _myNumber.text;
                                                                  List<String> substring2 = _myNumber.text.split('+');
                                                                  //debugPrint('${substring2}');
                                                                  setState(() {
                                                                    //products[index].weighQty = sumQty(substring2);
                                                                    showProduct[point][index].weighQty = sumQty(substring2);
                                                                    showProduct[point][index].newWeighQty = sumQty(substring2);
                                                                    final _selectproduct = SelectProduct(products[index], qty: sumQty(substring2), text, '', newQty: 0);
                                                                    selectproducts.add(_selectproduct);
                                                                    showSelect.insert(point, selectproducts);
                                                                    showSelect.removeAt(point + 1);
                                                                  });
                                                                  //inspect(selectproducts);
                                                                  Navigator.pop(context, _myNumber.text);
                                                                }
                                                              } else {
                                                                String text = _myNumber.text;
                                                                List<String> substring2 = _myNumber.text.split('+');
                                                                //debugPrint('${substring2}');
                                                                setState(() {
                                                                  //products[index].weighQty = sumQty(substring2);
                                                                  showProduct[point][index].weighQty = sumQty(substring2);
                                                                  showProduct[point][index].newWeighQty = sumQty(substring2);
                                                                  final _selectproduct = SelectProduct(products[index], qty: sumQty(substring2), text, '', newQty: 0);
                                                                  selectproducts.add(_selectproduct);
                                                                  showSelect.insert(point, selectproducts);
                                                                  showSelect.removeAt(point + 1);
                                                                });
                                                                //inspect(selectproducts);
                                                                Navigator.pop(context, _myNumber.text);
                                                              }
                                                            } catch (e) {
                                                              _myNumber.clear();
                                                              showDialog(
                                                                context: context,
                                                                barrierDismissible: false,
                                                                builder: (BuildContext context) {
                                                                  return AlertDialogYes(
                                                                    title: 'แจ้งเตือน',
                                                                    description: e.toString(),
                                                                    pressYes: () {
                                                                      Navigator.pop(context, true);
                                                                    },
                                                                  );
                                                                },
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialogYes(
                                                  title: 'แจ้งเตือน',
                                                  description: 'โปรดเลือกลูกค้าก่อนทำรายการ',
                                                  pressYes: () {
                                                    Navigator.pop(context, true);
                                                  },
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return AlertDialogYes(
                                                title: 'แจ้งเตือน',
                                                description: 'โปรดเลือกลูกค้าก่อนทำรายการ',
                                                pressYes: () {
                                                  Navigator.pop(context, true);
                                                },
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: GridProduct(
                                        products: products[index],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: size.height * 0.736,
                      ),
                // SizedBox(
                //   height: size.height * 0.14,
                //   child: GridProMotion(),
                // )
              ],
            ),
          ),
        ),
        /////////////////
        ///
        Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: size.height * 0.08,
                    width: size.width * 0.38,
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'รายการชำระ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontFamily: 'IBMPlexSansThai',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  customer != null
                      ? customer!.name != null
                          ? Container(
                              color: Color(0xffE8EAF6),
                              width: size.width * 0.5,
                              height: size.height * 0.09,
                              child: Center(
                                child: ListTile(
                                  dense: true,
                                  isThreeLine: true,
                                  leading: Padding(
                                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                                    child: Icon(
                                      Icons.account_box_sharp,
                                      size: 30,
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Expanded(flex: 7, child: Text('คุณ  ${customer?.name ?? '-'}')),
                                      Expanded(flex: 3, child: Text('คะแนน:  ${customer?.point_balance ?? '0'}')),
                                    ],
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('เบอร์โทร: ${customer?.phoneNumber ?? '-'}'),
                                      Text('ทะเบียนรถ: ${customer?.licensePlate ?? '-'}'),
                                    ],
                                  ),
                                  // trailing: IconButton(
                                  //   onPressed: () async {
                                  //     if (!mounted) return;
                                  //     final _customer = await showDialog(
                                  //       context: context,
                                  //       builder: (context) => EditCustomerDialog(
                                  //         customer: customer!,
                                  //       ),
                                  //     );
                                  //     if (_customer != null) {
                                  //       setState(() {
                                  //         customer!.licensePlate = _customer;
                                  //       });
                                  //       // try {
                                  //       //   final _editCustomer = await ProductApi.editCustomerById(
                                  //       //       cusid: _customer.id,
                                  //       //       code: _customer.code,
                                  //       //       name: _customer.name,
                                  //       //       address: _customer.address,
                                  //       //       levelId: 1,
                                  //       //       licensePlate: _customer.licensePlate,
                                  //       //       phoneNumber: _customer.phoneNumber,
                                  //       //       tax: _customer.tax,
                                  //       //       identityCardId: _customer.identityCard.id);
                                  //       //   if (_editCustomer != null) {
                                  //       //     setState(() {
                                  //       //       customer = _customer;
                                  //       //    });
                                  //       //   }
                                  //       // } on Exception catch (e) {
                                  //       //   showDialog(
                                  //       //     context: context,
                                  //       //     builder: (context) => AlertDialogYes(
                                  //       //       title: 'แจ้งเตือน',
                                  //       //       description: '${e}',
                                  //       //       pressYes: () {
                                  //       //         Navigator.pop(context, true);
                                  //       //       },
                                  //       //     ),
                                  //       //   );
                                  //       // }
                                  //     }
                                  //   },
                                  //   icon: Icon(
                                  //     Icons.edit_square,
                                  //     color: Colors.red,
                                  //     size: 30,
                                  //   ),
                                  // ),
                                ),
                              ),
                            )
                          : SizedBox.shrink()
                      : SizedBox.shrink(),
                  Container(
                      color: Color(0xffE8EAF6),
                      width: size.width * 0.5,
                      height: size.height * 0.06,
                      child: InkWell(
                          onTap: () async {
                            if (selectproducts.isNotEmpty) {
                              bool _ok = await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertDialogYesNo(
                                  title: 'แจ้งเตือน',
                                  description: 'ยืนยันลบรายการทั้งหมด',
                                  pressYes: () {
                                    Navigator.pop(context, true);
                                  },
                                  pressNo: () {
                                    Navigator.pop(context, false);
                                  },
                                ),
                              );
                              if (_ok == true) {
                                setState(() {
                                  for (var i = 0; i < selectproducts.length; i++) {
                                    selectproducts[i].product.weighQty = 0;
                                    selectproducts[i].product.newWeighQty = 0;
                                  }
                                  selectproducts.clear();
                                  for (var i = 0; i < products.length; i++) {
                                    products[i].weighQty = 0;
                                    products[i].newWeighQty = 0;
                                  }
                                });
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Order"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.cancel),
                              ),
                            ],
                          ))),
                  Divider(),
                  selectproducts.isNotEmpty
                      ? Container(
                          color: Color(0xffE8EAF6),
                          height: size.height * 0.465,
                          child: ListView.builder(
                            itemCount: selectproducts.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onLongPress: () async {
                                  final _delete = await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialogYesNo(
                                        title: 'แจ้งเตือน',
                                        description: 'ต้องการลบรายการหรือไม่',
                                        pressYes: () {
                                          Navigator.pop(context, true);
                                        },
                                        pressNo: () {
                                          Navigator.pop(context, false);
                                        },
                                      );
                                    },
                                  );
                                  if (_delete == true) {
                                    setState(() {
                                      selectproducts[index].product.weighQty = 0;
                                      selectproducts[index].product.newWeighQty = 0;
                                      for (var i = 0; i < products.length; i++) {
                                        if (products[i].id == selectproducts[index].product.id) {
                                          products[i].weighQty = 0;
                                          products[i].newWeighQty = 0;
                                        } else {}
                                      }
                                      selectproducts.removeAt(index);
                                    });
                                  }
                                },
                                onTap: () async {
                                  _myNumber.clear();
                                  setState(() {
                                    setState(() {
                                      plusOrMinus = 0;
                                    });
                                  });
                                  final addNewQty = await showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                    context: context,
                                    isScrollControlled: true,
                                    useRootNavigator: true,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Slidable(
                                          key: Key("1"),
                                          endActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) {
                                                  setState(() {
                                                    selectproducts.removeAt(index);
                                                  });
                                                },
                                                backgroundColor: Colors.red,
                                                icon: Icons.delete,
                                              )
                                            ],
                                          ),
                                          child: Container(
                                            height: size.height * 0.90,
                                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(height: 50),
                                                  Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: SizedBox(
                                                      height: size.height * 0.05,
                                                      child: Center(
                                                          child: TextField(
                                                        controller: _myNumber,
                                                        textAlign: TextAlign.center,
                                                        showCursor: false,
                                                        style: TextStyle(fontSize: 30),
                                                        // Disable the default soft keybaord
                                                        keyboardType: TextInputType.none,
                                                        decoration: InputDecoration.collapsed(hintText: '0'),
                                                      )),
                                                    ),
                                                  ),
                                                  Divider(),
                                                  SizedBox(height: 10),
                                                  NumPad(
                                                    buttonSize: size.height * 0.13,
                                                    buttonColor: Colors.grey,
                                                    iconColor: Colors.red,
                                                    controller: _myNumber,
                                                    delete: () {
                                                      if (_myNumber.text != null) {
                                                        if (_myNumber.text.length > 0) {
                                                          _myNumber.text = _myNumber.text.substring(0, _myNumber.text.length - 1);
                                                        }
                                                      }
                                                    },
                                                    plusOrMinus: plusOrMinus,
                                                    status: (value) {
                                                      setState(() {
                                                        plusOrMinus = value;
                                                      });
                                                    },
                                                    onSubmit: () {
                                                      try {
                                                        if (plusOrMinus == 0) {
                                                          List<String> substring2 = _myNumber.text.split('+');
                                                          //inspect(sumQty(substring2));
                                                          setState(() {
                                                            for (var i = 0; i < selectproducts.length; i++) {
                                                              for (var j = 0; j < products.length; j++) {
                                                                if (selectproducts[index].product.id == products[j].id) {
                                                                  if (selectproducts[index].product.weighQty == 0) {
                                                                    products[j].weighQty = selectproducts[index].product.weighQty + sumQty(substring2);
                                                                    products[j].newWeighQty = products[j].newWeighQty! + products[j].weighQty;
                                                                    selectproducts[index].product.weighQty = products[j].weighQty;
                                                                    selectproducts[index].product.newWeighQty = products[j].newWeighQty;
                                                                  } else {
                                                                    products[j].weighQty = selectproducts[index].product.weighQty + sumQty(substring2);
                                                                    products[j].newWeighQty = products[j].weighQty;
                                                                    selectproducts[index].product.weighQty = products[j].weighQty;
                                                                    selectproducts[index].product.newWeighQty = products[j].newWeighQty;
                                                                  }
                                                                  break;
                                                                } else {}
                                                              }
                                                            }
                                                            selectproducts[index].qty = selectproducts[index].qty + sumQty(substring2);
                                                            selectproducts[index].sumText = selectproducts[index].sumText.toString() + '+' + _myNumber.text;
                                                          });
                                                          Navigator.pop(context, _myNumber.text);
                                                        } else {
                                                          List<String> substring2 = _myNumber.text.split('-');
                                                          setState(() {
                                                            for (var i = 0; i < selectproducts.length; i++) {
                                                              for (var j = 0; j < products.length; j++) {
                                                                if (selectproducts[index].product.id == products[j].id) {
                                                                  if (selectproducts[index].product.weighQty == 0) {
                                                                    if (sumQty(substring2) > selectproducts[index].product.weighQty) {
                                                                      products[j].weighQty = sumQty(substring2) - selectproducts[index].product.weighQty;
                                                                      products[j].newWeighQty = products[j].newWeighQty! - products[j].weighQty;
                                                                    } else {
                                                                      products[j].weighQty = selectproducts[index].product.weighQty - sumQty(substring2);
                                                                      products[j].newWeighQty = products[j].newWeighQty! - products[j].weighQty;
                                                                    }
                                                                  } else {
                                                                    if (sumQty(substring2) > selectproducts[index].product.weighQty) {
                                                                      products[j].weighQty = sumQty(substring2) - selectproducts[index].product.weighQty;
                                                                      products[j].newWeighQty = products[j].weighQty;
                                                                    } else {
                                                                      products[j].weighQty = selectproducts[index].product.weighQty - sumQty(substring2);
                                                                      products[j].newWeighQty = products[j].weighQty;
                                                                    }
                                                                  }

                                                                  selectproducts[index].product.weighQty = products[j].weighQty;
                                                                  selectproducts[index].product.newWeighQty = products[j].newWeighQty;
                                                                  break;
                                                                } else {}
                                                              }
                                                            }
                                                            selectproducts[index].newQty = selectproducts[index].newQty + sumQty(substring2);
                                                            selectproducts[index].downText = selectproducts[index].downText.toString() + '-' + _myNumber.text;
                                                          });
                                                          Navigator.pop(context, _myNumber.text);
                                                        }
                                                      } catch (e) {
                                                        _myNumber.clear();
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible: false,
                                                          builder: (BuildContext context) {
                                                            return AlertDialogYes(
                                                              title: 'แจ้งเตือน',
                                                              description: e.toString(),
                                                              pressYes: () {
                                                                Navigator.pop(context, true);
                                                              },
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Card(
                                  color: Color.fromARGB(255, 237, 238, 247),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: size.height * 0.165,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: size.height * 0.005,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(selectproducts[index].product.name ?? ''),
                                              Text('จำนวน'),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(selectproducts[index].sumText ?? ''),
                                              Text("${selectproducts[index].qty.toStringAsFixed(1)} ${selectproducts[index].product.unit?.name ?? ''}"),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('ราคา'),
                                              Text("${selectproducts[index].product.price!.toStringAsFixed(2)} ฿"),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('จำนวนหักลบ'),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("${selectproducts[index].downText}"),
                                              Text("-${selectproducts[index].newQty.toStringAsFixed(1)} ${selectproducts[index].product.unit?.name ?? ''}"),
                                              //Text('${selectproducts[index].product.unit?.name ?? ''}'),
                                            ],
                                          ),
                                          // SizedBox(
                                          //   height: size.height * 0.01,
                                          // ),
                                          //Divider()
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          color: Color(0xffE8EAF6),
                          height: customer == null ? size.height * 0.525 : size.height * 0.465,
                        ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          color: Color.fromARGB(15, 0, 0, 0),
                          height: size.height * 0.01,
                          width: size.width * 1,
                        ),
                        Column(
                          children: [
                            Container(
                              color: Colors.white,
                              height: size.height * 0.238,
                              width: size.width * 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "จำนวนสินค้า",
                                          style: TextStyle(fontFamily: 'IBMPlexSansThai', color: Color(0xFF424242)),
                                        ),
                                        Text(
                                          selectproducts.length.toString(),
                                          // '${sumQTY(selectedItem)} ชิ้น',
                                          style: TextStyle(
                                            fontFamily: 'IBMPlexSansThai',
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ยอดรวมก่อนหัก",
                                          style: TextStyle(fontFamily: 'IBMPlexSansThai', color: Color(0xFF424242)),
                                        ),
                                        Text(
                                          oCcy.format(sum(selectproducts)),
                                          // '${sumPrice(selectedItem)} ฿',
                                          style: TextStyle(
                                            fontFamily: 'IBMPlexSansThai',
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "จำนวนหักลบ",
                                          style: TextStyle(fontFamily: 'IBMPlexSansThai', color: Color(0xFF424242)),
                                        ),
                                        Text(
                                          '${sumNewQty(selectproducts)}',
                                          style: TextStyle(
                                            fontFamily: 'IBMPlexSansThai',
                                          ),
                                        )
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ชำระทั้งหมด",
                                          style: TextStyle(fontFamily: 'IBMPlexSansThai', color: Color(0xFF424242)),
                                        ),
                                        Text(
                                          "${oCcy.format(sumTotal(selectproducts))} ฿",
                                          style: TextStyle(
                                            fontFamily: 'IBMPlexSansThai',
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        if (!mounted) return;
                                        if (selectproducts.isNotEmpty) {
                                          final _payment = await showDialog(
                                            context: context,
                                            builder: (context) => SelectPaymentType(
                                              payments: payments,
                                            ),
                                          );
                                          if (_payment != null) {
                                            setState(() {
                                              payment = _payment;
                                              selectedPayment = payment!.name!;
                                            });
                                            if (payment!.name == 'พร้อมเพย์') {
                                              if (customer != null) {
                                                if (customer!.code == '00000' || customer!.code == '000000') {
                                                  final _account = await showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context) => AddDetailPayment(),
                                                  );
                                                  if (_account != null) {
                                                    Account? account;
                                                    if (selectproducts.isNotEmpty) {
                                                      try {
                                                        LoadingDialog.open(context);
                                                        setState(() {
                                                          account = _account;
                                                          if (orderItems.isEmpty) {
                                                            for (var i = 0; i < selectproducts.length; i++) {
                                                              OrderItems _orderItem = OrderItems(
                                                                selectproducts[i].product.id,
                                                                selectproducts[i].qty,
                                                                selectproducts[i].product.price,
                                                                double.parse(sumTotal(selectproducts).toStringAsFixed(2)),
                                                                [],
                                                                null,
                                                                selectproducts[i].newQty,
                                                                selectproducts[i].downText,
                                                                selectproducts[i].sumText,
                                                              );
                                                              orderItems.add(_orderItem);
                                                            }
                                                          } else {}
                                                        });
                                                        final _order = await ProductApi.ceateOrders(
                                                            shiftId: 2,
                                                            total: double.parse(sumTotal(selectproducts).toStringAsFixed(2)),
                                                            orderItems: orderItems,
                                                            customerId: customer!.id!,
                                                            licensePlate: customer!.licensePlate,
                                                            selectedPayment: selectedPayment,
                                                            bankName: account!.bank!,
                                                            accountName: account!.accountName!,
                                                            accountNumber: account!.accountNumber!,
                                                            paymentMethodId: payment!.id!);
                                                        if (!mounted) return;
                                                        LoadingDialog.close(context);
                                                        if (_order != null) {
                                                          final printsuccess = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => PrintPreview(
                                                                        customer: customer!,
                                                                        order: _order,
                                                                        selectProduct: selectproducts,
                                                                        selectedPayment: selectedPayment,
                                                                      )));
                                                          if (printsuccess == true) {
                                                            setState(() {
                                                              for (var i = 0; i < selectproducts.length; i++) {
                                                                selectproducts[i].product.weighQty = 0;
                                                                selectproducts[i].product.newWeighQty = 0;
                                                              }
                                                              selectproducts.clear();
                                                              for (var i = 0; i < products.length; i++) {
                                                                products[i].weighQty = 0;
                                                                products[i].newWeighQty = 0;
                                                              }
                                                              customer = null;
                                                              customers[point] = Customer(null, null, null, null, null, null, null, null, null, null, null, null);
                                                              orderItems.clear();
                                                            });
                                                          } else {
                                                            orderItems.clear();
                                                          }
                                                        } else {
                                                          if (!mounted) return;
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) => AlertDialogYes(
                                                              title: 'แจ้งเตือน',
                                                              description: 'ข้อมูลจากตอบกลับจาก api ไม่ถูกต้อง',
                                                              pressYes: () {
                                                                Navigator.pop(context, true);
                                                              },
                                                            ),
                                                          );
                                                        }
                                                      } on Exception catch (e) {
                                                        if (!mounted) return;
                                                        LoadingDialog.close(context);
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) => AlertDialogYes(
                                                            title: 'แจ้งเตือน',
                                                            description: '${e.getMessage}',
                                                            pressYes: () {
                                                              Navigator.pop(context, true);
                                                            },
                                                          ),
                                                        );
                                                      }
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialogYes(
                                                          title: 'แจ้งเตือน',
                                                          description: 'ยังไม่ได้เลือกสินค้า',
                                                          pressYes: () {
                                                            Navigator.pop(context, true);
                                                          },
                                                        ),
                                                      );
                                                    }
                                                  }
                                                } else {
                                                  //กรณีที่ลูกค้าไม่ได้เป็นขาจร
                                                  if (customer!.customerBanks!.isNotEmpty) {
                                                    final _account = await showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) => CustomerPayment(
                                                        customerBanks: customer!.customerBanks,
                                                        customerId: customer!.id!,
                                                      ),
                                                    );
                                                    if (_account != null) {
                                                      if (selectproducts.isNotEmpty) {
                                                        try {
                                                          LoadingDialog.open(context);
                                                          setState(() {
                                                            if (orderItems.isEmpty) {
                                                              for (var i = 0; i < selectproducts.length; i++) {
                                                                OrderItems _orderItem = OrderItems(
                                                                  selectproducts[i].product.id,
                                                                  selectproducts[i].qty,
                                                                  selectproducts[i].product.price,
                                                                  double.parse(sumTotal(selectproducts).toStringAsFixed(2)),
                                                                  [],
                                                                  null,
                                                                  selectproducts[i].newQty,
                                                                  selectproducts[i].downText,
                                                                  selectproducts[i].sumText,
                                                                );
                                                                orderItems.add(_orderItem);
                                                              }
                                                            } else {}
                                                          });
                                                          final _order = await ProductApi.ceateOrders(
                                                              shiftId: 2,
                                                              total: double.parse(sumTotal(selectproducts).toStringAsFixed(2)),
                                                              orderItems: orderItems,
                                                              customerId: customer!.id!,
                                                              licensePlate: customer!.licensePlate,
                                                              selectedPayment: selectedPayment,
                                                              bankName: _account.bank!,
                                                              accountName: _account.accountName!,
                                                              accountNumber: _account.accountNumber!,
                                                              paymentMethodId: payment!.id!);
                                                          if (!mounted) return;
                                                          LoadingDialog.close(context);
                                                          if (_order != null) {
                                                            final printsuccess = await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => PrintPreview(
                                                                          customer: customer!,
                                                                          order: _order,
                                                                          selectProduct: selectproducts,
                                                                          selectedPayment: selectedPayment,
                                                                        )));
                                                            if (printsuccess == true) {
                                                              setState(() {
                                                                for (var i = 0; i < selectproducts.length; i++) {
                                                                  selectproducts[i].product.weighQty = 0;
                                                                  selectproducts[i].product.newWeighQty = 0;
                                                                }
                                                                selectproducts.clear();
                                                                for (var i = 0; i < products.length; i++) {
                                                                  products[i].weighQty = 0;
                                                                  products[i].newWeighQty = 0;
                                                                }
                                                                customer = null;
                                                                customers[point] = Customer(null, null, null, null, null, null, null, null, null, null, null, null);
                                                                orderItems.clear();
                                                              });
                                                            } else {
                                                              orderItems.clear();
                                                            }
                                                          } else {
                                                            if (!mounted) return;
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => AlertDialogYes(
                                                                title: 'แจ้งเตือน',
                                                                description: 'ข้อมูลจากตอบกลับจาก api ไม่ถูกต้อง',
                                                                pressYes: () {
                                                                  Navigator.pop(context, true);
                                                                },
                                                              ),
                                                            );
                                                          }
                                                        } on Exception catch (e) {
                                                          if (!mounted) return;
                                                          LoadingDialog.close(context);
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) => AlertDialogYes(
                                                              title: 'แจ้งเตือน',
                                                              description: '${e.getMessage}',
                                                              pressYes: () {
                                                                Navigator.pop(context, true);
                                                              },
                                                            ),
                                                          );
                                                        }
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) => AlertDialogYes(
                                                            title: 'แจ้งเตือน',
                                                            description: 'ยังไม่ได้เลือกสินค้า',
                                                            pressYes: () {
                                                              Navigator.pop(context, true);
                                                            },
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  } else {
                                                    final _ok = await showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialogYesNo(
                                                        title: 'แจ้งเตือน',
                                                        description: 'ลูกค้ารายนี้ยังไม่มีข้อมูลธนาคาร ต้องการเพิ่มธนาคารหรือไม่',
                                                        pressYes: () {
                                                          Navigator.pop(context, true);
                                                        },
                                                        pressNo: () {
                                                          Navigator.pop(context, false);
                                                        },
                                                      ),
                                                    );
                                                    if (_ok == true) {
                                                      final _newbank = await showDialog(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (context) => Addcustomerbank(
                                                          customerId: customer!.id!,
                                                        ),
                                                      );
                                                      if (_newbank != null) {
                                                        if (selectproducts.isNotEmpty) {
                                                          try {
                                                            LoadingDialog.open(context);
                                                            setState(() {
                                                              if (orderItems.isEmpty) {
                                                                for (var i = 0; i < selectproducts.length; i++) {
                                                                  OrderItems _orderItem = OrderItems(
                                                                    selectproducts[i].product.id,
                                                                    selectproducts[i].qty,
                                                                    selectproducts[i].product.price,
                                                                    double.parse(sumTotal(selectproducts).toStringAsFixed(2)),
                                                                    [],
                                                                    null,
                                                                    selectproducts[i].newQty,
                                                                    selectproducts[i].downText,
                                                                    selectproducts[i].sumText,
                                                                  );
                                                                  orderItems.add(_orderItem);
                                                                }
                                                              } else {}
                                                            });
                                                            final _order = await ProductApi.ceateOrders(
                                                                shiftId: 2,
                                                                total: double.parse(sumTotal(selectproducts).toStringAsFixed(2)),
                                                                orderItems: orderItems,
                                                                customerId: customer!.id!,
                                                                licensePlate: customer!.licensePlate,
                                                                selectedPayment: selectedPayment,
                                                                bankName: _newbank.bank!,
                                                                accountName: _newbank.accountName!,
                                                                accountNumber: _newbank.accountNumber!,
                                                                paymentMethodId: payment!.id!);
                                                            if (!mounted) return;
                                                            LoadingDialog.close(context);
                                                            if (_order != null) {
                                                              final printsuccess = await Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => PrintPreview(
                                                                            customer: customer!,
                                                                            order: _order,
                                                                            selectProduct: selectproducts,
                                                                            selectedPayment: selectedPayment,
                                                                          )));
                                                              if (printsuccess == true) {
                                                                setState(() {
                                                                  for (var i = 0; i < selectproducts.length; i++) {
                                                                    selectproducts[i].product.weighQty = 0;
                                                                    selectproducts[i].product.newWeighQty = 0;
                                                                  }
                                                                  selectproducts.clear();
                                                                  for (var i = 0; i < products.length; i++) {
                                                                    products[i].weighQty = 0;
                                                                    products[i].newWeighQty = 0;
                                                                  }
                                                                  customer = null;
                                                                  customers[point] = Customer(null, null, null, null, null, null, null, null, null, null, null, null);
                                                                  orderItems.clear();
                                                                });
                                                              } else {
                                                                orderItems.clear();
                                                              }
                                                            } else {
                                                              if (!mounted) return;
                                                              showDialog(
                                                                context: context,
                                                                builder: (context) => AlertDialogYes(
                                                                  title: 'แจ้งเตือน',
                                                                  description: 'ข้อมูลจากตอบกลับจาก api ไม่ถูกต้อง',
                                                                  pressYes: () {
                                                                    Navigator.pop(context, true);
                                                                  },
                                                                ),
                                                              );
                                                            }
                                                          } on Exception catch (e) {
                                                            if (!mounted) return;
                                                            LoadingDialog.close(context);
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => AlertDialogYes(
                                                                title: 'แจ้งเตือน',
                                                                description: '${e.getMessage}',
                                                                pressYes: () {
                                                                  Navigator.pop(context, true);
                                                                },
                                                              ),
                                                            );
                                                          }
                                                        } else {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) => AlertDialogYes(
                                                              title: 'แจ้งเตือน',
                                                              description: 'ยังไม่ได้เลือกสินค้า',
                                                              pressYes: () {
                                                                Navigator.pop(context, true);
                                                              },
                                                            ),
                                                          );
                                                        }
                                                      } else {}
                                                    }
                                                  }
                                                }
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialogYes(
                                                    title: 'แจ้งเตือน',
                                                    description: 'ยังไม่ได้เลือกลูกค้า',
                                                    pressYes: () {
                                                      Navigator.pop(context, true);
                                                    },
                                                  ),
                                                );
                                              }
                                            } else {
                                              if (customer != null) {
                                                if (selectproducts.isNotEmpty) {
                                                  try {
                                                    LoadingDialog.open(context);
                                                    setState(() {
                                                      if (orderItems.isEmpty) {
                                                        for (var i = 0; i < selectproducts.length; i++) {
                                                          OrderItems _orderItem = OrderItems(
                                                            selectproducts[i].product.id,
                                                            selectproducts[i].qty,
                                                            selectproducts[i].product.price,
                                                            double.parse(sumTotal(selectproducts).toStringAsFixed(2)),
                                                            [],
                                                            null,
                                                            selectproducts[i].newQty,
                                                            selectproducts[i].downText,
                                                            selectproducts[i].sumText,
                                                          );
                                                          orderItems.add(_orderItem);
                                                        }
                                                      } else {}
                                                    });
                                                    //List<LicensePlates> _licensePlate = customer!.licensePlates!.where((element) => element.select == true).toList();
                                                    //inspect(_licensePlate);
                                                    final _order = await ProductApi.ceateOrders(
                                                        shiftId: 2,
                                                        total: double.parse(sumTotal(selectproducts).toStringAsFixed(2)),
                                                        orderItems: orderItems,
                                                        customerId: customer!.id!,
                                                        licensePlate: customer!.licensePlate,
                                                        selectedPayment: selectedPayment,
                                                        bankName: '',
                                                        accountName: '',
                                                        accountNumber: '',
                                                        paymentMethodId: payment!.id!);
                                                    if (!mounted) return;
                                                    LoadingDialog.close(context);
                                                    if (_order != null) {
                                                      final printsuccess = await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => PrintPreview(
                                                                    customer: customer!,
                                                                    order: _order,
                                                                    selectProduct: selectproducts,
                                                                    selectedPayment: selectedPayment,
                                                                  )));
                                                      if (printsuccess == true) {
                                                        setState(() {
                                                          for (var i = 0; i < selectproducts.length; i++) {
                                                            selectproducts[i].product.weighQty = 0;
                                                            selectproducts[i].product.newWeighQty = 0;
                                                          }
                                                          selectproducts.clear();
                                                          for (var i = 0; i < products.length; i++) {
                                                            products[i].weighQty = 0;
                                                            products[i].newWeighQty = 0;
                                                          }
                                                          customer = null;
                                                          customers[point] = Customer(null, null, null, null, null, null, null, null, null, null, null, null);
                                                          orderItems.clear();
                                                        });
                                                      } else {
                                                        orderItems.clear();
                                                      }
                                                    } else {
                                                      if (!mounted) return;
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialogYes(
                                                          title: 'แจ้งเตือน',
                                                          description: 'ข้อมูลจากตอบกลับจาก api ไม่ถูกต้อง',
                                                          pressYes: () {
                                                            Navigator.pop(context, true);
                                                          },
                                                        ),
                                                      );
                                                    }
                                                  } on Exception catch (e) {
                                                    if (!mounted) return;
                                                    LoadingDialog.close(context);
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialogYes(
                                                        title: 'แจ้งเตือน',
                                                        description: '${e.getMessage}',
                                                        pressYes: () {
                                                          Navigator.pop(context, true);
                                                        },
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialogYes(
                                                      title: 'แจ้งเตือน',
                                                      description: 'ยังไม่ได้เลือกสินค้า',
                                                      pressYes: () {
                                                        Navigator.pop(context, true);
                                                      },
                                                    ),
                                                  );
                                                }
                                              } else {
                                                //if(!mounted)return;
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialogYes(
                                                    title: 'แจ้งเตือน',
                                                    description: 'ยังไม่ได้เลือกลูกค้า',
                                                    pressYes: () {
                                                      Navigator.pop(context, true);
                                                    },
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: selectproducts.isNotEmpty ? Colors.blue : Colors.grey),
                                        height: size.height * 0.05,
                                        width: size.width * 0.28,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Opacity(
                                                opacity: 0.8,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 5, top: 3),
                                                  child: Text(
                                                    'ชำระเงิน ',
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'IBMPlexSansThai', color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
    //});
  }
}

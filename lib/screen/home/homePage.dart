import 'dart:developer';

import 'package:banjuipos/constants.dart';
import 'package:banjuipos/models/category.dart';
import 'package:banjuipos/models/customer.dart';
import 'package:banjuipos/models/licenseplates.dart';
import 'package:banjuipos/models/orderitems.dart';
import 'package:banjuipos/models/payment.dart';
import 'package:banjuipos/models/selectproduct.dart';
import 'package:banjuipos/screen/home/printPreview.dart';
import 'package:banjuipos/screen/home/services/productApi.dart';
import 'package:banjuipos/screen/home/services/productController.dart';
import 'package:banjuipos/screen/home/widgets/AddCardOrder.dart';
import 'package:banjuipos/screen/home/widgets/CardOrder.dart';
import 'package:banjuipos/screen/home/widgets/CustomerDialog.dart';
import 'package:banjuipos/screen/home/widgets/EditCustomerDialog.dart';
import 'package:banjuipos/screen/home/widgets/GridProduct.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:banjuipos/widgets/LoadingDialog.dart';
import 'package:banjuipos/widgets/NumPad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
  List<OrderItems> orderItems = [];
  final TextEditingController _myNumber = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getlistCategory();
      await getPayments();
    });
    setState(() {
      selectPoint.add(Text(''));
      showSelect.insert(point, selectproducts);
      final _customer = Customer(null, null, null, null, null, null, null, null, null);
      customers.insert(point, _customer);
    });
  }

  void onSelectPayment(Payment payment) {
    setState(() {      
      payment = payment;
      selectedPayment = payment.name!;
    });
  }

  //ดึงข้อมูล Category
  Future<void> getlistCategory() async {
    try {
      LoadingDialog.open(context);
      await context.read<ProductController>().getListCategory();
      final list = context.read<ProductController>().categorized;
      if (!mounted) return;
      LoadingDialog.close(context);
      setState(() {
        category = list;
        sclectedProduct = list[0];
      });
    } on Exception catch (e) {
      if (!mounted) return;
      LoadingDialog.close(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: '${e}',
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
          description: '${e}',
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
    return Consumer<ProductController>(builder: (context, productController, child) {
      final products = productController.products;
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
                                  Padding(
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
                                        await context.read<ProductController>().getProduct(categoryid: sclectedProduct!.id!);
                                      },
                                    ),
                                  ),
                                  // Container(
                                  //   width: size.width * 0.11,
                                  //   height: size.height * 0.06,
                                  //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(2.0),
                                  //     child: Row(
                                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //       children: [
                                  //         InkWell(
                                  //           onTap: () {
                                  //             onSelectPayment('เงินสด');
                                  //           },
                                  //           child: Container(
                                  //             width: size.width * 0.05,
                                  //             height: size.height * 0.05,
                                  //             decoration: BoxDecoration(
                                  //               borderRadius: BorderRadius.circular(8),
                                  //               color: selectedPayment == 'เงินสด' ? Colors.blue : Color.fromARGB(255, 255, 255, 255),
                                  //             ),
                                  //             child: Row(
                                  //               mainAxisAlignment: MainAxisAlignment.center,
                                  //               children: [
                                  //                 Text(
                                  //                   "เงินสด",
                                  //                   style: TextStyle(
                                  //                     fontSize: 16,
                                  //                     fontFamily: 'IBMPlexSansThai',
                                  //                     color: selectedPayment == 'เงินสด' ? Color.fromARGB(255, 255, 255, 255) : Colors.black,
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         InkWell(
                                  //           onTap: () {
                                  //             onSelectPayment('เงินโอน');
                                  //           },
                                  //           child: Container(
                                  //             width: size.width * 0.05,
                                  //             height: size.height * 0.05,
                                  //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: selectedPayment == 'เงินโอน' ? Colors.blue : Color.fromARGB(255, 255, 255, 255)),
                                  //             child: Row(
                                  //               mainAxisAlignment: MainAxisAlignment.center,
                                  //               children: [
                                  //                 Text(
                                  //                   "เงินโอน",
                                  //                   style:
                                  //                       TextStyle(fontSize: 16, fontFamily: 'IBMPlexSansThai', color: selectedPayment == 'เงินโอน' ? Color.fromARGB(255, 255, 255, 255) : Colors.black),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         )
                                  //       ],
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),

                              GestureDetector(
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
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    children: [
                      Wrap(
                        children: List.generate(
                            selectPoint.length,
                            (index) => CardOrder(
                                  pointIndex: index,
                                  color: point == index ? kButtonColor : kTabColor,
                                  //licensePlate: licensePlate,
                                  onClickText: () {
                                    setState(() {
                                      point = index;
                                      selectproducts = showSelect[point];
                                      customer = customers[point];
                                    });
                                  },
                                  onClickIcon: () {
                                    setState(() {
                                      selectPoint.removeAt(index);
                                      showSelect.removeAt(index);
                                      customers.removeAt(index);
                                      point = 0;
                                      selectproducts = showSelect[point];
                                      customer = customers[point];
                                    });
                                  },
                                )),
                      ),
                      AddCardOrder(
                        onClickAdd: () {
                          setState(() {
                            if (selectPoint.length < 5) {
                              point = point + 1;
                              selectPoint.add(Text(''));
                              final List<SelectProduct> _selectproducts = [];
                              showSelect.insert(point, _selectproducts);
                              selectproducts = showSelect[point];
                              final _customer = Customer(null, null, null, null, null, null, null, null, null);
                              customers.insert(point, _customer);
                              customer = customers[point];
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
                          height: size.height * 0.736,
                          child: SingleChildScrollView(
                            child: SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 10,
                                      mainAxisExtent: 150,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount: products.length,
                                    itemBuilder: (_, index) {
                                      return GestureDetector(
                                        onTap: () async {
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
                                                            String text = _myNumber.text;
                                                            List<String> substring2 = _myNumber.text.split('+');
                                                            //debugPrint('${substring2}');
                                                            setState(() {
                                                              final _selectproduct = SelectProduct(products[index], qty: sumQty(substring2), text, newQty: 0);
                                                              selectproducts.add(_selectproduct);
                                                              showSelect.insert(point, selectproducts);
                                                              showSelect.removeAt(point + 1);
                                                            });
                                                            //inspect(selectproducts);
                                                            Navigator.pop(context, _myNumber.text);
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
                          payments.isNotEmpty
                              ? Container(
                                  width: size.width * 0.14,
                                  height: size.height * 0.06,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Row(
                                      children: List.generate(
                                        payments.length,
                                        (index) => InkWell(
                                          onTap: () {
                                            onSelectPayment(payments[index]);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: size.width *0.001),
                                            child: Container(
                                              width: size.width * 0.065,
                                              height: size.height * 0.05,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: selectedPayment == payments[index].name ? Colors.blue : Color.fromARGB(255, 255, 255, 255),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${payments[index].name}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'IBMPlexSansThai',
                                                      color: selectedPayment == payments[index].name ? Color.fromARGB(255, 255, 255, 255) : Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox()
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
                                    title: Text('คุณ ${customer?.name ?? '-'}'),
                                    subtitle: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('เบอร์โทร ${customer?.phoneNumber ?? '-'}'),
                                        Text('ทะเบียนรถ ${customer?.licensePlate ?? '-'}'),
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
                                    //       try {
                                    //         final _editCustomer = await ProductApi.editCustomerById(
                                    //             cusid: _customer.id,
                                    //             code: _customer.code,
                                    //             name: _customer.name,
                                    //             address: _customer.address,
                                    //             levelId: 1,
                                    //             licensePlate: _customer.licensePlate,
                                    //             phoneNumber: _customer.phoneNumber,
                                    //             tax: _customer.tax,
                                    //             identityCardId: _customer.identityCard.id);
                                    //         if (_editCustomer != null) {
                                    //           setState(() {
                                    //             customer = _customer;
                                    //           });
                                    //         }
                                    //       } on Exception catch (e) {
                                    //         showDialog(
                                    //           context: context,
                                    //           builder: (context) => AlertDialogYes(
                                    //             title: 'แจ้งเตือน',
                                    //             description: '${e}',
                                    //             pressYes: () {
                                    //               Navigator.pop(context, true);
                                    //             },
                                    //           ),
                                    //         );
                                    //       }
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
                            onTap: () {
                              setState(() {
                                selectproducts.clear();
                              });
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
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    selectproducts.isNotEmpty
                        ? SizedBox(
                            height: size.height * 0.5,
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
                                        selectproducts.removeAt(index);
                                      });
                                    }
                                  },
                                  onTap: () async {
                                    _myNumber.clear();
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
                                                      onSubmit: () {
                                                        try {
                                                          //String text = _myNumber.text;
                                                          //String text = _myNumber.text;
                                                          List<String> substring2 = _myNumber.text.split('+');
                                                          setState(() {
                                                            selectproducts[index].newQty = sumQty(substring2);
                                                          });
                                                          Navigator.pop(context, _myNumber.text);
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
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: size.height * 0.17,
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
                                                Text("${selectproducts[index].qty} ${selectproducts[index].product.unit?.name ?? ''}"),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('ราคา'),
                                                Text("${selectproducts[index].product.price} ฿"),
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
                                                Text("${selectproducts[index].newQty}"),
                                                Text('${selectproducts[index].product.unit?.name ?? ''}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.01,
                                            ),
                                            Divider()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox(
                            height: size.height * 0.48,
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
                                height: size.height * 0.24,
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
                                            sum(selectproducts).toStringAsFixed(2),
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
                                            "${sumTotal(selectproducts).toStringAsFixed(2)} ฿",
                                            style: TextStyle(
                                              fontFamily: 'IBMPlexSansThai',
                                            ),
                                          )
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
                                          if (customer != null) {
                                            if (selectproducts.isNotEmpty && customer!.licensePlate != null) {
                                              try {
                                                LoadingDialog.open(context);
                                                setState(() {
                                                  for (var i = 0; i < selectproducts.length; i++) {
                                                    OrderItems _orderItem = OrderItems(selectproducts[i].product.id, selectproducts[i].qty, selectproducts[i].product.price!,
                                                        double.parse(sum(selectproducts).toStringAsFixed(2)), [], null, selectproducts[i].newQty);
                                                    orderItems.add(_orderItem);
                                                  }
                                                });
                                                List<LicensePlates> _licensePlate = customer!.licensePlates!.where((element) => element.select == true).toList();
                                                //inspect(_licensePlate);
                                                final _order = await ProductApi.ceateOrders(
                                                  shiftId: 2,
                                                  total: double.parse(sum(selectproducts).toStringAsFixed(2)),
                                                  orderItems: orderItems,
                                                  customerId: customer!.id!,
                                                  licensePlateId: _licensePlate[0].id!,
                                                  selectedPayment: selectedPayment,
                                                  paymentMethodId: payment!.id!
                                                );
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
                                                      selectproducts.clear();
                                                      customer = null;
                                                      customers[point] = Customer(null, null, null, null, null, null, null, null, null);
                                                      orderItems.clear();
                                                    });
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
                                                    description: '${e}',
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
    });
  }
}

import 'dart:developer';

import 'package:banjuipos/models/customer.dart';
import 'package:banjuipos/screen/home/services/productApi.dart';
import 'package:banjuipos/screen/home/services/productController.dart';
import 'package:banjuipos/screen/home/widgets/SelectLicensePlate.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:banjuipos/widgets/InputTextFormField.dart';
import 'package:banjuipos/widgets/InputsearchText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerDialog extends StatefulWidget {
  const CustomerDialog({super.key});

  @override
  State<CustomerDialog> createState() => _CustomerDialogState();
}

class _CustomerDialogState extends State<CustomerDialog> {
  bool add = false;
  int? select;
  final GlobalKey<FormState> _addcustomerFormKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController licensePlate = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController code = TextEditingController();
  final TextEditingController tax = TextEditingController();
  final TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getlistCustomer();
    });
  }

  //ดึงข้อมูล Customer
  Future<void> getlistCustomer() async {
    try {
      await context.read<ProductController>().getListCustomer();
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
      List<Customer> customer = productController.customers;
      return AlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'รายชื่อลูกค้า',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'IBMPlexSansThai',
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (add == true) {
                        add = false;
                      } else {
                        add = true;
                      }
                    });
                  },
                  child: add == false
                      ? Icon(
                          Icons.add,
                          color: Colors.grey,
                        )
                      : Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                )
              ],
            ),
            Divider(),
          ],
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
        content: Container(
          height: size.height * 0.8,
          width: size.width * 0.5,
          child: SingleChildScrollView(
            child: Column(
              children: [
                add == true
                    ? Form(
                        key: _addcustomerFormKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                              child: Row(
                                children: [
                                  Text(
                                    'ชื่อ',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            InputTextFormField(
                              size: size,
                              controller: name,
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                              child: Row(
                                children: [
                                  Text(
                                    'เบอร์โทร',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            InputTextFormField(
                              size: size,
                              controller: phoneNumber,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                              child: Row(
                                children: [
                                  Text(
                                    'ทะเบียนรถ',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            InputTextFormField(
                              size: size,
                              controller: licensePlate,
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                              child: Row(
                                children: [
                                  Text(
                                    'ที่อยู่',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            InputTextFormField(
                              size: size,
                              controller: address,
                              maxLines: 2,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                              child: Row(
                                children: [
                                  Text(
                                    'รหัส',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            InputTextFormField(
                              size: size,
                              controller: code,
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                              child: Row(
                                children: [
                                  Text(
                                    'เลขบัตรประชาชน',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            InputTextFormField(
                              size: size,
                              controller: tax,
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: size.height * 0.30,
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: customer.isNotEmpty
                            ? Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.width * 0.01),
                                    child: InputSearchText(
                                        size: size,
                                        controller: search,
                                        onPressed: () async {
                                          await context.read<ProductController>().searchListCustomer(search: search.text);
                                          setState(() {});
                                        },
                                        onChanged: (value) {
                                          if (value == '' || value == null) {
                                            getlistCustomer();
                                          }
                                        }),
                                  ),
                                  Container(
                                    height: size.height * 0.65,
                                    child: ListView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: customer.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                            child: Card(
                                              margin: EdgeInsets.zero,
                                              elevation: 0,
                                              color: Color.fromARGB(255, 238, 234, 234),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  color: Color.fromARGB(255, 238, 231, 231),
                                                  width: 2.0,
                                                ),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(color: Colors.white),
                                                //decoration: BoxDecoration(color: read ? Colors.white : Color.fromRGBO(0, 0, 0, 0.1), borderRadius: BorderRadius.circular(8)),
                                                child: ListTile(
                                                  title: Text(
                                                    'ชื่อ ${customer[index].name}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  subtitle: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'เบอร์โทร ${customer[index].phoneNumber}',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        'ทะเบียนรถ ${customer[index].licensePlate}',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        'ที่อยู่ ${customer[index].address}',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  trailing: select == index
                                                      ? Icon(
                                                          Icons.check_circle,
                                                          color: Colors.green,
                                                        )
                                                      : Icon(
                                                          Icons.keyboard_arrow_right,
                                                        ),
                                                  onTap: () async {
                                                    setState(() {
                                                      select = index;
                                                    });
                                                    final _licensePlate = await showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) => SelectLicensePlate(licenseplates: customer[index].licensePlates!,),
                                                    );
                                                    if (_licensePlate != null) {
                                                      setState(() {
                                                        customer[index].licensePlate = _licensePlate.licensePlate;
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      )
              ],
            ),
          ),
        ),
        actions: [
          add == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: TextButton(
                        //textColor: Color(0xFF6200EE),
                        onPressed: () async {
                          try {
                            final addCustomer =
                                await ProductApi.addCustomer(name: name.text, phoneNumber: phoneNumber.text, licensePlate: licensePlate.text, address: address.text, code: code.text, tax: tax.text);
                            if (addCustomer != null) {
                              setState(() {
                                add = false;
                              });
                              getlistCustomer();
                            }
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
                        },
                        child: Text(
                          'บันทึก',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: TextButton(
                        //textColor: Color(0xFF6200EE),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'ยกเลิก',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        //textColor: Color(0xFF6200EE),
                        onPressed: () {
                          if (select != null) {
                            Navigator.pop(context, customer[select!]);
                          }
                        },
                        child: Text(
                          'ตกลง',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      );
    });
  }
}

import 'dart:developer';

import 'package:banjuipos/models/customer.dart';
import 'package:banjuipos/models/nameprefix.dart';
import 'package:banjuipos/screen/home/services/productApi.dart';
import 'package:banjuipos/screen/home/services/productController.dart';
import 'package:banjuipos/screen/home/widgets/SelectLicensePlate.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:banjuipos/widgets/InputTextFormField.dart';
import 'package:banjuipos/widgets/InputsearchText.dart';
import 'package:banjuipos/widgets/LoadingDialog.dart';
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
  NamePrefix? namePrefix;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getlistNamePrefix();
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

  //ดึงข้อมูล คำนำหน้า
  Future<void> getlistNamePrefix() async {
    try {
      LoadingDialog.open(context);
      await context.read<ProductController>().getListNamePrefix();
      setState(() {
        namePrefix = context.read<ProductController>().namePrefixs[0];
      });
      if (!mounted) return;
      LoadingDialog.close(context);
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<ProductController>(builder: (context, productController, child) {
      List<Customer> customer = productController.showCustomers;
      final namePrefixs = productController.namePrefixs;
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
            SizedBox(
              height: size.height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.width * 0.01),
              child: InputSearchText(
                  size: size,
                  controller: search,
                  onPressed: () async {
                    await context.read<ProductController>().searchListCustomer(search: search.text);
                    setState(() {});
                  },
                  onChanged: (value) async {
                    if (value == '' || value == null) {
                      getlistCustomer();
                    }
                  }),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                namePrefixs.isNotEmpty
                                    ? Container(
                                        width: size.width * 0.24,
                                        height: size.height * 0.08,
                                        color: Color.fromARGB(255, 241, 241, 241),
                                        // decoration: BoxDecoration(
                                        //   color: Colors.white,
                                        //   border: Border(
                                        //     bottom: BorderSide(width: 2, color: Color(0xff78909C)),
                                        //   ),
                                        // ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<NamePrefix>(
                                            hint: Padding(
                                              padding: const EdgeInsets.only(left: 10, right: 10),
                                              child: Text("คำนำหน้า"),
                                            ),
                                            isExpanded: true,
                                            items: namePrefixs
                                                .map((NamePrefix item) => DropdownMenuItem<NamePrefix>(
                                                      value: item,
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            item.name!,
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                            value: namePrefix,
                                            onChanged: (v) {
                                              setState(() {
                                                namePrefix = v;
                                              });
                                            },
                                            underline: SizedBox(),
                                            dropdownColor: Colors.white,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                InputTextFormField(
                                  size: size,
                                  width: 0.24,
                                  controller: name,
                                  maxLines: 1,
                                  hintText: 'ชื่อ',
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InputTextFormField(
                                  size: size,
                                  width: 0.24,
                                  controller: phoneNumber,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  hintText: 'เบอร์โทร',
                                ),
                                InputTextFormField(
                                  size: size,
                                  width: 0.24,
                                  controller: licensePlate,
                                  maxLines: 1,
                                  hintText: 'ทะเบียนรถ',
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InputTextFormField(
                                  size: size,
                                  width: 0.24,
                                  controller: code,
                                  maxLines: 1,
                                  hintText: 'รหัส',
                                ),
                                InputTextFormField(
                                  size: size,
                                  width: 0.24,
                                  controller: tax,
                                  maxLines: 1,
                                  hintText: 'เลขบัตรประชาชน',
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            InputTextFormField(
                              size: size,
                              width: 0.50,
                              controller: address,
                              maxLines: 4,
                              hintText: 'ที่อยู่',
                            ),
                            SizedBox(
                              height: size.height * 0.30,
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                        children: [
                          customer.isNotEmpty
                              ? Column(
                                  children: [
                                    ListView.builder(
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
                                                    'ชื่อ ${customer[index].name} [${customer[index].code}]',
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
                                                      if (customer[index].licensePlate != '' || customer[index].licensePlate != null) {
                                                        
                                                      }
                                                    });
                                                    final _licensePlate = await showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) => SelectLicensePlate(
                                                        licenseplates: customer[index].licensePlates!,
                                                        customerId: customer[index].id!,
                                                      ),
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
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        ],
                      )),                
              ],
            ),
          ),
        ),
        actions: [
          //Divider(),
          add == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: TextButton(
                        //textColor: Color(0xFF6200EE),
                        onPressed: () async {
                          try {
                            final addCustomer = await ProductApi.addCustomer(
                              name: name.text,
                              phoneNumber: phoneNumber.text,
                              licensePlate: licensePlate.text,
                              address: address.text,
                              code: code.text,
                              tax: tax.text,
                              prefixId: namePrefix!.id!,
                            );
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

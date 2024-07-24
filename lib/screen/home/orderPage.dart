import 'dart:developer';

import 'package:banjuipos/extension/formattedMessage.dart';
import 'package:banjuipos/screen/home/rePrintOrder.dart';
import 'package:banjuipos/screen/home/services/productController.dart';
import 'package:banjuipos/screen/home/widgets/TableOrder.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:banjuipos/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int p0 = 1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getlistOrder();
    });
  }

  // Future<void> getlistOrder() async {
  //   try {
  //     LoadingDialog.open(context);
  //     await context.read<ProductController>().getListOrder(start: 0, length: 10000);
  //     if (!mounted) return;
  //     LoadingDialog.close(context);
  //   } on Exception catch (e) {
  //     if (!mounted) return;
  //     LoadingDialog.close(context);
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialogYes(
  //         title: 'แจ้งเตือน',
  //         description: '${e.getMessage}',
  //         pressYes: () {
  //           Navigator.pop(context, true);
  //         },
  //       ),
  //     );
  //   }
  // }

  Future<void> getlistOrder() async {
    try {
      LoadingDialog.open(context);
      await context.read<ProductController>().getListOrder();
      if (!mounted) return;
      LoadingDialog.close(context);
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<ProductController>(builder: (context, productController, child) {
      final orders = productController.orders;
      return Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 15,
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.08,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Color(0xFFECEFF1)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("รายการคำสั่งซื้อ"),
                          )
                        ],
                      ),
                    ),
                    orders.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TableOrder(
                              orders: orders,
                              reciveOrder: (value) async {
                                //inspect(value);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => RePrintOrder(orderId: value.id)));
                              },
                            ))
                        : SizedBox(
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.35,
                                  ),
                                  Text(
                                    'ไม่พบรายการออร์เดอร์',
                                    style: TextStyle(fontSize: 22, color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

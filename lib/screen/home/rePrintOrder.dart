import 'dart:convert';

import 'package:banjuipos/constants.dart';
import 'package:banjuipos/models/order.dart';
import 'package:banjuipos/screen/home/services/printerService.dart';
import 'package:banjuipos/screen/home/services/productApi.dart';
import 'package:banjuipos/screen/home/services/productController.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:banjuipos/widgets/LoadingDialog.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class RePrintOrder extends StatefulWidget {
  RePrintOrder({super.key, required this.orderId});
  int orderId;

  @override
  State<RePrintOrder> createState() => _RePrintOrderState();
}

class _RePrintOrderState extends State<RePrintOrder> {
  String ipAddress = '';
  GlobalKey globalKey = GlobalKey();
  Uint8List? pngBytesPag;
  Uint8List? pngBytes;
  String? bs64;
  final controller = ScreenshotController();
  Order? order;
  DateFormat formatter = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getIpAddress();
      await getOrderById();
    });
  }

  //ดึงข้อมูล Order
  Future<void> getOrderById() async {
    try {
      LoadingDialog.open(context);
      final _order = await ProductApi.getOrderById(id: widget.orderId);
      if (_order != null) {
        setState(() {
          order = _order;
        });
      }
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

  Future getIpAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString('ipAddress');
    setState(() {
      if (ip != null) {
        ipAddress = ip;
      } else {
        ipAddress = '';
        showDialog(
          context: context,
          builder: (context) => AlertDialogYes(
            title: 'แจ้งเตือน',
            description: 'ยังไม่ได้ตั้งค่าปริ๊นเตอร์โปรดตั้งค่าปริ๊นเตอร์ก่อนทำการปริ๊น',
            pressYes: () {
              Navigator.pop(context, true);
            },
          ),
        );
      }
    });
  }

  Future<Uint8List?> _capturePng() async {
    final orientation = MediaQuery.of(context).orientation;
    try {
      print('inside');
      RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: orientation == Orientation.portrait ? 1.5 : 1.25);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      pngBytes = byteData!.buffer.asUint8List();
      bs64 = base64Encode(pngBytes!);
      // ui.Codec codec = await ui.instantiateImageCodec(pngBytes!);
      // ui.FrameInfo frame;
      // frame = await codec.getNextFrame();
      //await PrinterService().print(widget.customer, _finalListProducts, pngBytes!);
      print(pngBytes);
      print(bs64);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  Future<void> printReceipt(
    NetworkPrinter printer,
    Uint8List bill,
    //Uint8List customer
  ) async {
    await PrinterService.printPOS(printer, bill);
  }

  Future<void> printOrder(
    Uint8List bill,
    //Uint8List customer
  ) async {
    const PaperSize paper = PaperSize.mm80;
    // final profiles = await CapabilityProfile.getAvailableProfiles();
    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    final printer = NetworkPrinter(paper, profile);
    // inspect(profiles);

    final PosPrintResult res = await printer.connect(ipAddress, port: 9100);

    if (res == PosPrintResult.success) {
      // DEMO RECEIPT
      // await printDemoReceipt(printer, refNo);
      // TEST PRINT
      // await testTicket(refNo: refNo);
      //await printReceipt(printer, bill, customer);
      await printReceipt(printer, bill);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ปริ๊นใบเสร็จย้อนหลัง',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.02,
            ),
            order != null ? Center(child: previewBill()) : SizedBox(),
            SizedBox(
              height: size.height * 0.06,
            ),
            Center(
              child: InkWell(
                onTap: () async {
                  //printOrder(bill, customer);
                  if (ipAddress != '') {
                    await _capturePng();
                    if (pngBytes != null) {
                      printOrder(pngBytes!);
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialogYes(
                        title: 'แจ้งเตือน',
                        description: 'ยังไม่ได้ตั้งค่าปริ๊นเตอร์โปรดตั้งค่าปริ๊นเตอร์ก่อนทำการปริ๊น',
                        pressYes: () {
                          Navigator.pop(context, true);
                        },
                      ),
                    );
                  }

                  //Navigator.pop(context, true);
                },
                child: Card(
                  color: ipAddress != '' ? Colors.blue : Colors.grey,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: SizedBox(
                    width: size.width * 0.33,
                    height: size.height * 0.06,
                    child: Center(
                        child: Text(
                      'ปริ๊นใบเสร็จ',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
          ],
        ),
      ),
    );
  }

  Widget previewBill() {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    DateFormat format = DateFormat("dd-MM-yyyy HH:mm:ss");

    return Screenshot(
      controller: controller,
      child: SizedBox(
        width: orientation == Orientation.portrait ? size.width * 0.43 : size.width * 0.33,
        child: RepaintBoundary(
          key: globalKey,
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ใบรับซื้อ',
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('-----------------------------------------------------------------------'),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'เลขที่เอกสาร',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     Text(
                            //       'วันที่ออกเอกสาร',
                            //       style: TextStyle(fontSize: 20),
                            //     ),
                            //   ],
                            // ),
                            Row(
                              children: [
                                Text(
                                  'พนักงาน',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${order!.orderNo}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     Text(
                            //       '${formatter.format(order!.orderDate!)}',
                            //       style: TextStyle(fontSize: 20),
                            //     ),
                            //   ],
                            // ),
                            Row(
                              children: [
                                Text(
                                  '${order!.user?.firstName ?? ''}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'ข้อมูลลูกค้า :',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(children: [
                  Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'ผู้ติดต่อ',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'เบอร์ผู้ติดต่อ',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                              children: [
                                Text(
                                  'รหัสลูกค้า',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          Row(
                            children: [
                              Text(
                                'ทะเบียนรถ',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'วันที่ปริ๊นใบเสร็จ',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${order!.customer?.name ?? ''}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${order!.customer?.phoneNumber ?? ''}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                              children: [
                                Text(
                                  '${order!.customer?.code ?? ''}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          Row(
                            children: [
                              Text(
                                '${order!.licensePlate ?? ''}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${format.format(order!.orderDate!)}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      )),
                ]),
                Row(
                  children: [
                    Text('-----------------------------------------------------------------------'),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'รายการ',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'จำนวน',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'ราคา',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'ราคารวม',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
                Row(
                  children: [
                    Text('-----------------------------------------------------------------------'),
                  ],
                ),
                order != null
                    ? order!.orderItems!.isNotEmpty
                        ? Column(
                            children: List.generate(
                              order!.orderItems!.length,
                              (index) => Row(
                                children: [
                                  Expanded(
                                      flex: 5,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${order!.orderItems![index].product?.name ?? ''}',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '${order!.orderItems![index].uptext ?? '-'}',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            'ลบ  ${order!.orderItems![index].downtext ?? '-'}',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${order!.orderItems![index].quantity!.toStringAsFixed(2)}',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${order!.orderItems![index].dequantity!.toStringAsFixed(2)}',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${order!.orderItems![index].price}',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${sumOneRowPrint(order!.orderItems![index]).toStringAsFixed(2)}',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              order!.orderItems![index].dequantity != 0.0
                                                  ? Text(
                                                      '${sumOneRowReprint(order!.orderItems![index]).toStringAsFixed(2)}',
                                                      style: TextStyle(fontSize: 20),
                                                    )
                                                  : Text(
                                                      '0.00',
                                                      style: TextStyle(fontSize: 20),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          )
                        : SizedBox()
                    : SizedBox(),
                Row(
                  children: [
                    Text('-----------------------------------------------------------------------'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ยอดสุทธิ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${sumNewOneColumn(order!.orderItems!).toStringAsFixed(2)} ฿',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('-----------------------------------------------------------------------'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ประเภทการชำระ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${order!.paymentMethod?.name ?? ''}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('-----------------------------------------------------------------------'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

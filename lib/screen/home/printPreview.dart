import 'package:banjuipos/constants.dart';
import 'package:banjuipos/models/customer.dart';
import 'package:banjuipos/models/order.dart';
import 'package:banjuipos/models/selectproduct.dart';
import 'package:banjuipos/screen/home/services/printerService.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'dart:ui' as ui;
import 'dart:convert';

import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class PrintPreview extends StatefulWidget {
  PrintPreview({super.key, required this.customer, required this.order, required this.selectProduct, required this.selectedPayment});
  List<SelectProduct> selectProduct;
  Order order;
  Customer customer;
  String selectedPayment;

  @override
  State<PrintPreview> createState() => _PrintPreviewState();
}

class _PrintPreviewState extends State<PrintPreview> {
  String ipAddress = '';
  GlobalKey globalKey = GlobalKey();
  Uint8List? pngBytesPag;
  Uint8List? pngBytes;
  String? bs64;
  final controller = ScreenshotController();
  bool printBinded = false;

  @override
  void initState() {
    super.initState();
    getIpAddress();
    print(widget.customer.phoneNumber);
  }

  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  void _printerInitail() {
    _bindingPrinter().then((bool? isBind) async {
      // final size = await SunmiPrinter.paperSize();
      // final version = await SunmiPrinter.printerVersion();
      // final serial = await SunmiPrinter.serialNumber();
      final printer = await SunmiPrinter.getPrinterStatus();

      setState(() {
        printBinded = isBind!;
        // serialNumber = serial;
        // printerVersion = version;
        // paperSize = size;
      });
      if (printer != PrinterStatus.NORMAL) {
        _printerInitail();
      }
      print('printBinded : $printBinded');
      // print('serialNumber : $serialNumber');
      // print('printerVersion : $printerVersion');
      // print('paperSize : $paperSize');
      print('printer : $printer');
    });
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
          'รายการปริ๊น',
          style: TextStyle(color: Colors.black),
        ),
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
            previewBill(),
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
                      Navigator.pop(context, true);
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
            )
          ],
        ),
      ),
    );
  }

  Widget previewBill() {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    DateFormat formatter = DateFormat('dd-MM-yyyy');

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
                    Text('ใบรับซื้อ'),
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
                                Text('เลขที่เอกสาร'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('วันที่ออกเอกสาร'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('พนักงาน'),
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
                                Text('${widget.order.orderNo}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('${formatter.format(widget.order.orderDate!)}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('${widget.order.user?.firstName ?? ''}'),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
                Row(
                  children: [
                    Text('ข้อมูลลูกค้า :'),
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
                                Text('ชื่อผู้ติดต่อหน้าร้าน'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('เบอร์ผู้ติดต่อ'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('ทะเบียนรถ'),
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
                                Text('${widget.order.customer?.name ?? ''}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('${widget.order.customer?.phoneNumber ?? ''}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('${widget.order.licensePlate?.licensePlate ?? ''}'),
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
                Row(
                  children: [
                    Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('รายการ'),
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
                                Text('จำนวน'),
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
                                Text('ราคา'),
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
                                Text('ราคารวม'),
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
                widget.order != null
                    ? widget.order.orderItems!.isNotEmpty
                        ? Column(
                            children: List.generate(
                              widget.order.orderItems!.length,
                              (index) => Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text('${widget.order.orderItems![index].product?.name ?? ''}'),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.02,
                                          )
                                        ],
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${widget.order.orderItems![index].quantity}'),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '- ${widget.order.orderItems![index].dequantity}',
                                                style: TextStyle(fontSize: 14),
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
                                              Text('${widget.order.orderItems![index].price}'),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.02,
                                          )
                                        ],
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text('${sumOneRowReprint(widget.order.orderItems![index])}'),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.02,
                                          )
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
                    Text('ยอดสุทธิ'),
                    Text('${widget.order.grandTotal} ฿'),
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
                    Text('ประเภทการชำระ'),
                    Text('${widget.order.paymentMethod?.name ?? ''}'),
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

import 'package:banjuipos/constants.dart';
import 'package:banjuipos/models/customer.dart';
import 'package:banjuipos/models/order.dart';
import 'package:banjuipos/models/selectproduct.dart';
import 'package:banjuipos/screen/home/services/printerService.dart';
import 'package:banjuipos/screen/home/services/productApi.dart';
import 'package:banjuipos/screen/home/widgets/ViewPrint100Widget.dart';
import 'package:banjuipos/screen/home/widgets/ViewPrintWidget.dart';
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
  DateTime date = DateTime.now();
  final oCcy = NumberFormat("#,##0.00", "en_US");
  bool printing = false;

  @override
  void initState() {
    super.initState();
    getIpAddress();
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
            onPressed: () async {
              if (printing == true) {
                Navigator.pop(context, true);
              } else {
                if (!mounted) return;
                final ok = await showDialog(
                  context: context,
                  builder: (context) => AlertDialogYesNo(
                    title: 'แจ้งเตือน',
                    description: 'คุณยังไม่ได้ปริ๊นใบเสร็จ หากออกจากหน้านี้จะเป็นการ ยกเลิกคำสั่งซื้อ ต้องการยกเลิกคำสั่งซื้อหรือไม่',
                    pressYes: () {
                      Navigator.pop(context, true);
                    },
                    pressNo: () {
                      Navigator.pop(context, false);
                    },
                  ),
                );
                if (ok == true) {
                  final cancel = await ProductApi.cancelOrder(id: widget.order.id);
                  if (cancel != null) {
                    Navigator.pop(context, false);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialogYes(
                        title: 'แจ้งเตือน',
                        description: 'เกิดข้อผิดพลาด ข้อมูลออร์เดอร์ไม่ถูกต้อง หรือไม่มีข้อมูลออร์เดอร์นี้',
                        pressYes: () {
                          Navigator.pop(context, true);
                        },
                      ),
                    );
                  }
                }
              }
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
                      //printOrder(pngBytes!);
                      setState(() {
                        printing = true;
                      });
                      //Navigator.pop(context, true);
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
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    DateFormat format = DateFormat("dd-MM-yyyy HH:mm:ss");

    return Screenshot(
      controller: controller,
      child: ipAddress != ''
      ? ipAddress != '192.168.1.100'
        ?ViewPrint100Widget(orientation: orientation, size: size, globalKey: globalKey, widget: widget, format: format, oCcy: oCcy)
        :ViewPrintWidget(orientation: orientation, size: size, globalKey: globalKey, widget: widget, format: format, oCcy: oCcy)
      :SizedBox(),
    );
  }
}

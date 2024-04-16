

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class PrinterService {
  const PrinterService();

  static Future printPOS(
    NetworkPrinter printer,
    Uint8List bill,
    // Uint8List customer,    
  ) async {
    // const title = 'Orders';
    // final title = utf8.encode("รายการจัดส่งสินค้า");
    // const store = 'LaoXiangHeng';
    // const tel = 'Tel. 02-225-2387\nTel. 02-225-1587';
    // final customername = 'name: ${customer.name}';
    // final customerlicensePage = 'licensecar: ${customer.licensePage}';
    // final _refNo = 'refNo: $refNo';
    // final date = 'Date: ${DateTime.now().formatTo('dd LLL y HH:mm')}';
    // final imgSrc = Image.asset('assets/images/logo44.png');
    // final ByteData data = await rootBundle.load('assets/images/logo44.png');
    // final Uint8List bytes = data.buffer.asUint8List();
    // final Image? image = decodeImage(bytes);
    final Uint8List bytes2 = bill.buffer.asUint8List();
    final Image? image2 = decodeImage(bytes2);
    // final Uint8List bytes3 = customer.buffer.asUint8List();
    // final Image? image3 = decodeImage(bytes3);

// Using `ESC *`

    // printer.image(image!);
    // printer.image(image3!, align: PosAlign.left);
    printer.image(image2!);
    // printer.text(title, styles: PosStyles(align: PosAlign.center));
    // printer.text(store);
    // printer.text(tel);
    // printer.hr();
    // printer.text(customername);
    // printer.text(customerlicensePage);
    // // printer.text(date);
    // printer.text(_refNo);
    // printer.hr();
    // printer.text('Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    // printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ', styles: PosStyles(codeTable: 'CP1252'));
    // printer.text('Special 2: blåbærgrød', styles: PosStyles(codeTable: 'CP1252'));

    // printer.text('Bold text', styles: PosStyles(bold: true));
    // printer.text('Reverse text', styles: PosStyles(reverse: true));
    // printer.text('Underlined text', styles: PosStyles(underline: true), linesAfter: 1);
    // printer.text('Align left', styles: PosStyles(align: PosAlign.left));
    // printer.text('Align center', styles: PosStyles(align: PosAlign.center));
    // printer.text('Align right', styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    // printer.text('Text size 200%',
    //     styles: PosStyles(
    //       height: PosTextSize.size2,
    //       width: PosTextSize.size2,
    //     ));
    // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    // printer.barcode(Barcode.upcA(barData));
    printer.feed(1);
    printer.cut();
    printer.disconnect();
  }


  Future<void> print(Uint8List bill) async {
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.exitTransactionPrint(true);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.line();
    await SunmiPrinter.printImage(bill);

    await SunmiPrinter.line();
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.exitTransactionPrint(true);
  }



}
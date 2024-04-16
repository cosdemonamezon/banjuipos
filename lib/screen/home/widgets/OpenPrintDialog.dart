import 'package:banjuipos/constants.dart';
import 'package:flutter/material.dart';

class OpenPrintDialog extends StatelessWidget {
  const OpenPrintDialog({
    super.key,
    required this.size,
    required this.pressOk,
    required this.pressCancel,
  });

  final Size size;
  final VoidCallback pressOk;
  final VoidCallback pressCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
      title: Column(
        children: [
          Image.asset(
            'assets/icons/Receipt.png',
            scale: 10,
          ),
          Text(
            'เปิดใช้งานการพิมพ์ใบเสร็จ',
            style: TextStyle(
              fontFamily: 'IBMPlexSansThai',
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'โปรดตรวจสอบและเตรียมกระดาษพิมพ์ให้เรียบร้อย',
            style: TextStyle(
              fontFamily: 'IBMPlexSansThai',
            ),
          ),
          Text(
            'ก่อนการเปิดใช้งานฟังก์ชันการพิมพ์',
            style: TextStyle(
              fontFamily: 'IBMPlexSansThai',
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            GestureDetector(
              onTap: pressCancel,
              child: Card(
                //color: Colors.blue,
                surfaceTintColor: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: kButtonColor)),

                child: Container(
                  width: size.width * 0.18,
                  height: size.height * 0.06,
                  child: Center(
                      child: Text(
                    'ยกเลิก',
                    style: TextStyle(
                      color: kButtonColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IBMPlexSansThai',
                    ),
                  )),
                ),
              ),
            ),
            GestureDetector(
              onTap: pressOk,
              child: Card(
                color: Colors.blue,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Container(
                  width: size.width * 0.18,
                  height: size.height * 0.06,
                  child: Center(
                      child: Text(
                    'ยืนยัน',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:banjuipos/constants.dart';
import 'package:flutter/material.dart';

class AddCardOrder extends StatelessWidget {
  AddCardOrder({super.key, required this.onClickAdd});
  VoidCallback onClickAdd;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onClickAdd,
      child: Card(
        surfaceTintColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: kButtonColor)),
        color: Colors.white,
        child: SizedBox(
          width: size.width * 0.07,
          height: size.height * 0.055,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              Text(
                'เพิ่ม',
                style: TextStyle(color: kButtonColor, fontFamily: 'IBMPlexSansThai', fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

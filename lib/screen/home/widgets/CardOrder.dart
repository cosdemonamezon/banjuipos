import 'package:banjuipos/constants.dart';
import 'package:flutter/material.dart';

class CardOrder extends StatelessWidget {
  CardOrder({super.key, required this.pointIndex, required this.onClickIcon, required this.onClickText, required this.color, this.licensePlate});
  int pointIndex;
  VoidCallback onClickText;
  VoidCallback onClickIcon;
  Color color;
  String? licensePlate;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: kButtonColor)),
      child: SizedBox(
        width: size.width * 0.096,
        height: size.height * 0.055,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onClickText,
              child: Center(
                  child: licensePlate == null || licensePlate == ''
                  ?Text(
                'Order${pointIndex + 1}',
                style: TextStyle(color: color, fontFamily: 'IBMPlexSansThai', fontSize: 16, fontWeight: FontWeight.bold),
              )
              :Text(
                '${licensePlate}',
                style: TextStyle(color: color, fontFamily: 'IBMPlexSansThai', fontSize: 14, fontWeight: FontWeight.bold),
              )),
            ),
            pointIndex != 0
            ?IconButton(onPressed: onClickIcon, icon: Icon(Icons.cancel))
            :SizedBox(
              height: size.height * 0.01,
              width: size.width * 0.032,
            )
          ],
        ),
      ),
    );
  }
}

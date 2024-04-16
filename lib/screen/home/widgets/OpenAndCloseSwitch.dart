import 'package:flutter/material.dart';

class OpenAndCloseSwitch extends StatelessWidget {
  OpenAndCloseSwitch(
      {super.key,
      required this.size,
      required this.open,
      required this.showTextClose,
      required this.showTextOpen,
      required this.onChanged});

  final Size size;
  final bool open;
  final String showTextOpen;
  final String showTextClose;
  Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size.height * 0.06,
        width: size.width * 0.15,
        child: Row(
          children: [
            Expanded(
              child: Switch(
                value: open,
                onChanged: onChanged,
                activeColor: Colors.blue,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
              ),
            ),
            open == true
                ? Expanded(
                    child: Text(
                    showTextOpen,
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansThai',
                    ),
                  ))
                : Expanded(
                    child: Text(
                    showTextClose,
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansThai',
                    ),
                  ))
          ],
        ));
  }
}

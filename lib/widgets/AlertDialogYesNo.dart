import 'package:banjuipos/constants.dart';
import 'package:flutter/material.dart';

class AlertDialogYesNo extends StatelessWidget {
  AlertDialogYesNo({Key? key, required this.description, required this.pressYes, required this.title, required this.pressNo}) : super(key: key);
  final String title, description;
  final VoidCallback pressYes;
  final VoidCallback pressNo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kTextButtonColor,
      title: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      content: Text(
        description,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: TextButton(
                //textColor: Color(0xFF6200EE),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return kSecondaryColor;
                      }
                      return kSecondaryColor;
                    },
                  ),
                ),
                onPressed: pressNo,
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return kTextDateColor;
                      }
                      return kTextDateColor;
                    },
                  ),
                ),
                onPressed: pressYes,
                child: Text(
                  'ตกลง',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AlertDialogYes extends StatelessWidget {
  AlertDialogYes({Key? key, required this.description, required this.pressYes, required this.title}) : super(key: key);
  final String title, description;
  final VoidCallback pressYes;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kTextButtonColor,
      title: Center(
          child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
        ),
      )),
      content: Text(
        description,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      actions: [
        Center(
          child: TextButton(
            //textColor: Color(0xFF6200EE),
            onPressed: pressYes,
            child: Text(
              'ตกลง',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kButtoncolor),
            ),
          ),
        ),
      ],
    );
  }
}

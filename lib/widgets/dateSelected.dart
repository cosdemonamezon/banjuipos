import 'package:banjuipos/constants.dart';
import 'package:flutter/material.dart';

class DateSelected extends StatelessWidget {
  DateSelected({
    super.key,
    required this.dateController,
    required this.press,
  });

  final TextEditingController dateController;
  VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        controller: dateController,
        //readOnly: true,
        style: TextStyle(color: Colors.black, fontSize:  18),
        decoration: InputDecoration(
          hintText: '',
          hintStyle: TextStyle(color: kTextButtonColor, fontSize: 15),
          suffixIcon: GestureDetector(
            onTap: press,
            child: Icon(Icons.calendar_today,size: 25)),
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          fillColor: kTextButtonColor,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        //onTap: press,
      ),
    );
  }
}
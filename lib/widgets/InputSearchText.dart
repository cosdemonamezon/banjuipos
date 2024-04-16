import 'package:flutter/material.dart';

class InputSearchText extends StatefulWidget {
  InputSearchText({
    super.key,
    required this.size,
    this.controller,
    this.hintText,
    this.keyboardType,
    required this.onPressed,
    required this.onChanged
  });

  final Size size;
  TextEditingController? controller;
  String? hintText;
  final TextInputType? keyboardType;
  VoidCallback onPressed;
  Function(String) onChanged;

  @override
  State<InputSearchText> createState() => _InputSearchTextState();
}

class _InputSearchTextState extends State<InputSearchText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 241, 241, 241),
      width: double.infinity,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        style: TextStyle(fontSize: 22),
        onChanged: (value){
          //print('${value}');
          widget.onChanged(value);
        },
        decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(fontSize: 22),
            prefixIcon: Icon(Icons.local_mall),
            suffixIcon: IconButton(
              onPressed: widget.onPressed,
              icon: Icon(Icons.search),
            ),
          ),
      ),
    );
  }
}

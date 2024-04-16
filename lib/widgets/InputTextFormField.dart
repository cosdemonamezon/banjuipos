import 'package:flutter/material.dart';

class InputTextFormField extends StatefulWidget {
  InputTextFormField({
    super.key,
    required this.size,
    this.controller,
    this.hintText,
    this.isPassword = false,
    this.keyboardType,
    this.maxLines
  });

  final Size size;
  TextEditingController? controller;
  final bool isPassword;
  String? hintText;
  int? maxLines;
  final TextInputType? keyboardType;

  @override
  State<InputTextFormField> createState() => _InputTextFormFieldState();
}

class _InputTextFormFieldState extends State<InputTextFormField> {
  late bool _show = true;
  @override
  Widget build(BuildContext context) {    
    return Container(
      color: Color.fromARGB(255, 241, 241, 241),
      width: widget.size.width * 0.35,
      child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          onTap: () async {
            // await SystemChrome.setEnabledSystemUIMode(
            //   SystemUiMode.immersiveSticky,
            // );
          },
          style: TextStyle(fontSize: 22),
          obscureText: widget.isPassword ? _show : false,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(fontSize: 22),
            prefixIcon: Icon(Icons.local_mall),
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _show = !_show;
                      });
                    },
                    child: _show ? Image.asset('assets/icons/eye.png') : Image.asset('assets/icons/eye-slash.png'),
                  )
                : null,
          ),
        ),
    );
  }
}

import 'package:banjuipos/constants.dart';
import 'package:flutter/material.dart';

class NumPad extends StatefulWidget {
  final double buttonSize;
  final Color buttonColor;
  final Color iconColor;
  final TextEditingController controller;
  final Function delete;
  final Function onSubmit;
  final Function(int) status;
  int plusOrMinus;

  NumPad(
      {Key? key,
      this.buttonSize = 10,
      this.buttonColor = Colors.indigo,
      this.iconColor = Colors.amber,
      required this.delete,
      required this.onSubmit,
      required this.controller,
      required this.status,
      required this.plusOrMinus})
      : super(key: key);

  @override
  State<NumPad> createState() => _NumPadState();
}

class _NumPadState extends State<NumPad> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      //margin: const EdgeInsets.only(left:1, right: 1),
      child: Column(
        children: [
          //const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // implement the number keys (from 0 to 9) with the NumberButton widget
            // the NumberButton widget is defined in the bottom of this file
            children: [
              NumberButton(
                number: '7',
                size: widget.buttonSize,
                color: widget.buttonColor,
                controller: widget.controller,
              ),
              NumberButton(
                number: '8',
                size: widget.buttonSize,
                color: widget.buttonColor,
                controller: widget.controller,
              ),
              NumberButton(
                number: '9',
                size: widget.buttonSize,
                color: widget.buttonColor,
                controller: widget.controller,
              ),
              NumberButton1(
                number: 'del',
                size: widget.buttonSize,
                color: widget.buttonColor,
                controller: widget.controller,
                delete: widget.delete,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                number: '4',
                size: widget.buttonSize,
                color: widget.buttonColor,
                controller: widget.controller,
              ),
              NumberButton(
                number: '5',
                size: widget.buttonSize,
                color: widget.buttonColor,
                controller: widget.controller,
              ),
              NumberButton(
                number: '6',
                size: widget.buttonSize,
                color: widget.buttonColor,
                controller: widget.controller,
              ),
              NumberButton(
                number: '+',
                size: widget.buttonSize,
                color: widget.buttonColor,
                controller: widget.controller,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                number: '1',
                size: widget.buttonSize,
                color: widget.buttonColor,
                controller: widget.controller,
              ),
              NumberButton(
                number: '2',
                size: widget.buttonSize,
                color: widget.buttonColor,
                controller: widget.controller,
              ),
              NumberButton(
                number: '3',
                size: widget.buttonSize,
                color: widget.buttonColor,
                controller: widget.controller,
              ),
              NumberButton(
                number: '-',
                size: widget.buttonSize,
                color: widget.buttonColor,
                controller: widget.controller,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                number: '0',
                size: widget.buttonSize,
                color: widget.buttonColor,
                controller: widget.controller,
              ),
              NumberButton(
                number: '.',
                size: widget.buttonSize,
                color: widget.buttonColor,
                controller: widget.controller,
              ),
              NumberStatus(
                number: 'บวก',
                size: widget.buttonSize,
                color: widget.plusOrMinus == 0 ? Colors.red : Colors.grey,
                status: (plusValue) {
                  setState(() {
                    widget.plusOrMinus = 0;
                  });
                  widget.status(0);
                },
                statusClick: 0,
              ),
              NumberStatus(
                number: 'ลบ',
                size: widget.buttonSize,
                color: widget.plusOrMinus == 1 ? Colors.red : Colors.grey,
                status: (minusValue) {
                  setState(() {
                    widget.plusOrMinus = 1;
                  });
                  widget.status(1);
                },
                statusClick: 1,
              ),
              // SizedBox(
              //   height: 50,
              //   width: size.width * 0.08,
              // )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // IconButton(
              //   onPressed: () => delete(),
              //   icon: Icon(
              //     Icons.delete,
              //     color: iconColor,
              //   ),
              //   iconSize: buttonSize,
              // ),
              GestureDetector(
                onTap: () => widget.onSubmit(),
                child: Container(
                  decoration: BoxDecoration(color: kSecondaryColor, borderRadius: BorderRadius.all(Radius.circular(20))),
                  height: 60,
                  width: 150,
                  child: Center(
                    child: Text(
                      'ยืนยัน',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NumKeyShortcut extends StatelessWidget {
  const NumKeyShortcut({super.key, required this.number, required this.controller, this.name, this.price});
  final String number;
  final TextEditingController controller;
  final String? price;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.text += number.toString();
      },
      child: Container(
        height: 50,
        width: 80,
        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Center(
            child: Text(
          name.toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        )),
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final String number;
  final double size;
  final Color color;
  final TextEditingController controller;

  const NumberButton({
    Key? key,
    required this.number,
    required this.size,
    required this.color,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size / 4),
          ),
        ),
        onPressed: () {
          controller.text += number.toString();
        },
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    );
  }
}

class NumberButton1 extends StatelessWidget {
  final String number;
  final double size;
  final Color color;
  final TextEditingController controller;
  final String? price;
  final String? name;
  final Function delete;

  const NumberButton1({Key? key, required this.delete, required this.number, required this.size, required this.color, required this.controller, this.name, this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size / 4),
          ),
        ),
        onPressed: () => delete(),
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class NumberStatus extends StatelessWidget {
  final String number;
  final double size;
  final Color color;
  final String? price;
  final String? name;
  final Function(int) status;
  int statusClick;

  NumberStatus({Key? key, required this.status, required this.number, required this.size, required this.color, this.name, this.price, required this.statusClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size / 4),
          ),
        ),
        onPressed: () {
          status(statusClick);
        },
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

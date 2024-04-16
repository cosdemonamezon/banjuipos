import 'package:banjuipos/models/product.dart';
import 'package:flutter/material.dart';

class InputNumberDialog extends StatefulWidget {
  InputNumberDialog({super.key, required this.product});
  Product product;
  @override
  State<InputNumberDialog> createState() => _InputNumberDialogState();
}

class _InputNumberDialogState extends State<InputNumberDialog> {
  final TextEditingController? numberPick = TextEditingController();
  int qty = 1;
  int qtyPack = 1;
  int id = 1;
  int selectValue = 1;
  final TextEditingController _myNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    numberPick!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text('สินค้า: ${widget.product.name}'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ระบุจำนวนสินค้า',
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final addQty = await showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true,
                    useRootNavigator: true,

                    /// add this line to show bottomsheet over navbar
                    builder: (BuildContext context) {
                      return Container(
                        height: size.height * 0.90,
                        //padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: SizedBox(
                                height: size.height * 0.05,
                                child: Center(
                                    child: TextField(
                                  controller: _myNumber,
                                  textAlign: TextAlign.center,
                                  showCursor: false,
                                  style: TextStyle(fontSize: 30),
                                  // Disable the default soft keybaord
                                  keyboardType: TextInputType.none,
                                )),
                              ),
                            ),
                            
                          ],
                        ),
                      );
                    },
                  );
                  //print(addQty);
                  if (addQty != null) {
                    setState(() {
                      String a = '';
                      List<String> b = [];
                      List<String> k = [];
                      String originalString = "Hello, World!";

                      for (var character in addQty.runes) {
                        String singleCharacter = String.fromCharCode(character);
                        //print(singleCharacter);
                        if (singleCharacter == 'x') {
                          k.add(a);
                          a = '';
                        } else if (singleCharacter == '/') {
                          b.add(a);
                          a = '';
                        } else {
                          a += singleCharacter;
                        }
                      }
                      // inspect(k);
                      // inspect(b);
                      // inspect(b);
                    });
                  }
                },
                child: Container(
                  width: size.width * 0.285,
                  height: size.height * 0.06,
                  child: Center(
                      child: Text(
                    '${qty}',
                    style: TextStyle(fontSize: 18),
                  )),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.grey, width: 2)))),
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Text(
            'ยกเลิก',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.grey, width: 2)))),
          onPressed: () {
            setState(() {
              //widget.product.select = true;
            });
            Navigator.pop(context, widget.product);
          },
          child: Text('ตกลง'),
        ),
      ],
    );
  }
}


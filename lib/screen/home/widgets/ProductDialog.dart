import 'package:banjuipos/models/product.dart';
import 'package:banjuipos/models/selectproduct.dart';
import 'package:banjuipos/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;

class ProductDialog extends StatefulWidget {
  ProductDialog({super.key, required this.product, required this.retuenQty});
  Product product;
  Function(int) retuenQty;

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  int qty = 1;
  List<Unit> units = [];
  Unit? sclectedUnits;
  @override
  void initState() {
    super.initState();
    readUnitJson();
  }

  Future<void> readUnitJson() async {
    final String response = await rootBundle.loadString('assets/unit.json');
    final resdata = convert.jsonDecode(response);
    final list = resdata['data'] as List;

    setState(() {
      units = list.map((e) => Unit.fromJson(e)).toList();
      sclectedUnits = units[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.product.name ?? '',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'IBMPlexSansThai',
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(
                    context,
                  );
                },
                child: Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
              )
            ],
          ),
          Divider(),
        ],
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(widget.product.name!),
            ],
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    if (qty > 1) {
                      qty = qty - 1;
                    }
                  });
                  widget.retuenQty(qty);
                },
                child: Container(
                  width: size.width * 0.03,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(color: Color(0xFFCFD8DC), borderRadius: BorderRadius.circular(6)),
                  child: Icon(
                    Icons.remove,
                    size: 15,
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.01,
              ),
              Text("${qty}"),
              SizedBox(
                width: size.width * 0.01,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    qty = qty + 1;
                  });
                  widget.retuenQty(qty);
                },
                child: Container(
                  width: size.width * 0.03,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(color: Color(0xFFCFD8DC), borderRadius: BorderRadius.circular(6)),
                  child: Icon(
                    Icons.add,
                    size: 15,
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.01,
              ),
              Container(
                height: size.height * 0.06,
                width: size.width * 0.08,
                color: Color.fromARGB(255, 206, 201, 201),
                //color: kTabColor,
                child: Center(
                  child: DropdownButton<Unit>(
                    dropdownColor: Colors.white,
                    selectedItemBuilder: (e) => units.map<Widget>((item) {
                      return Center(
                        child: Text(
                          item.name!,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    underline: SizedBox(),
                    items: units.map<DropdownMenuItem<Unit>>((item) {
                      return DropdownMenuItem<Unit>(
                        value: item,
                        child: Text(
                          item.name!,
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansThai',
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    value: sclectedUnits,
                    onChanged: (v) async {
                      setState(() {
                        sclectedUnits = v;
                      });
                      //await context.read<ProductController>().getProduct(categoryid: sclectedProduct!.id!);
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: size.width * 0.10,
          ),
          SizedBox(
            width: size.width * 0.04,
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  width: size.width * 0.08,
                  height: size.height * 0.05,
                  decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(6)),
                  child: Center(
                      child: Text(
                    'ยกเลิก',
                    style: TextStyle(color: Colors.blue),
                  ))),
            ),
            SizedBox(
              width: size.width * 0.01,
            ),
            InkWell(
              onTap: () {
                final _selectproduct = SelectProduct(widget.product, qty: qty, '');
                Navigator.pop(context, _selectproduct);
              },
              child: Container(
                  width: size.width * 0.08,
                  height: size.height * 0.05,
                  decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(6)),
                  child: Center(
                      child: Text(
                    'ตกลง',
                    style: TextStyle(color: Colors.blue),
                  ))),
            ),
          ],
        ),
      ],
    );
  }
}

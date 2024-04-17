import 'package:banjuipos/models/customer.dart';
import 'package:banjuipos/screen/home/services/productController.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:banjuipos/widgets/InputTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCustomerDialog extends StatefulWidget {
  EditCustomerDialog({super.key, required this.customer});
  Customer customer;

  @override
  State<EditCustomerDialog> createState() => _EditCustomerDialogState();
}

class _EditCustomerDialogState extends State<EditCustomerDialog> {
  final GlobalKey<FormState> _editCustomerFormKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController licensePlate = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController code = TextEditingController();
  final TextEditingController tax = TextEditingController();
  final TextEditingController search = TextEditingController();
  Customer? _customer;

  @override
  void initState() {
    super.initState();
    setState(() {
      name.text = widget.customer.name!;
      phoneNumber.text = widget.customer.phoneNumber!;
      licensePlate.text = widget.customer.licensePlate!;
      address.text = widget.customer.address!;
      code.text = widget.customer.code!;
      tax.text = widget.customer.tax!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<ProductController>(builder: (context, productController, child) {
      final customer = productController.customer;
      return AlertDialog(
        title: Center(child: Text('ชื่อลูกค้า')),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
        content: Container(
          height: size.height * 0.8,
          width: size.width * 0.5,
          child: SingleChildScrollView(
            child: Form(
              key: _editCustomerFormKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                    child: Row(
                      children: [
                        Text(
                          'ชื่อ',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  InputTextFormField(
                    size: size,
                    controller: name,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                    child: Row(
                      children: [
                        Text(
                          'เบอร์โทร',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  InputTextFormField(
                    size: size,
                    controller: phoneNumber,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                    child: Row(
                      children: [
                        Text(
                          'ทะเบียนรถ',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  InputTextFormField(
                    size: size,
                    controller: licensePlate,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                    child: Row(
                      children: [
                        Text(
                          'ที่อยู่',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  InputTextFormField(
                    size: size,
                    controller: address,
                    maxLines: 2,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                    child: Row(
                      children: [
                        Text(
                          'รหัส',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  InputTextFormField(
                    size: size,
                    controller: code,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                    child: Row(
                      children: [
                        Text(
                          'เลขบัตรประชาชน',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  InputTextFormField(
                    size: size,
                    controller: tax,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: size.height * 0.30,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: TextButton(
                  //textColor: Color(0xFF6200EE),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  //textColor: Color(0xFF6200EE),
                  onPressed: () async {
                    if (widget.customer != null) {
                      setState(() {
                        _customer = Customer(widget.customer.id, code.text, name.text, address.text, licensePlate.text, phoneNumber.text, tax.text, widget.customer.identityCard, widget.customer.licensePlates);
                      });
                      Navigator.pop(context, _customer);
                    }
                  },
                  child: Text(
                    'ตกลง',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

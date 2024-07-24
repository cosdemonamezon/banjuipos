import 'package:banjuipos/models/account.dart';
import 'package:banjuipos/widgets/InputTextFormField.dart';
import 'package:flutter/material.dart';

class AddDetailPayment extends StatefulWidget {
  const AddDetailPayment({super.key});

  @override
  State<AddDetailPayment> createState() => _AddDetailPaymentState();
}

class _AddDetailPaymentState extends State<AddDetailPayment> {
  final GlobalKey<FormState> _paymentFormKey = GlobalKey<FormState>();
  final TextEditingController accountName = TextEditingController();
  final TextEditingController accountNumber = TextEditingController();
  final TextEditingController bank = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Center(child: Text('เพิ่มชื่อและบัญชีธนาคาร')),
      content: Container(
        height: size.height * 0.5,
        width: size.width * 0.4,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: _paymentFormKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.06,
                      ),
                      InputTextFormField(
                        size: size,
                        width: 0.30,
                        controller: accountName,
                        keyboardType: TextInputType.name,
                        maxLines: 1,
                        hintText: 'ชื่อบัญชี',
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'กรุณากรอกชื่อบัญชี';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      InputTextFormField(
                        size: size,
                        width: 0.30,
                        controller: accountNumber,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        hintText: 'เลขบัญชี',
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'กรุณากรอกเลขบัญชี';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      InputTextFormField(
                        size: size,
                        width: 0.30,
                        controller: bank,
                        keyboardType: TextInputType.name,
                        maxLines: 1,
                        hintText: 'ธนาคาร',
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'กรุณากรอกธนาคาร';
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
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
            SizedBox(
              width: size.width * 0.04,
            ),
            Center(
              child: TextButton(
                //textColor: Color(0xFF6200EE),
                onPressed: () async {
                  if (_paymentFormKey.currentState!.validate()) {
                    Account account = Account(accountName.text, accountNumber.text, bank.text);
                    Navigator.pop(context, account);
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
  }
}

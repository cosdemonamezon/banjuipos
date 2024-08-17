import 'package:banjuipos/extension/formattedMessage.dart';
import 'package:banjuipos/models/customerbank.dart';
import 'package:banjuipos/screen/home/services/productApi.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:banjuipos/widgets/InputTextFormField.dart';
import 'package:flutter/material.dart';

class CustomerPayment extends StatefulWidget {
  CustomerPayment({super.key, required this.customerBanks, required this.customerId});
  List<CustomerBank>? customerBanks;
  int customerId;

  @override
  State<CustomerPayment> createState() => _CustomerPaymentState();
}

class _CustomerPaymentState extends State<CustomerPayment> {
  List<CustomerBank> customerBanks = [];
  int? select;
  bool add = false;
  final GlobalKey<FormState> _paymentFormKey = GlobalKey<FormState>();
  final TextEditingController accountName = TextEditingController();
  final TextEditingController accountNumber = TextEditingController();
  final TextEditingController bank = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCustomerById();
    // setState(() {
    //   customerBanks = widget.customerBanks!;
    //   customerBanks[0].select = true;
    //   select = 0;
    // });
  }

  Future<void> getCustomerById() async {
    try {
      final _customer = await ProductApi.getCustomerById(id: widget.customerId);

      setState(() {
        customerBanks = _customer.customerBanks!;
        customerBanks[0].select = true;
        select = 0;
      });
    } on Exception catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: '${e.getMessage}',
          pressYes: () {
            Navigator.pop(context, true);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          add == false ? Text('เลือกบัญชีธนาคาร') : Text('เพิ่มบัญชีธนาคาร'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (add == true) {
                    add = false;
                  } else {
                    add = true;
                  }
                });
              },
              child: add == false
                  ? Icon(
                      Icons.add,
                      color: Colors.grey,
                    )
                  : Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
            ),
          )
        ],
      ),
      content: SingleChildScrollView(
        child: Container(
          height: size.height * 0.4,
          width: size.width * 0.3,
          child: add == false
              ? Container(
                  height: size.height * 0.50,
                  child: customerBanks.isNotEmpty
                      ? ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: customerBanks.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              child: Card(
                                margin: EdgeInsets.zero,
                                elevation: 0,
                                color: Color.fromARGB(255, 238, 234, 234),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color.fromARGB(255, 238, 231, 231),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.white),
                                  //decoration: BoxDecoration(color: read ? Colors.white : Color.fromRGBO(0, 0, 0, 0.1), borderRadius: BorderRadius.circular(8)),
                                  child: ListTile(
                                    title: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'เลขบัญชี:  ${customerBanks[index].accountNumber}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          'ชื่อบัญชี: ${customerBanks[index].accountName}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          'ธนาคาร:  ${customerBanks[index].bank}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: select == index
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.keyboard_arrow_right,
                                          ),
                                    onTap: () async {
                                      setState(() {
                                        select = index;
                                        if (customerBanks[select!].select == true) {
                                          customerBanks[select!].select = false;
                                        } else {
                                          customerBanks[select!].select = true;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            );
                          })
                      : SizedBox(),
                )
              : Column(
                  children: [
                    Form(
                        key: _paymentFormKey,
                        child: Column(
                          children: [
                            // SizedBox(
                            //   height: size.height * 0.06,
                            // ),
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
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TextButton(
                //textColor: Color(0xFF6200EE),
                onPressed: () {
                  CustomerBank? _customerBanks;
                  Navigator.pop(context, _customerBanks);
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
                  if (add == false) {
                    if (select != null) {
                      Navigator.pop(context, customerBanks[select!]);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialogYes(
                          title: 'แจ้งเตือน',
                          description: 'โปรดเลือกธนาคาร 1 รายการ',
                          pressYes: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      );
                    }
                  } else {
                    if (_paymentFormKey.currentState!.validate()) {
                      final _newbank = await ProductApi.addCustomerBank(customerId: widget.customerId, accountName: accountName.text, accountNumber: accountNumber.text, bank: bank.text);
                      if (_newbank != null) {
                        Navigator.pop(context, _newbank);
                      } else {}
                    }
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
        )
      ],
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
    );
  }
}

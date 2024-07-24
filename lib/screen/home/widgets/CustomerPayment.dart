import 'package:banjuipos/models/customerbank.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:flutter/material.dart';

class CustomerPayment extends StatefulWidget {
  CustomerPayment({super.key, required this.customerBanks});
  List<CustomerBank>? customerBanks;

  @override
  State<CustomerPayment> createState() => _CustomerPaymentState();
}

class _CustomerPaymentState extends State<CustomerPayment> {
  List<CustomerBank> customerBanks = [];
  int? select;

  @override
  void initState() {
    super.initState();
    setState(() {
      customerBanks = widget.customerBanks!;
      customerBanks[0].select = true;
      select = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('เลือกบัญชีธนาคาร')),
        ],
      ),
      content: Container(
        height: size.height * 0.4,
        width: size.width * 0.3,
        child: Container(
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
                  if (select != null) {
                    Navigator.pop(context, customerBanks[select!]);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialogYes(
                        title: 'แจ้งเตือน',
                        description: 'โปรดเลือกทะเบียนรถ 1 รายการ',
                        pressYes: () {
                          Navigator.pop(context, true);
                        },
                      ),
                    );
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

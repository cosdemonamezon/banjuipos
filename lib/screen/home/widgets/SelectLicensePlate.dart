import 'package:banjuipos/extension/formattedMessage.dart';
import 'package:banjuipos/models/licenseplates.dart';
import 'package:banjuipos/screen/home/services/productApi.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:banjuipos/widgets/InputTextFormField.dart';
import 'package:banjuipos/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';

class SelectLicensePlate extends StatefulWidget {
  SelectLicensePlate({super.key, required this.licenseplates, required this.customerId});
  List<LicensePlates> licenseplates;
  int customerId;
  @override
  State<SelectLicensePlate> createState() => _SelectLicensePlateState();
}

class _SelectLicensePlateState extends State<SelectLicensePlate> {
  int? select;
  bool add = false;
  final GlobalKey<FormState> _addLicensePlateFormKey = GlobalKey<FormState>();
  final TextEditingController licensePlate = TextEditingController();
  List<LicensePlates> licenseplates = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      licenseplates = widget.licenseplates;
      licenseplates.reversed;
    });
  }

  //add licenseplates
  Future<void> getlistNamePrefix({required String licenseplate}) async {
    try {
      LoadingDialog.open(context);
      final _licenseplate = await ProductApi.addLicensePlate(customerId: widget.customerId, licensePlate: licenseplate);
      setState(() {
        if (_licenseplate != null) {
          add = false;
          // licenseplates.add(_licenseplate);
          // licenseplates.reversed;
          licenseplates.insert(0, _licenseplate);
        }
      });
      if (!mounted) return;
      LoadingDialog.close(context);
    } on Exception catch (e) {
      if (!mounted) return;
      LoadingDialog.close(context);
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
            Center(child: Text('เลือกทะเบียนรถ')),
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
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
        content: Container(
          height: size.height * 0.4,
          width: size.width * 0.3,
          child: SingleChildScrollView(
            child: Column(
              children: [
                add == true
                    ? Form(
                        key: _addLicensePlateFormKey,
                        child: Column(
                          children: [
                            InputTextFormField(
                              size: size,
                              width: 0.34,
                              controller: licensePlate,
                              keyboardType: TextInputType.name,
                              maxLines: 1,
                              hintText: ' ทะเบียนรถ',
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: licenseplates.isNotEmpty
                            ? Column(
                                children: [
                                  Container(
                                    height: size.height * 0.50,
                                    child: ListView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: licenseplates.length,
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
                                                  title: Text(
                                                    '${licenseplates[index].licensePlate}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
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
                                                      if (licenseplates[select!].select == true) {
                                                        licenseplates[select!].select = false;
                                                      } else {
                                                        licenseplates[select!].select = true;
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ),
              ],
            ),
          ),
        ),
        actions: [
          add == true
              ? Row(
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
                          if (licensePlate.text != null || licensePlate.text != "") {
                            //Navigator.pop(context, widget.licenseplates[select!]);
                            try {
                              getlistNamePrefix(licenseplate: licensePlate.text);
                            } on Exception catch (e) {
                              if (!mounted) return;
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
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialogYes(
                                title: 'แจ้งเตือน',
                                description: 'โปรดใส่ข้อมูลทะเบียนรถ',
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
              : Row(
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
                          if (select != null) {
                            Navigator.pop(context, licenseplates[select!]);
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
                ),
        ]);
  }
}

import 'package:banjuipos/constants.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:banjuipos/widgets/InputTextFormField.dart';
import 'package:banjuipos/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrinterSetting extends StatefulWidget {
  const PrinterSetting({super.key});

  @override
  State<PrinterSetting> createState() => _PrinterSettingState();
}

class _PrinterSettingState extends State<PrinterSetting> {
  final TextEditingController ipAddress = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    getIpAdress();
  }

  Future getIpAdress() async {
    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString('ipAddress');
    setState(() {
      if (ip != null) {
        ipAddress.text = ip;
      } else {
        ipAddress.text = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 20,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: size.height,
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.04,
                        ),
                        child: Text(
                          'ตั้งค่า IP เครื่องปริ้น',
                          style: TextStyle(fontFamily: 'IBMPlexSansThai', color: Colors.black, fontSize: 22),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.04,
                        ),
                        child: InputTextFormField(
                          size: size,
                          width: 0.30,
                          controller: ipAddress,
                          hintText: 'IP address',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.35,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: GestureDetector(
                          onTap: () async {
                            LoadingDialog.open(context);
                            final SharedPreferences prefs = await _prefs;
                            await prefs.setString('ipAddress', ipAddress.text);
                            if (!mounted) return;
                            LoadingDialog.close(context);
                            final ok = await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialogYes(
                                  title: 'แจ้งเตือน',
                                  description: 'บันทึกสำเร็จ',
                                  pressYes: () {
                                    Navigator.pop(context, true);
                                  },
                                );
                              },
                            );
                            if (ok == true) {
                              if (!mounted) return;
                              // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                              //   return SelectedCustomer();
                              // }), (route) => false);
                              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                              //   return ProductPage(
                              //     customer: widget.customer,
                              //   );
                              // }));
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.height * 0.35),
                            child: Container(
                              height: size.height * 0.08,
                              width: size.width * 0.35,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kButtonColor),
                              child: Center(
                                child: Text(
                                  'บันทึก',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

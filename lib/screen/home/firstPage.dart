import 'package:banjuipos/screen/home/homePage.dart';
import 'package:banjuipos/screen/home/orderPage.dart';
import 'package:banjuipos/screen/home/widgets/ItemMenuWidget.dart';
import 'package:banjuipos/screen/login/loginPage.dart';
import 'package:banjuipos/screen/login/services/loginApi.dart';
import 'package:banjuipos/screen/login/services/loginController.dart';
import 'package:banjuipos/screen/setting/printerSetting.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:banjuipos/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  String pageActive = 'Home';
  String ipAddress = '';

  _pageView() {
    switch (pageActive) {
      case 'Home':
        return HomePage();
      case 'Menu':
        return OrderPage();
      case 'Setting':
        return PrinterSetting();
      // case 'History':
      //   return Container();
      // case 'Setting':
      //   return Sencondisplay();

      default:
        return HomePage();
    }
  }

  _setPage(String page) {
    setState(() {
      pageActive = page;
    });
  }

  @override
  void initState() {
    super.initState();
    getIpAddress();
  }

  Future getIpAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString('ipAddress');
    setState(() {
      if (ip != null) {
        ipAddress = ip;
      } else {
        ipAddress = '';
      }
    });
    if (ipAddress == '') {
      final _ok = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: 'ยังไม่ได้ตั้งค่าปริ๊นเตอร์โปรดตั้งค่าปริ๊นเตอร์ก่อนทำการปริ๊น',
          pressYes: () {
            Navigator.pop(context, true);
          },
        ),
      );
      if (_ok == true) {
        _setPage('Setting');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff1f2029),
        body: Row(
          children: [
            Container(
              width: size.width * 0.075,
              height: size.height,
              padding: EdgeInsets.only(top: 24, right: 12, left: 12),
              child: Column(
                children: [
                  Column(
                    children: [
                      Image.asset('assets/icons/829035-transformed.png'),
                      SizedBox(height: size.height * 0.02),
                      // Text(
                      //   'by BanJui',
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 8,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                  //SizedBox(height: size.height * 0.02),
                  Expanded(
                    child: ListView(
                      children: [
                        ItemMenuWidget(
                          size: size,
                          pageActive: pageActive,
                          menu: 'Home',
                          title: 'สั่งและชำระ',
                          image: 'assets/icons/Orderandpay.png',
                          press: () => _setPage('Home'),
                        ),
                        ItemMenuWidget(
                          size: size,
                          pageActive: pageActive,
                          menu: 'Menu',
                          title: 'คำสั่งซื้อ',
                          image: 'assets/icons/Cancelbill.png',
                          press: () => _setPage('Menu'),
                        ),
                        // ItemMenuWidget(
                        //   size: size,
                        //   pageActive: pageActive,
                        //   menu: 'History',
                        //   title: 'ปิด/เปิด \n กะงาน',
                        //   image: 'assets/icons/Clock.png',
                        //   press: () => _setPage('History'),
                        // ),
                        SizedBox(
                          height: size.height * 0.25,
                        ),
                        ItemMenuWidget(
                          size: size,
                          pageActive: pageActive,
                          menu: 'Setting',
                          title: 'ตั้งค่า POS',
                          image: 'assets/icons/Settinglogo.png',
                          press: () => _setPage('Setting'),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (!mounted) return;
                      final ok = await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AlertDialogYesNo(
                          title: 'แจ้งเตือน',
                          description: 'ต้องออกจากระบบหรือไม่',
                          pressYes: () {
                            Navigator.pop(context, true);
                          },
                          pressNo: () {
                            Navigator.pop(context, false);
                          },
                        ),
                      );
                      if (ok == true) {
                        try {
                          LoadingDialog.open(context);
                          final _logout = await LoginApi.logout();
                          if (_logout == true) {
                            if (!mounted) return;
                            LoadingDialog.close(context);
                            context.read<LoginController>().clearToken().then((value) {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                            });
                          } else {
                            if (!mounted) return;
                            LoadingDialog.close(context);
                          }
                        } on Exception catch (e) {
                          if (!mounted) return;
                          LoadingDialog.close(context);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialogYes(
                              title: 'แจ้งเตือน',
                              description: '${e}',
                              pressYes: () {
                                Navigator.pop(context, true);
                              },
                            ),
                          );
                        }
                      }
                    },
                    child: AnimatedContainer(
                      height: size.height * 0.05,
                      width: size.width * 0.08,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromARGB(255, 68, 68, 68),
                      ),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.slowMiddle,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'IBMPlexSansThai',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                ],
              ),
            ),

            ///Show Page
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 2, right: 1),
                padding: EdgeInsets.only(top: 0, right: 0, left: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(1), topRight: Radius.circular(1)),
                  color: Color.fromARGB(255, 229, 230, 240),
                ),
                child: _pageView(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

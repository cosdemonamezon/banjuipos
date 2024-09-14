import 'package:banjuipos/extension/formattedMessage.dart';
import 'package:banjuipos/models/branch.dart';
import 'package:banjuipos/screen/home/firstPage.dart';
import 'package:banjuipos/screen/home/services/productController.dart';
import 'package:banjuipos/screen/login/services/loginApi.dart';
import 'package:banjuipos/screen/login/services/loginController.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:banjuipos/widgets/InputTextFormField.dart';
import 'package:banjuipos/widgets/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  List<Branch> branchs = [];
  Branch? sclectedBranch;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getlistCategory();
    });
  }

  //ดึงข้อมูล Category
  Future<void> getlistCategory() async {
    try {
      LoadingDialog.open(context);
      await context.read<ProductController>().getListBranch();
      final list = context.read<ProductController>().branchs;
      if (!mounted) return;
      LoadingDialog.close(context);
      setState(() {
        branchs = list;
        sclectedBranch = list[0];
      });
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
    return Consumer<LoginController>(builder: (context, controller, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Row(
          children: [
            Expanded(
                flex: 6,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/829035_transformed.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                )),
            Expanded(
              flex: 4,
              child: Form(
                key: _loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        height: size.height * 0.55,
                        width: size.width * 0.35,
                        child: Column(
                          children: [
                            Text(
                              'เข้าสู่ระบบ',
                              style: TextStyle(fontSize: 30),
                            ),
                            InputTextFormField(
                              size: size,
                              width: 0.30,
                              controller: username,
                              maxLines: 1,
                              prefixIcon: Icon(Icons.local_mall),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            InputTextFormField(
                              size: size,
                              width: 0.30,
                              controller: password,
                              isPassword: true,
                              maxLines: 1,
                              prefixIcon: Icon(Icons.local_mall),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                              child: Row(
                                children: [
                                  Text(
                                    'เลือกสาขา',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            branchs.isNotEmpty
                                ? Container(
                                    color: Color.fromARGB(255, 241, 241, 241),
                                    width: size.width * 0.30,
                                    height: size.height * 0.07,
                                    child: Center(
                                      child: DropdownButton<Branch>(
                                        selectedItemBuilder: (e) => branchs.map<Widget>((item) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                                            child: Text(
                                              item.name!,
                                              style: TextStyle(color: Colors.black, fontSize: 18),
                                            ),
                                          );
                                        }).toList(),
                                        isDense: true,
                                        isExpanded: true,
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                        underline: SizedBox(),
                                        items: branchs.map<DropdownMenuItem<Branch>>((item) {
                                          return DropdownMenuItem<Branch>(
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
                                        value: sclectedBranch,
                                        onChanged: (v) async {
                                          setState(() {
                                            sclectedBranch = v!;
                                          });
                                        },
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    child: Text('**ไม่พบสาขาให้เลือก โปรดแจ้งผู้ดูแลระบบ**', style: TextStyle(color: Colors.red, fontSize: 15)),
                                  ),
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            GestureDetector(
                              onTap: () async {
                                // await SystemChrome.setEnabledSystemUIMode(
                                //   SystemUiMode.immersiveSticky,
                                // );
                                if (_loginFormKey.currentState!.validate()) {
                                  try {
                                    LoadingDialog.open(context);

                                    if (sclectedBranch != null) {
                                      final _login = await controller.signIn(username: username.text, password: password.text, branch_id: sclectedBranch!.id!);
                                      if (!mounted) return;
                                      LoadingDialog.close(context);
                                      if (_login != null) {
                                        if (!mounted) return;
                                        final _shift = await LoginApi.openShift();
                                        if (_shift != null) {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => FirstPage()));
                                        } else {
                                          if (!mounted) return;
                                        }
                                      } else {
                                        if (!mounted) return;
                                        LoadingDialog.close(context);
                                      }
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialogYes(
                                          title: 'แจ้งเตือน',
                                          description: 'ยังไม่ได้เลือกสาขา',
                                          pressYes: () {
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                      );
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
                              child: Card(
                                color: Colors.blue,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: SizedBox(
                                  width: size.width * 0.30,
                                  height: size.height * 0.06,
                                  child: Center(
                                      child: Text(
                                    'เข้าสู่ระบบ',
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

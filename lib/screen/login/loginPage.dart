import 'package:banjuipos/screen/home/firstPage.dart';
import 'package:banjuipos/screen/login/services/loginApi.dart';
import 'package:banjuipos/screen/login/services/loginController.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:banjuipos/widgets/InputTextFormField.dart';
import 'package:banjuipos/widgets/LoadingDialog.dart';
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
                      image: AssetImage('assets/images/S__42205196.jpg'),
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
                        height: size.height * 0.45,
                        width: size.width * 0.35,
                        child: Column(
                          children: [
                            Text(
                              'เข้าสู่ระบบ',
                              style: TextStyle(fontSize: 30),
                            ),
                            InputTextFormField(
                              size: size,
                              controller: username,
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            InputTextFormField(
                              size: size,
                              controller: password,
                              isPassword: true,
                              maxLines: 1,
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

                                    final _login = await controller.signIn(username: username.text, password: password.text);
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
                                  width: double.infinity,
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

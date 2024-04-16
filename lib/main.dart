import 'package:banjuipos/screen/home/firstPage.dart';
import 'package:banjuipos/screen/home/services/productController.dart';
import 'package:banjuipos/screen/login/loginPage.dart';
import 'package:banjuipos/screen/login/services/loginController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? token;
String? ipAddress;
late SharedPreferences prefs;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  prefs = await SharedPreferences.getInstance();
  token = await prefs.getString('token');
  ipAddress = prefs.getString('ipAddress');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductController()),
        ChangeNotifierProvider(create: (context) => LoginController()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontFamily: 'IBMPlexSansThai',
                fontSize: 16,
                //fontWeight: FontWeight.bold,
              ),
              iconTheme: IconThemeData(color: Colors.black),
            ),
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'IBMPlexSansThai',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            backgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.white, // Your accent color
            ),
          ),
        home: token == null ? LoginPage() : FirstPage(),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, unnecessary_const

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/page/Pegawai/pegawaiASN.dart';
import 'package:kec_app/page/Users/RegisterPage.dart';
import 'package:kec_app/screen/SplashScreen.dart';

// add firestore ke widget flutter

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SalbaApp());
}

class SalbaApp extends StatelessWidget {
  const SalbaApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black //here you can give the text color
              )),
      home: SplashScreen(),
    );
  }
}

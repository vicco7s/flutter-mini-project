// ignore_for_file: prefer_const_constructors, unnecessary_const

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/api/firebase_api.dart';
import 'package:kec_app/screen/SplashScreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';


// add firestore ke widget flutter

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Inisialisasi Firebase Messaging
  await FirebaseApi().initNotifications();
  // Inisialisasi Firebase Storage
  await firebase_storage.FirebaseStorage.instance;
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

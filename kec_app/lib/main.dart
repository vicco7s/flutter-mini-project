
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikep/api/firebase_api.dart';
import 'package:sikep/page/Dashboard%20Camat/HomeCamatPage.dart';
import 'package:sikep/page/Dashboard%20user/HomeUserPage.dart';
import 'package:sikep/page/HomePage.dart';
import 'package:sikep/page/Users/loginpage.dart';
import 'package:sikep/screen/SplashScreen.dart';

import 'controller/controlerPegawai/controllerriwayatpegawai.dart';


// add firestore ke widget flutter

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Inisialisasi Firebase Messaging
  await FirebaseApi().initNotifications();
  // Inisialisasi Firebase Storage
  await firebase_storage.FirebaseStorage.instance;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String userType = prefs.getString('userType') ?? '';

   runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: isLoggedIn ? getHomePageByUserType(userType) : SplashScreen(),
    ),
  );
}



 Widget getHomePageByUserType(String userType) {
  switch (userType) {
    case 'Admin':
      return HomePage();
    case 'Pegawai':
      return HomeUserPage();
    case 'Camat':
      return HomeCamatPage();
    default:
      return SplashScreen();
  }
}



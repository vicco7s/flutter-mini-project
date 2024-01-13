
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screen/splashscreen.dart';

Future<void> main() async {
  /*
    januari 2024 core firebase perlu menambahkan firebase option untuk 
    menghubungkan firebase ke flutter
   */
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: "AIzaSyCJ-JDZ1gInzJbyzW5PapCiEoQC5w1Z_PE", 
    appId: "1:1024878666067:android:d66d268cc05b9714bbc1a6", 
    messagingSenderId: "1024878666067", 
    projectId: "sisigawian"));


  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  // String userType = prefs.getString('userType') ?? '';

   runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: SplashScreen(),
    ),
  );
}



//  Widget getHomePageByUserType(String userType) {
//   switch (userType) {
//     case 'Admin':
//       // return HomePage();
//     case 'Pegawai':
//       // return HomeUserPage();
//     case 'Camat':
//       // return HomeCamatPage();
//     default:
//       return SplashScreen();
//   }
// }
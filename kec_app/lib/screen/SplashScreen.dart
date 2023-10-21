// ignore: file_names

import 'dart:async';

import 'package:flutter/material.dart';

import '../page/Users/loginpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    startTimer();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
            padding: const EdgeInsets.all(100),
            child: Image.asset(
              "image/kec-salba.png",
              fit: BoxFit.fill,
            )),
      ),
    );
  }

  Future<Timer> startTimer() async {
    // ignore: prefer_const_constructors
    return Timer(Duration(seconds: 1), onDone);
  }

  void onDone() {
    Navigator.of(context)
        // ignore: prefer_const_constructors
        .pushReplacement(MaterialPageRoute(builder: ((context) => LoginPage())));
  }
}

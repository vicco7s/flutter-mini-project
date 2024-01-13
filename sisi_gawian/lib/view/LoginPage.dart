import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  //form text user
  final _formKey = GlobalKey<FormState>();

  //auth Firestore
  final _auth = FirebaseAuth.instance;

  late StreamSubscription connectivitySubscription;
  ConnectivityResult previousresult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult nowresult) {
      if (nowresult == ConnectivityResult.none) {
        Fluttertoast.showToast(
          msg: "Jaringan Tidak Tersedia",
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      // when mobile and wifi network connected
      else if (previousresult == ConnectivityResult.none) {
        // print('Connected');
        if (nowresult == ConnectivityResult.mobile) {
          print('Mobile Network Connected');
        } else if (nowresult == ConnectivityResult.wifi) {
          print('WiFi Network Connected');
        }
      }
      previousresult = nowresult;
    });
    // Cek apakah harus logout pengguna
  }

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // ignore: avoid_unnecessary_containers
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                child: Image.asset(
                  "image/kec-salba.png",
                  width: 250,
                  height: 200,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextFormField(
                  controller: _email,
                  obscureText: false,
                  validator: (value) {
                    if (value!.length == 0) {
                      return "Email Tidak Boleh Kosong";
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return ("Mohon Masukan Email Dengan Benar !");
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    hintText: "Masukan Email",
                    fillColor: Colors.white70,
                    labelText: 'Email',
                  ),
                  onSaved: (value) {
                    _email.text = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextFormField(
                  controller: _pass,
                  obscureText: _isObscure3,
                  validator: (value) {
                    RegExp regex = new RegExp(r'^.{6,}$');
                    if (value!.isEmpty) {
                      return "Password Tidak Boleh Kosong";
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Masukan Password dengan benar min 6 karakter");
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _pass.text = value!;
                  },
                  maxLength: 16,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscure3 = !_isObscure3;
                        });
                      },
                      icon: Icon(_isObscure3
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelText: 'Password',
                    filled: true,
                  ),
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 35,
              ),
              // ignore: avoid_unnecessary_containers
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      visible = true;
                    });
                    if (previousresult != ConnectivityResult.none) {
                      // signIn(_email.text, _pass.text);
                    } else {
                      print('Jaringan Tidak Tersedia');
                      Fluttertoast.showToast(
                        msg: "Tidak Terhubung Ke Jaringan",
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    // side: BorderSide(color: Colors.black)
                  ))),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                    child: Text('Login'.toUpperCase()),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                child: Column(
                  children: [
                    Text('Jika Anda Lupa Password Klik tombol dibawah ini '),
                    TextButton(
                        onPressed: () {
                          if (previousresult != ConnectivityResult.none) {
                            // Navigator.of(context).push(CupertinoPageRoute(
                            //     builder: ((context) => ResetPassword())));
                          } else {
                            print('Jaringan Tidak Tersedia');
                            Fluttertoast.showToast(
                              msg: "Tidak Terhubung Ke Jaringan",
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        child: Text('Reset Password'))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

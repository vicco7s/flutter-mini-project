// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikep/screen/SplashScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/Drawer.dart';
import '../util/SpeedDialFloating.dart';
import 'Users/RegisterPage.dart';
import 'Users/loginpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    // Panggil fungsi checkAutoLogout untuk memeriksa apakah pengguna harus logout
    checkAutoLogout();
  }

  void checkAutoLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastLoginTime = prefs.getInt('lastLoginTime');
    if (lastLoginTime != null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final weekInMillis = 7 * 24 * 60 * 60 * 1000; // Satu minggu dalam milidetik
      final monthInMillis = 30 * 24 * 60 * 60 * 1000; // Satu bulan dalam milidetik
      if (currentTime - lastLoginTime > monthInMillis) {
        // Jika melewati waktu seminggu, logout pengguna
        logout(context);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawes(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            color: Colors.blueAccent,
            icon: Icon(Icons.person_add_alt_1_outlined),
            onPressed: () {
              Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (context) => CreateUser()));
            },
          ),
          IconButton(
            color: Colors.blueAccent,
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              logout(context);
            },
          ),
        ],
        title: Text('Dashbord Admin'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                  color: Color(0xff037BF8),
                  elevation: 5.0,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Text('Selamat Datang di Dashboard Admin !',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        subtitle: Text(
                          'Salam Babaris adalah sebuah kecamatan di Kabupaten Tapin, provinsi Kalimantan Selatan, Indonesia. Salam Babaris merupakan hasil pemekaran dari kecamatan Tapin Selatan.',
                          style: TextStyle(fontSize: 11, color: Colors.white),
                          textAlign: TextAlign.justify,
                        ),
                      ))),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              title: Text(
                "Jumlah Data Surat Agenda",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                    color: Colors.blueAccent,
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('suratkeluar')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          int dataCount = snapshot.data!.docs.length;
                          return Center(
                              child: Column(
                            children: [
                              Text(
                                "Surat Keluar",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("$dataCount",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ));
                        },
                      ),
                    )),
                Card(
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('suratmasuk')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          int dataCount = snapshot.data!.docs.length;
                          return Center(
                              child: Column(
                            children: [
                              Text(
                                "Surat Masuk",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("$dataCount",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ));
                        },
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              title: Text(
                "Jumlah Data Pegawai Dan dinas",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(33, 50, 33, 50),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('pdinas')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          int dataCount = snapshot.data!.docs.length;
                          return Center(
                              child: Column(
                            children: [
                              Text(
                                "Perjalanan Dinas",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("$dataCount",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ));
                        },
                      ),
                    )),
                Card(
                    color: Colors.blueAccent,
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(33, 50, 33, 50),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('pegawai')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          int dataCount = snapshot.data!.docs.length;
                          return Center(
                              child: Column(
                            children: [
                              Text(
                                "Pegawai",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("$dataCount",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ));
                        },
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "-- End --",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ))
          ],
        ),
      ),
      floatingActionButton: SpeedDialFloating(
        backColors: Colors.green,
        animatedIcons: null, // Set animatedIcons ke null
        icons: FontAwesomeIcons.whatsapp,
        ontap: () {
          _launchWhatsApp();
        },
      ),
    );
  }
}

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false); // Menandai pengguna tidak lagi login
  await prefs.setString('userType', ''); // Hapus tipe pengguna yang tersimpan

  await FirebaseAuth.instance.signOut(); // Logout dari Firebase Authentication

  // Navigasi kembali ke halaman login
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => SplashScreen(),
    ),
  );
}

void _launchWhatsApp() async {
  String? phone =
      '6282149631510'; // Ganti dengan nomor WhatsApp yang ingin Anda arahkan ke sini
  String? message = 'Halo, saya membutuhkan bantuan.';

  final url = 'https://wa.me/$phone/?text=${Uri.decodeFull(message)}';

  try {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    throw 'Tidak dapat membuka tautan WhatsApp.';
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/TabbarViewWidget/TabbarViewUser.dart';
import '../../../page/Dashboard%20user/perjalanandinas/PdinasUser.dart';
import '../../../page/Dashboard%20user/profil/Pegawaiuser.dart';
import '../../../page/Dashboard%20user/surat/Suratmasukuser.dart';
import '../../../page/Users/loginpage.dart';
import '../../../util/SpeedDialFloating.dart';
import '../../../util/utilpegawaihome/DrawerPegawaiHome.dart';

import '../../screen/SplashScreen.dart';
import 'surat/SuratKeluarUser.dart';

import 'package:url_launcher/url_launcher.dart';

class HomeUserPage extends StatefulWidget {
  const HomeUserPage({super.key});

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> with SingleTickerProviderStateMixin{
  final currentUser = FirebaseAuth.instance;

  final List<Widget> myTabs = [
    Tab(
      icon: Icon(Icons.mark_email_unread_outlined),
    ),
    Tab(
      icon: Icon(Icons.outgoing_mail),
    ),
    Tab(
      icon: Icon(Icons.emoji_transportation_outlined),
    ),
    Tab(
      icon: Icon(Icons.paid_outlined),
    ),
  ];

  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
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
      backgroundColor: Colors.white,
      drawer: DrawerPegawaiHome(currentUser: currentUser),
      appBar: AppBar(
        actions: [
          IconButton(
            color: Colors.blueAccent,
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              logout(context);
            },
          )
        ],
        title: Text('Dashbord pegawai'),
        centerTitle: true,
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
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Text('Selamat Datang di Dashboard Pegawai !',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        subtitle: Text(
                          'Salam Babaris adalah sebuah kecamatan di Kabupaten Tapin, provinsi Kalimantan Selatan, Indonesia. Salam Babaris merupakan hasil pemekaran dari kecamatan Tapin Selatan.',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                          textAlign: TextAlign.justify,
                        ),
                      ))),
            ),
            SizedBox(
              height: 25,
            ),
            ListTile(
              title: Text(
                "Menu Utama",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: ((context) => PegawaiUser())));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // background
                      foregroundColor: Colors.blueAccent, // foreground
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.person),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Pegawai",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: ((context) => PerjalananDinasUser())));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // background
                      foregroundColor: Colors.blueAccent, // foreground
                    ),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(1, 20, 1, 20),
                        child: Center(
                            child: Column(
                          children: [
                            Icon(Icons.emoji_transportation),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Perjalanan Dinas",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        )))),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: ((context) => SuratMasukUser())));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // background
                      foregroundColor: Colors.blueAccent, // foreground
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(11, 20, 11, 20),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.mail),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Surat Masuk",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: ((context) => SuratKeluarUser())));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // background
                      foregroundColor: Colors.blueAccent, // foreground
                    ),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                        child: Center(
                            child: Column(
                          children: [
                            Icon(Icons.drafts),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Surat Keluar",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        )))),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              title: Text(
                "Jumlah Data",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Card(
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
                  SizedBox(
                    width: 10,
                  ),
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
                  SizedBox(
                    width: 10,
                  ),
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
                  SizedBox(
                    width: 10,
                  ),
                  Card(
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
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
                height: 15,
              ),
              ListTile(
                title: Text(
                  "Highlights",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              // list tabbarview
              TabBar(
                controller: tabController,
                tabs: myTabs,
                labelColor: Colors.blueAccent,
              ),
              Container(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarViewUsers(
                    controllers: tabController,
                  ),
                ),
              )
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
  String phone = '6282149631510'; // Ganti dengan nomor WhatsApp yang ingin Anda arahkan ke sini
  String message = 'Halo, saya membutuhkan bantuan.';

  final url = 'https://wa.me/$phone/?text=${Uri.encodeComponent(message)}';

  try {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    throw 'Tidak dapat membuka tautan WhatsApp.';
  }
  
}

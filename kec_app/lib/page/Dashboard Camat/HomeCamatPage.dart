import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kec_app/components/TabbarViewWidget/TabbarViewWidget.dart';
import 'package:kec_app/page/Dashboard%20Camat/viewpage/PdinasCamat.dart';
import 'package:kec_app/page/Dashboard%20Camat/viewpage/PegawaiCamat.dart';
import 'package:kec_app/page/Dashboard%20Camat/viewpage/SuratKeluarCamat.dart';
import 'package:kec_app/page/Dashboard%20Camat/viewpage/SuratmasukCamat.dart';
import 'package:kec_app/page/Users/loginpage.dart';
import 'package:kec_app/util/SpeedDialFloating.dart';
import 'package:kec_app/util/utilCamatHome/DrawerCamatHome.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeCamatPage extends StatefulWidget {
  const HomeCamatPage({super.key});

  @override
  State<HomeCamatPage> createState() => _HomeCamatPageState();
}

class _HomeCamatPageState extends State<HomeCamatPage>
    with SingleTickerProviderStateMixin {
  final currentUser = FirebaseAuth.instance;
  final List<Widget> myTabs = [
    Tab(
      icon: Icon(Icons.group_outlined),
    ),
    Tab(
      icon: Icon(Icons.mark_email_unread_outlined),
    ),
    Tab(
      icon: Icon(Icons.outgoing_mail),
    ),
    Tab(
      icon: Icon(Icons.emoji_transportation_outlined),
    ),
  ];

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerCamatHome(
        currentUser: currentUser,
      ),
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
        title: Text('Dashbord Camat'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                            child: Text('Selamat Datang di Dashboard Camat!',
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
                                builder: ((context) => PegawaiCamat())));
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
                              Icon(Icons.group),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Pegawai",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: ((context) => PerjalananDinasCamat())));
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
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
                                builder: ((context) => SuratMasukCamat())));
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
                              Icon(Icons.mark_email_unread),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Surat Masuk",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: ((context) => SuratKeluarCamat())));
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
                              Icon(Icons.outgoing_mail),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Surat Keluar",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )))),
                ],
              ),
              SizedBox(
                height: 30,
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 22, right: 22),
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
                                  return Center(
                                      child: CircularProgressIndicator());
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
                                  return Center(
                                      child: CircularProgressIndicator());
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
                                  return Center(
                                      child: CircularProgressIndicator());
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
                                  return Center(
                                      child: CircularProgressIndicator());
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
                  child: TabBarViewWidget(
                    controllers: tabController,
                  ),
                ),
              )
            ],
          ),
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
  await FirebaseAuth.instance.signOut();
  // ignore: use_build_context_synchronously
  Navigator.pushReplacement(
    context,
    CupertinoPageRoute(
      builder: (context) => LoginPage(),
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

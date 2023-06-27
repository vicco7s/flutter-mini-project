import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/page/Dashboard%20user/profil/DetailPegawai.dart';
import 'package:kec_app/page/Pegawai/editpegawai.dart';
import 'package:kec_app/util/ContainerDeviders.dart';
import 'package:kec_app/util/controlleranimasiloading/CircularControlAnimasiProgress.dart';

class PegawaiUser extends StatefulWidget {
  const PegawaiUser({super.key});

  @override
  State<PegawaiUser> createState() => _PegawaiUserState();
}

class _PegawaiUserState extends State<PegawaiUser> {
  final Query<Map<String, dynamic>> _pegawai =
      FirebaseFirestore.instance.collection('pegawai');

  DocumentSnapshot? currentdoc;

  @override
  void initState() {
    super.initState();
    getCurrentUser(); // Panggil fungsi getCurrentUser saat initState
  }

  void getCurrentUser() async {
    // Ambil data pengguna saat login
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        currentdoc = doc;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(FontAwesomeIcons.xmark),
        ),
        title: Text('Profil'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
          child: FutureBuilder(
          future: Future.delayed(Duration(seconds: 2)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: ColorfulCirclePrgressIndicator(),
              );
            } else {
              return StreamBuilder<QuerySnapshot>(
                stream: _pegawai
                    .where('nama', isEqualTo: currentdoc?.get('nama'))
                    .snapshots(),
                builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                return (snapshot.connectionState ==
                        ConnectionState.waiting)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, index) {
                      final DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                      initializeDateFormatting('id', null);
                      Timestamp timerstamp = documentSnapshot['tgl_lahir'];
                      Timestamp timerstamps = documentSnapshot['tgl_mulaitugas'];
                      var dates = timerstamps.toDate();
                      var date = timerstamp.toDate();
                      var tgllahir =DateFormat.yMMMMd('id').format(date);
                      var tglmulaitugas = DateFormat.yMMMMd('id').format(dates);
                      return Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20),
                      child: Column(
                      children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://img.freepik.com/free-vector/realistic-summer-background-with-vegetation_23-2148998580.jpg?w=1060&t=st=1687849389~exp=1687849989~hmac=4e829af04388c777d47fe73fbaa470a4f8c134646d4e6c1c349b1d8ecefd9065"),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        width: MediaQuery.of(context).size .width,
                        height: 150,
                        child: Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder:(BuildContext context) {
                                      return AlertDialog(
                                        content:
                                            Container(
                                          width: 300,
                                          height: 300,
                                          decoration:
                                              BoxDecoration(
                                            borderRadius:BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: NetworkImage(documentSnapshot["imageUrl"]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                     actions: [
                                       TextButton(
                                         child: Text(
                                             'Close'),
                                         onPressed:
                                             () {
                                           Navigator.of(
                                                   context)
                                               .pop();
                                         },
                                       ),
                                     ],);},
                                      );
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration:
                                          BoxDecoration(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    50),
                                        image:
                                            DecorationImage(
                                          image: NetworkImage(
                                              documentSnapshot[
                                                  "imageUrl"]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                            Positioned(
                            top: 60,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context) .push(CupertinoPageRoute(
                                        builder: (context) =>
                                            EditPegawai( documentSnapshot: documentSnapshot)));
                              },
                              icon: Icon(
                                FontAwesomeIcons.solidPenToSquare,
                                color: Colors.blueAccent,
                                grade: 20,
                              ),
                            ),),],),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              documentSnapshot['nama'],
                              style: TextStyle(
                                  fontWeight:FontWeight.bold,
                                  fontSize: 20,
                                  color:Colors.brown[600]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider(
                              thickness: 1,
                              indent: 15,
                              endIndent: 15,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: 10),
                              child: Card(
                                  color: Color.fromRGBO(
                                      254, 253, 228, 100),
                                  shape:
                                      const RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.only(
                                    topLeft:
                                        Radius.circular(10.0),
                                    bottomRight:
                                        Radius.circular(10.0),
                                    topRight:
                                        Radius.circular(10.0),
                                    bottomLeft:
                                        Radius.circular(10.0),
                                  )),
                                  elevation: 0.0,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text("Nip",
                                            style:
                                                TextStyleTitles()),
                                        subtitle: Text(
                                          documentSnapshot['nip'],
                                          style:
                                              TextStyleSubtitles(),
                                        ),
                                      ),
                                      Containers(),
                                      ListTile(
                                        title: Text(
                                            "Jenis Kelamin",
                                            style:
                                                TextStyleTitles()),
                                        subtitle: Text(
                                          documentSnapshot[
                                              'jenis_kelamin'],
                                          style:
                                              TextStyleSubtitles(),
                                        ),
                                      ),
                                      Containers(),
                                      ListTile(
                                        title: Text(
                                          "Tempat, Tanggal lahir",
                                          style:
                                              TextStyleTitles(),
                                        ),
                                        subtitle: Text(
                                          '${documentSnapshot['tempat_lahir']}, ${tgllahir.toString()}',
                                          style:
                                              TextStyleSubtitles(),
                                        ),
                                      ),
                                      Containers(),
                                      ListTile(
                                        title: Text(
                                          "Alamat",
                                          style:
                                              TextStyleTitles(),
                                        ),
                                        subtitle: Text(
                                          documentSnapshot[
                                              'alamat'],
                                          style:
                                              TextStyleSubtitles(),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: 10),
                              child: Card(
                              color: Color.fromRGBO(
                                  254, 253, 228, 100),
                              shape:
                                  const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.only(
                                topLeft:
                                    Radius.circular(10.0),
                                bottomRight:
                                    Radius.circular(10.0),
                                topRight:
                                    Radius.circular(10.0),
                                bottomLeft:
                                    Radius.circular(10.0),
                              )),
                              elevation: 0.0,
                              child: ExpansionTile(
                                title: Text(
                                    'Detail Selengkapnya',
                                    style:
                                        TextStyleSubtitles()),
                                children: [
                                  ListTile(
                                    title: Text(
                                      "Pendidikan Terakhir",
                                      style:
                                          TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      documentSnapshot[
                                          'pendidikan_terakhir'],
                                      style:
                                          TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Pangkat/Gol",
                                      style:
                                          TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      '${documentSnapshot['pangkat']}/${documentSnapshot['golongan']}',
                                      style:
                                          TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Jabatan",
                                      style:
                                          TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      '${documentSnapshot['jabatan']}',
                                      style:
                                          TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Status Pegawai",
                                      style:
                                          TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      '${documentSnapshot['status']}',
                                      style:
                                          TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Tanggal Mulai Tugas",
                                      style:
                                          TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      '${tglmulaitugas.toString()}',
                                      style:
                                          TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Status Pernikahan",
                                      style:
                                          TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      documentSnapshot[
                                          'status_pernikahan'],
                                      style:
                                          TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Jumlah Anak",
                                      style:
                                          TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      documentSnapshot[
                                              'jumlah_anak']
                                          .toString(),
                                      style:
                                          TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Nomor Telpon",
                                      style:
                                          TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      documentSnapshot[
                                          'telpon'],
                                      style:
                                          TextStyleSubtitles(),
                                    ),
                                  ),
                                ],
                              )),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            }
          })),
        ],
      ),
    );
  }
}

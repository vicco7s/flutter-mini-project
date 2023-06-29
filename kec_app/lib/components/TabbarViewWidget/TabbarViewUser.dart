
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/page/Dashboard%20user/profil/detailGajiHonorUser.dart';

class TabBarViewUsers extends StatefulWidget {
  TabBarViewUsers({required this.controllers});
  final TabController? controllers;

  @override
  State<TabBarViewUsers> createState() => _TabBarViewUsersState();
}

class _TabBarViewUsersState extends State<TabBarViewUsers> {
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
    return TabBarView(
      controller: widget.controllers,
      physics: ScrollPhysics(),
      children: [
        //surat masuk
        Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('suratmasuk')
                  .orderBy('no', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, index) {
                          final DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];
                          return Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0),
                            )),
                            elevation: 5.0,
                            child: ListTile(
                              onTap: () {
                                // Navigator.of(context).push(CupertinoPageRoute(
                                //     builder: (context) => DetailPegawaiCamat(documentSnapshot: documentSnapshot,)));
                              },
                              title: Text(documentSnapshot['no_berkas'],style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),),
                              subtitle: Text(documentSnapshot['alamat_pengirim']),
                              
                              trailing: (documentSnapshot['keterangan'] == 'sudah diterima')
                              ? Text(documentSnapshot['keterangan'],style: const TextStyle(color: Colors.green),)
                              : Text(documentSnapshot['keterangan'],style: const TextStyle(color: Colors.red),)
                            ),
                          );
                        },
                      );
              },
            ))
          ],
        ),
        // Surat Keluar
        Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('suratkeluar')
                  .orderBy('no', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, index) {
                          final DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];
                          return Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0),
                            )),
                            elevation: 5.0,
                            child: ListTile(
                              onTap: () {
                                // Navigator.of(context).push(CupertinoPageRoute(
                                //     builder: (context) => DetailPegawaiCamat(documentSnapshot: documentSnapshot,)));
                              },
                                title: Text(documentSnapshot['no_berkas'],style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold)),
                                subtitle: Text(documentSnapshot['alamat_penerima']),
                                trailing: (documentSnapshot['keterangan'] ==
                                      'sudah dikirim')
                                  ? Text(
                                      documentSnapshot['keterangan'],
                                      style: const TextStyle(color: Colors.green),
                                    )
                                  : Text(
                                      documentSnapshot['keterangan'],
                                      style: const TextStyle(color: Colors.red),
                                    ),
                              ),
                          );
                        },
                      );
              },
            ))
          ],
        ),
        // perjalanan dinas
        Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pdinas').where('nama', isEqualTo: currentdoc?.get('nama'))
                  .orderBy('id', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, index) {
                          final DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];
                          return Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0),
                            )),
                            elevation: 5.0,
                            child: ListTile(
                              onTap: () {
                                // Navigator.of(context).push(CupertinoPageRoute(
                                //     builder: (context) => DetailPegawaiCamat(documentSnapshot: documentSnapshot,)));
                              },
                                title: Text(documentSnapshot['nama'],
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold)),
                                subtitle: Text(documentSnapshot['tujuan']),
                                trailing: (documentSnapshot['status'] ==
                                      'diterima')
                                  ? Text(
                                      documentSnapshot['status'],
                                      style:
                                          const TextStyle(color: Colors.green),
                                    )
                                  : Text(
                                      documentSnapshot['status'],
                                      style: const TextStyle(color: Colors.red),
                                    )
                              ),
                          );
                        },
                      );
              },
            ))
          ],
        ),
        // gaji honor pegawai
        Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('gajihonorpegawai').where('nama', isEqualTo: currentdoc?.get('nama'))
                  .orderBy('id', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, index) {
                          final DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];
                          Timestamp timerstamp = documentSnapshot['tanggal'];
                          var date = timerstamp.toDate();
                          var tanggal = DateFormat.yMMMMd().format(date);
                          return Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0),
                            )),
                            elevation: 5.0,
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => DetailHonorPegawaiUser(documentSnapshot: documentSnapshot,)));
                              },
                              title: Text(documentSnapshot['nama'],style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  documentSnapshot['jabatan']),
                              trailing: Text(
                                tanggal.toString(),
                                style: TextStyle(color: (DateFormat('MMMM d, yyyy').parse(tanggal).isBefore(DateTime.now().subtract(Duration(days: 30)))) ? Colors.red : Colors.green,),
                              ),
                            ),
                          );
                        },
                      );
              },
            ))
          ],
        ),
      ],
    );
  }
}
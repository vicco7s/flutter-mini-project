import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/page/Dashboard%20Camat/SuratPengganti/detailSuratpenggantiCamat.dart';
import 'package:kec_app/report/reportSuratPengganti/SuratPengganti.dart';

class ListSuratPenggantiUser extends StatefulWidget {
  const ListSuratPenggantiUser({super.key});

  @override
  State<ListSuratPenggantiUser> createState() => _ListSuratPenggantiUserState();
}

class _ListSuratPenggantiUserState extends State<ListSuratPenggantiUser> {
  late FirebaseAuth _auth;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _currentUser = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Surat Pengganti PJD'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_currentUser?.uid)
                  .collection('suratpengganti')
                  .orderBy('id', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, index) {
                          final DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];

                          Timestamp timerstamp =
                              documentSnapshot['tanggal_surat'];
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
                                    builder: (context) => DetailSuratPengantiCamat(suratpenggantiDoc: documentSnapshot,
                                        )));
                              },
                              leading: IconButton(
                                icon: Icon(
                                  Icons.print,
                                  color: Colors.amberAccent,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) => ReportSuratPengganti(suratpenggantiDoc: documentSnapshot,
                                          )));
                                },
                              ),
                              title: Text(documentSnapshot['nama_pengganti'],
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                tanggal.toString(),
                                style: TextStyle(
                                  color: (DateFormat('MMMM d, yyyy')
                                          .parse(tanggal)
                                          .isBefore(DateTime.now()
                                              .subtract(Duration(days: 30))))
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

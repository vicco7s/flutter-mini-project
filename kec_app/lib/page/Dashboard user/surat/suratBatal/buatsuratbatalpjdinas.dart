import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/controller/controllerUser/controllerSuratBatal.dart';
import 'package:kec_app/page/Dashboard%20user/surat/suratBatal/detailSuratBatalPjd.dart';
import 'package:kec_app/page/Dashboard%20user/surat/suratBatal/formsuratbatalPJD.dart';
import 'package:kec_app/report/reportSuratBatal/SuratBatal.dart';
import 'package:kec_app/util/SpeedDialFloating.dart';
import 'package:intl/intl.dart';

class SuratbatalPjDinas extends StatefulWidget {
  const SuratbatalPjDinas({super.key});

  @override
  State<SuratbatalPjDinas> createState() => _SuratbatalPjDinasState();
}

class _SuratbatalPjDinasState extends State<SuratbatalPjDinas> {
  late FirebaseAuth _auth;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _currentUser = _auth.currentUser;
  }

  final dataSuratBatal = ControllerSuratBatal();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Surat Batal PJD'),
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
                  .collection('suratbatal')
                  .orderBy('id', descending: false)
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
                          return Dismissible(
                              key: Key(documentSnapshot.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                color: Colors.red,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onDismissed: (direction) async {
                                await dataSuratBatal.delete(
                                    documentSnapshot.id, context);
                              },
                              child: Card(
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
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) => DetailSuratBatalPJD(documentSnapshot: documentSnapshot)));
                                    },
                                    leading: IconButton(
                                      icon: Icon(
                                        Icons.print,
                                        color: Colors.amberAccent,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    ReportSuratBatal(
                                                      documentSnapshot:
                                                          documentSnapshot,
                                                    )));
                                      },
                                    ),
                                    title: Text(documentSnapshot['nama'],
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                      tanggal.toString(),
                                      style: TextStyle(
                                        color: (DateFormat('MMMM d, yyyy')
                                                .parse(tanggal)
                                                .isBefore(DateTime.now()
                                                    .subtract(
                                                        Duration(days: 30))))
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                    trailing: Text(
                                      documentSnapshot['status'],
                                      style: TextStyle(
                                          color: (documentSnapshot['status'] ==
                                                      'Disetujui' ||
                                                  documentSnapshot['status'] ==
                                                      'Mohon Tunggu'
                                              ? Colors.blue
                                              : Colors.red)),
                                    )),
                              ));
                        },
                      );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDialFloating(
        animatedIcons: AnimatedIcons.add_event,
        ontap: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: ((context) => FormSuratBatalPJD()))),
      ),
    );
  }
}

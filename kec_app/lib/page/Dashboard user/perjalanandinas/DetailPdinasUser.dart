import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/controller/controllerUser/controllerPdinasUser.dart';
import 'package:kec_app/page/Dashboard%20user/buktiperjalanandinas/detailbuktiKegiatanPJD.dart';
import 'package:kec_app/page/Dashboard%20user/buktiperjalanandinas/formbuktiKegiatanPJD.dart';

class DetailPdinasUser extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const DetailPdinasUser({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {

    final Query<Map<String, dynamic>> _buktiKegiatanPJD =
      FirebaseFirestore.instance.collection('buktikegiatanpjd');

    Timestamp timerstamp = documentSnapshot['tanggal_mulai'];
    Timestamp timerstamps = documentSnapshot['tanggal_berakhir'];
    var date = timerstamp.toDate();
    var dates = timerstamps.toDate();
    var timers = DateFormat.yMMMMd().format(date);
    var timer = DateFormat.yMMMMd().format(dates);

    final dataPdinasUser = UpdatePdinasUser();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Detail Perjalanan Dinas'),
        centerTitle: true,
      ),
      body: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 15.0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                  )),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Text(
                          "No :",
                          style:
                              TextStyle(fontSize: 18, color: Colors.blueAccent),
                        ),
                        title: Text(
                          documentSnapshot['id'].toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ListTile(
                        leading: const Text(
                          "Nama :",
                          style:
                              TextStyle(fontSize: 18, color: Colors.blueAccent),
                        ),
                        title: Text(
                          documentSnapshot['nama'],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ListTile(
                        leading: const Text(
                          "Tujuan :",
                          style:
                              TextStyle(fontSize: 18, color: Colors.blueAccent),
                        ),
                        title: Text(
                          documentSnapshot['tujuan'],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ListTile(
                        leading: const Text(
                          "Keperluan :",
                          style:
                              TextStyle(fontSize: 18, color: Colors.blueAccent),
                        ),
                        title: Text(
                          documentSnapshot['keperluan'],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ListTile(
                        leading: const Text(
                          "Tanggal Mulai :",
                          style:
                              TextStyle(fontSize: 18, color: Colors.blueAccent),
                        ),
                        title: Text(
                          timers.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ListTile(
                        leading: const Text(
                          "Tanggal Berakhir :",
                          style:
                              TextStyle(fontSize: 18, color: Colors.blueAccent),
                        ),
                        title: Text(
                          timer.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ListTile(
                        leading: const Text(
                          "Status :",
                          style:
                              TextStyle(fontSize: 18, color: Colors.blueAccent),
                        ),
                        title: (documentSnapshot['status'] == 'diterima')
                            ? Text(
                                documentSnapshot['status'],
                                style: const TextStyle(
                                    color: Colors.green, fontSize: 18),
                              )
                            : Text(
                                documentSnapshot['status'],
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 18),
                              ),
                      ),
                      ListTile(
                          leading: const Text(
                            "Konfirmasi :",
                            style:
                                TextStyle(fontSize: 18, color: Colors.blueAccent),
                          ),
                          title: (documentSnapshot['konfirmasi_kirim'] ==
                                  'sudah dikirim')
                              ? Text(
                                  documentSnapshot['konfirmasi_kirim'],
                                  style: const TextStyle(
                                      color: Colors.green, fontSize: 18),
                                )
                              : Text(
                                  documentSnapshot['konfirmasi_kirim'],
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 18),
                                ),
                          trailing: IconButton(
                              onPressed: () async {
                                await dataPdinasUser.update(
                                    documentSnapshot, context);
                              },
                              icon: Icon(
                                FontAwesomeIcons.solidPenToSquare,
                                color: Colors.blue,
                              ))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (documentSnapshot['konfirmasi_kirim'] ==
                                  'sudah dikirim') {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) =>
                                        FormBuktiKegiatanPJD(documentSnapshot: documentSnapshot,)));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        'jika Ingin Mengirim Bukti PJD , mohon ubah konfirmasi pada bagian tombol pensil')));
                              }
                            },
                            child: const Text("Kirim Bukti Perjalanan Dinas"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // background
                              foregroundColor: Colors.white, // foreground
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            
            Padding(
            padding: const EdgeInsets.only(),
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(5.0),
                topRight: Radius.circular(15.0),
                bottomLeft: Radius.circular(5.0),
              )),
              elevation: 5.0,
              child: ListTile(
              title: Text('Riwayat Pengiriman Bukti PJD',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              subtitle: StreamBuilder<QuerySnapshot>(
              stream: _buktiKegiatanPJD
                .where("keperluan", isEqualTo: documentSnapshot['keperluan'])
                .orderBy('id', descending: true)
                .snapshots(),
              builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot docSnapshot = documents[index];
                    Timestamp timerstamp = docSnapshot['tgl_awal'];
                    var date = timerstamp.toDate();
                    var tanggal_awal = DateFormat.yMMMMd().format(date);
                    return Padding(
                      padding: const EdgeInsets.all(0.0),
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
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: ((context) => DetailBuktiKegiatanPJD(
                                      documentSnapshot: docSnapshot))));
                            },
                            title: Text(docSnapshot['nama'],
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold)),
                            trailing: Text(tanggal_awal.toString(),style: TextStyle(
                                  color: (DateFormat('MMMM d, yyyy')
                                          .parse(tanggal_awal)
                                          .isBefore(DateTime.now()
                                              .subtract(Duration(days: 30))))
                                      ? Colors.red
                                      : Colors.green,
                                ),),
                            ),
                      ),
                    );
                  },
                );
              } else {
                return Text('No data available');
              }
            },
          ),
          ),
          ),
        ),       
        ],
      ),
    );
  }
}

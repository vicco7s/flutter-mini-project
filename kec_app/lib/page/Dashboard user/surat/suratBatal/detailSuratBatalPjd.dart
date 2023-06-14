
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailSuratBatalPJD extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const DetailSuratBatalPJD({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {

    final Timestamp timerStamp = documentSnapshot['tanggal_surat'];
    final Timestamp timerStamps = documentSnapshot['tanggal_perjalanan'];
    var date = timerStamp.toDate();
    var dates = timerStamps.toDate();
    var tanggal_surat = DateFormat.yMMMMd().format(date);
    var tanggal_perjalanan = DateFormat.yMMMMd().format(dates);

    return Scaffold(
        appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text('Detail Surat Batal'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(padding: EdgeInsets.all(10.0),
            child: Card(
              elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                  topRight: Radius.circular(5.0),
                  bottomLeft: Radius.circular(5.0),
                )),
                child: Column(children: [
                  ListTile(
                      leading: const Text(
                        "No :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot['id'].toInt().toString(),
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
                        "Tanggal Surat :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        tanggal_surat.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ListTile(
                      leading: const Text(
                        "Tanggal Perjalanan :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        tanggal_perjalanan.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ListTile(
                      title: const Text(
                        "Alasan",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        documentSnapshot['alasan'],
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ListTile(
                      leading: const Text(
                        "Status :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot['status'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ListTile(
                      leading: const Text(
                        "Keterangan :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot['keterangan'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                ],),
            ),
          )
        ]),
      ),
    );
  }
}
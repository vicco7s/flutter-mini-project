import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kec_app/controller/controllerUser/controllerSuratBatal.dart';

class DetailSuratBatalCamat extends StatelessWidget {
  final QueryDocumentSnapshot suratBatalDoc;
  final DocumentSnapshot documentSnapshot;
  const DetailSuratBatalCamat(
      {super.key, required this.suratBatalDoc, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {

    final Timestamp timerStamp = suratBatalDoc['tanggal_surat'];
    final Timestamp timerStamps = suratBatalDoc['tanggal_perjalanan'];
    var date = timerStamp.toDate();
    var dates = timerStamps.toDate();

    initializeDateFormatting('id', null);
    var tanggal_surat = DateFormat.yMMMMd('id').format(date);
    var tanggal_perjalanan = DateFormat.yMMMMd('id').format(dates);

    final dataSuratBatal = ControllerSuratBatal();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Detail Surat batal'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Card(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
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
                      style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                    ),
                    title: Text(
                      suratBatalDoc['id'].toInt().toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                    leading: const Text(
                      "Nama :",
                      style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                    ),
                    title: Text(
                      suratBatalDoc['nama'],
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                    leading: const Text(
                      "Tanggal Surat :",
                      style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                    ),
                    title: Text(
                      tanggal_surat.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                    leading: const Text(
                      "Tanggal Perjalanan :",
                      style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                    ),
                    title: Text(
                      tanggal_perjalanan.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      "Alasan",
                      style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      suratBatalDoc['alasan'],
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ListTile(
                    leading: const Text(
                      "Status :",
                      style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                    ),
                    title: Text(
                      suratBatalDoc['status'],
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                    leading: const Text(
                      "Keterangan :",
                      style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                    ),
                    title: Text(
                      suratBatalDoc['keterangan'],
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await dataSuratBatal.update(
                          documentSnapshot, suratBatalDoc, context);
                    },
                    child: const Text("Update"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // background
                      foregroundColor: Colors.white, // foreground
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}

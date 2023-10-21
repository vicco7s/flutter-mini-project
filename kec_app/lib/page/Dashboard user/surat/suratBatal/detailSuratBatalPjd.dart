import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../../../util/ContainerDeviders.dart';
import '../../../../util/controlleranimasiloading/CircularControlAnimasiProgress.dart';
import '../../../../util/controlleranimasiloading/controlleranimasiprogressloading.dart';

class DetailSuratBatalPJD extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const DetailSuratBatalPJD({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id', null);
    final Timestamp timerStamp = documentSnapshot['tanggal_surat'];
    final Timestamp timerStamps = documentSnapshot['tanggal_perjalanan'];
    var date = timerStamp.toDate();
    var dates = timerStamps.toDate();
    var tanggal_surat = DateFormat.yMMMMd('id').format(date);
    var tanggal_perjalanan = DateFormat.yMMMMd('id').format(dates);

    return Scaffold(
      backgroundColor: Colors.white,
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
          child: FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ColorfulLinearProgressIndicator();
          } else {
            return Column(children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Card(
                  elevation: 0.0,
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: ListTile(
                    title: Text(
                      documentSnapshot['nama'],
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Divider(
                indent: 100,
                endIndent: 100,
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.topLeft,
                child: Text(
                  "Tanggal Surat Batal",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Card(
                elevation: 0.0,
                color: Color.fromARGB(255, 236, 236, 236),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Column(
                  children: [
                    Divider(
                      indent: 150,
                      endIndent: 150,
                      thickness: 2,
                    ),
                    ListTile(
                      leading: Text(
                        "Tanggal Surat",
                        style: TextStyle(
                            color: Colors.blueAccent[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      trailing: Text(
                        tanggal_surat.toString(),
                        style: TextStyle(
                            color: Colors.blueAccent[200], fontSize: 16),
                      ),
                    ),
                    Containers(),
                    ListTile(
                      leading: Text(
                        "Tanggal Perjalanan Dinas",
                        style: TextStyle(
                            color: Colors.blueAccent[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      trailing: Text(
                        tanggal_perjalanan.toString(),
                        style: TextStyle(
                            color: Colors.blueAccent[200], fontSize: 16),
                      ),
                    ),
                  ],
                )),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.topLeft,
                child: Text(
                  "Alasan",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Card(
                elevation: 0.0,
                color: Color.fromARGB(255, 236, 236, 236),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
                child: ListTile(
                  title: Text(documentSnapshot['alasan'],
                      style: TextStyle(
                          color: Colors.blueAccent[200],
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                )),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.topLeft,
                child: Text(
                  "Keterangan",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Card(
                elevation: 0.0,
                color: Color.fromARGB(255, 236, 236, 236),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: ListTile(
                  title: Text(documentSnapshot['keterangan'],
                      style: TextStyle(
                          color: Colors.blueAccent[200],
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                )),
              ),
              SizedBox(
                height: 10,
              )
            ]);
          }
        },
      )),
    );
  }
}

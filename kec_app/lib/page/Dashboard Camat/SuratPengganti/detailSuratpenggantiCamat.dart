import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../util/ContainerDeviders.dart';
import '../../../util/controlleranimasiloading/controlleranimasiprogressloading.dart';

class DetailSuratPengantiCamat extends StatelessWidget {
  final DocumentSnapshot suratpenggantiDoc;
  const DetailSuratPengantiCamat({super.key, required this.suratpenggantiDoc});

  @override
  Widget build(BuildContext context) {
    final Timestamp timerStamp = suratpenggantiDoc['tanggal_surat'];
    final Timestamp timerStamps = suratpenggantiDoc['tanggal_perjalanan'];
    var date = timerStamp.toDate();
    var dates = timerStamps.toDate();
    initializeDateFormatting('id', null);
    var tanggal_surat = DateFormat.yMMMMd('id').format(date);
    var tanggal_perjalanan = DateFormat.yMMMMd('id').format(dates);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Detail Surat Pengganti'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: Future.delayed(Duration(seconds: 3)),
          builder:(context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ColorfulLinearProgressIndicator();
          }else{
            return Column(
          children: [
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10,bottom: 10),
                child: Card(
                  elevation: 0.0,
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: ListTile(
                    title: Text(
                      suratpenggantiDoc['nama'],
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(suratpenggantiDoc['jabatan'],style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                  children: [
                    Icon(FontAwesomeIcons.downLong,color: Colors.blueAccent,)
                  ],)
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Card(
                  elevation: 0.0,
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: ListTile(
                    title: Text('Nama Pengganti',style: TextStyle(fontSize: 10, color:Colors.white),),
                    subtitle: Text(
                      suratpenggantiDoc['nama_pengganti'],
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
                  title: Text(suratpenggantiDoc['alasan'],
                      style: TextStyle(
                          color: Colors.blueAccent[200],
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                )),
              ),
              SizedBox(
                height: 10,
              ),
             
          ],
        );
          }
        },)
      ),
    );
  }
}

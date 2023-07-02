import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kec_app/controller/controllerUser/controllerSuratBatal.dart';
import 'package:kec_app/util/ContainerDeviders.dart';
import 'package:kec_app/util/controlleranimasiloading/controlleranimasiprogressloading.dart';

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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Detail Surat batal'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              await dataSuratBatal.update(
                          documentSnapshot, suratBatalDoc, context);
            }, icon: Icon(FontAwesomeIcons.solidPenToSquare))
        ],
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
                      suratBatalDoc['nama'],
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        suratBatalDoc['status'],
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
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
                  title: Text(suratBatalDoc['alasan'],
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
                  title: Text(suratBatalDoc['keterangan'],
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

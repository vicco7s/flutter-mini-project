
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:kec_app/util/ContainerDeviders.dart';
import 'package:kec_app/util/controlleranimasiloading/controlleranimasiprogressloading.dart';

class DetailSuratKeluarUser extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const DetailSuratKeluarUser({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id',null);
    Timestamp timerstamp = documentSnapshot['tanggal'];
    var date = timerstamp.toDate();
    var timers = DateFormat.yMMMMd('id').format(date);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Detail Surat Keluar'),
        centerTitle: true,
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
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Card(
                      elevation: 0.0,
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: ListTile(
                        title: Text(documentSnapshot['no_berkas'],style: TextStyle(color: Colors.white,fontSize: 14),),
                        trailing: Container(
                          padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          documentSnapshot['keterangan'],
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
                      "Tanggal Surat Keluar",
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
                            timers.toString(),
                            style: TextStyle(
                                color: Colors.blueAccent[200], fontSize: 16),
                          ),
                        ),
                        Containers(),
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
                      "Penerima",
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
                      title: Text(documentSnapshot['alamat_penerima'],
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
                      "Perihal",
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
                      title: Text(documentSnapshot['perihal'],
                          style: TextStyle(
                              color: Colors.blueAccent[200],
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    )),
                  ),
              ],
            );
              }
            },)
      ),
    );
  }
}
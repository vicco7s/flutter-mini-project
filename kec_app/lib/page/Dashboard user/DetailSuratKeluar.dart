
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class DetailSuratKeluarUser extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const DetailSuratKeluarUser({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    Timestamp timerstamp = documentSnapshot['tanggal'];
    var date = timerstamp.toDate();
    var timers = DateFormat.yMMMMd().format(date);
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
        child: Column(
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
                      leading: Text(
                        "No :",
                        style: TextStyle(fontSize: 18,color: Colors.blueAccent),
                      ),
                      title: Text(documentSnapshot['no'].toString(),style: TextStyle(fontSize: 18)),
                    ),
                    ListTile(
                      leading: Text(
                        "No Berkas :",
                        style: TextStyle(fontSize: 18,color: Colors.blueAccent),
                      ),
                      title: Text(documentSnapshot['no_berkas'],style: TextStyle(fontSize: 18)),
                    ),
                    ListTile(
                      leading: Text(
                        "Penerima :",
                        style: TextStyle(fontSize: 18,color: Colors.blueAccent),
                      ),
                      title: Text(documentSnapshot['alamat_penerima'],style: TextStyle(fontSize: 18),),
                    ),
                    ListTile(
                      leading: Text(
                        "Tanggal Surat :",
                        style: TextStyle(fontSize: 18,color: Colors.blueAccent),
                      ),
                      title: Text(timers.toString(),style: TextStyle(fontSize: 18),),
                    ),
                    ListTile(
                      title: Text(
                        "Perihal",
                        style: TextStyle(fontSize: 18,color: Colors.blueAccent),
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        documentSnapshot['perihal'],
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: Text(
                        "Keterangan :",
                        style: TextStyle(fontSize: 18,color: Colors.blueAccent),
                      ),
                      title: (documentSnapshot['keterangan'] == 'sudah dikirim')
                          ? Text(
                              documentSnapshot['keterangan'],
                              style: const TextStyle(color: Colors.green,fontSize: 18),
                            )
                          : Text(
                              documentSnapshot['keterangan'],
                              style: const TextStyle(color: Colors.red,fontSize: 18),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            
          ],
        ),
      ),
    );
  }
}
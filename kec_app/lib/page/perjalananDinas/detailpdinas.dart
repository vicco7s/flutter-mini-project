import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/controller/controllerpdinas.dart';

class DetailPdinas extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const DetailPdinas({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    Timestamp timerstamp = documentSnapshot['tanggal_mulai'];
    Timestamp timerstamps = documentSnapshot['tanggal_berakhir'];
    var date = timerstamp.toDate();
    var dates = timerstamps.toDate();
    var timers = DateFormat.yMMMMd().format(date);
    var timer = DateFormat.yMMMMd().format(dates);

    final dataPdinas = ControllerPDinas();

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
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () async {
                  await dataPdinas.update(documentSnapshot, context);
                },
                child: const Text("Update"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // background
                  foregroundColor: Colors.white, // foreground
                ),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  await dataPdinas.delete(documentSnapshot.id, context);
                },
                child: const Text("Delete"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // background
                  foregroundColor: Colors.white, // foreground
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kec_app/components/DropdownButtomFormUpdates.dart';
import 'package:kec_app/controller/controllerPegawai.dart';
import 'package:kec_app/page/Pegawai/pegawaiASN.dart';
import 'package:kec_app/util/OptionDropDown.dart';

class DetailPagePegawai extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const DetailPagePegawai({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    final dataPegawai = ControllerPegawai();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Detail Pegawai'),
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
                        documentSnapshot["id"].toString(),
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
                        documentSnapshot["nama"],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Nip :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot["nip"].toInt().toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Pangkat :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot["pangkat"],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Golongan :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot["golongan"],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Jabatan :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot["jabatan"],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Status :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot["status"],
                        style: TextStyle(fontSize: 18),
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
                  await dataPegawai.update(documentSnapshot, context);
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
                  await dataPegawai.delete(documentSnapshot.id, context);
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

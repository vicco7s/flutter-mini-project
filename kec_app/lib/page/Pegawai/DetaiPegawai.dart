import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kec_app/controller/controllerPegawai.dart';
import 'package:kec_app/page/Pegawai/editpegawai.dart';
import 'package:intl/intl.dart';

class DetailPagePegawai extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const DetailPagePegawai({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {

    Timestamp timerstamp = documentSnapshot['tgl_lahir'];
    Timestamp timerstamps = documentSnapshot['tgl_mulaitugas'];
    var dates = timerstamps.toDate();
    var date = timerstamp.toDate();
    var tgllahir = DateFormat.yMMMMd().format(date);
    var tglmulaitugas = DateFormat.yMMMMd().format(dates);

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
                      trailing: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Container(
                                  width: 300,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(documentSnapshot["imageUrl"]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                  child: Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: NetworkImage(documentSnapshot["imageUrl"]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
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
                        "Jenis Kelamin :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot["jenis_kelamin"],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Tanggal Lahir :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        tgllahir.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Tempat Lahir :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot['tempat_lahir'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Tanggal Mulai Tugas :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        tglmulaitugas.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Alamat :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot['alamat'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Pendidikan Terakhir :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot['pendidikan_terakhir'],
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
                    ListTile(
                      leading: const Text(
                        "Status Pernikahan :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot['status_pernikahan'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Jumlah Anak :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot['jumlah_anak'].toInt().toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Telpon :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot['telpon'].toInt().toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                const SizedBox(
                  height: 20,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              EditPegawai(documentSnapshot: documentSnapshot)));
                      // await dataPegawai.update(documentSnapshot, context);
                    },
                    child: const Text("Update"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // background
                      foregroundColor: Colors.white, // foreground
                    ),
                  ),
                  SizedBox(
                    width: 30,
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
            ),
            
          ],
        ),
      ),
    );
  }
}

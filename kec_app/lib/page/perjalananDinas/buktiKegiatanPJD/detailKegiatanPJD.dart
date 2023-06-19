import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/controller/controllerPerjalananDinas/controllerBuktiKegiatanPJD.dart';

class DetailKegiatanPJD extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const DetailKegiatanPJD({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id', null);

    Timestamp timerstamp = documentSnapshot['tgl_awal'];
    var date = timerstamp.toDate();
    var tanggal_awal = DateFormat('dd', 'id').format(date);

    Timestamp timerstamps = documentSnapshot['tgl_akhir'];
    var dates = timerstamps.toDate();
    var tanggal_akhir = DateFormat.yMMMMd('id').format(dates);

    final dataBuktiKegiatan = ControllerBuktiKegiatanPJD();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text('Detail Bukti Kegiatan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                        "Nip :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot['nip'],
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
                        documentSnapshot['jabatan'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        "Keperluan :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      subtitle: Text(
                        documentSnapshot['keperluan'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Tempat :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        documentSnapshot['tempat'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Tanggal :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      title: Text(
                        '${tanggal_awal.toString()} - ${tanggal_akhir.toString()}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        "Dasar :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      subtitle: Text(
                        documentSnapshot['dasar'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        "Hasil kegiatan :",
                        style:
                            TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                      subtitle: Text(
                        documentSnapshot['hasil'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await dataBuktiKegiatan.update(documentSnapshot, context);
                          },
                          child: const Text("Update"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // background
                            foregroundColor: Colors.white, // foreground
                          ),
                        ),
                      ],
                    ),
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

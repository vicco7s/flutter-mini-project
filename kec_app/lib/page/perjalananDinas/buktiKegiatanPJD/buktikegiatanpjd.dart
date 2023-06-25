import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/controller/controllerPerjalananDinas/controllerBuktiKegiatanPJD.dart';
import 'package:kec_app/page/perjalananDinas/buktiKegiatanPJD/detailKegiatanPJD.dart';
import 'package:kec_app/page/perjalananDinas/buktiKegiatanPJD/formbuktiKegiatanPJD.dart';
import 'package:kec_app/report/Report_pDinas/ReportBuktiKegiatanPJD.dart';
import 'package:kec_app/util/SpeedDialFloating.dart';

class BuktiKegiatanPJD extends StatefulWidget {
  const BuktiKegiatanPJD({super.key});

  @override
  State<BuktiKegiatanPJD> createState() => _BuktiKegiatanPJDState();
}

class _BuktiKegiatanPJDState extends State<BuktiKegiatanPJD> {
  String search = '';

  final Query<Map<String, dynamic>> _buktiKegiatan =
      FirebaseFirestore.instance.collection('buktikegiatanpjd');

  final dataBuktiKegiatan = ControllerBuktiKegiatanPJD();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Bukti Kegiatan PJD'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari Nama....',
            ),
            onChanged: (value) {
              setState(() {
                search = value;
              });
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: (search != "" && search != null)
                ? _buktiKegiatan
                    .orderBy("nama")
                    .startAt([search]).endAt([search + "\uf8ff"]).snapshots()
                : _buktiKegiatan.orderBy('id', descending: true).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, index) {
                        final DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        Timestamp timerstamp = documentSnapshot['tgl_awal'];
                        var date = timerstamp.toDate();
                        var tanggal = DateFormat.yMMMMd().format(date);
                        return Dismissible(
                            key: Key(documentSnapshot.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              color: Colors.red,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onDismissed: (direction) async {
                              await dataBuktiKegiatan.delete(
                                  documentSnapshot.id, context);
                            },
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0),
                              )),
                              elevation: 5.0,
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) => DetailKegiatanPJD(
                                            documentSnapshot: documentSnapshot,
                                          )));
                                },
                                leading: IconButton(
                                      icon: Icon(
                                        Icons.print,
                                        color: Colors.amberAccent,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    ReportBuktiKegiatanPJD(
                                                      documentSnapshot:
                                                          documentSnapshot,
                                                    )));
                                      },
                                    ),
                                title: Text(documentSnapshot['nama'],
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(documentSnapshot['tempat']),
                                trailing: Text(
                                  tanggal.toString(),
                                  style: TextStyle(
                                    color: (DateFormat('MMMM d, yyyy')
                                            .parse(tanggal)
                                            .isBefore(DateTime.now()
                                                .subtract(Duration(days: 30))))
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ),
                            ));
                      },
                    );
            },
          ),
        ),
      ]),
      // floatingActionButton: SpeedDialFloating(
      //   animatedIcons: AnimatedIcons.add_event,
      //   ontap: () {
      //     Navigator.of(context).push(CupertinoPageRoute(
      //         builder: ((context) => FormBuktiKegiatanPJD())));
      //   },
      // ),
    );
  }
}

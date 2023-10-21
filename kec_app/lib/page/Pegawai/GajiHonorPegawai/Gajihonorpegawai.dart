import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sikep/util/SpeedDialFloating.dart';

import '../../../controller/controlerPegawai/controllerHonorGaji.dart';
import '../../../util/controlleranimasiloading/CircularControlAnimasiProgress.dart';
import 'DetailGajiHonor.dart';
import 'FormGajiHonor.dart';

class GajiHonorPegawai extends StatefulWidget {
  const GajiHonorPegawai({super.key});

  @override
  State<GajiHonorPegawai> createState() => _GajiHonorPegawaiState();
}

class _GajiHonorPegawaiState extends State<GajiHonorPegawai> {
  final _formkey = GlobalKey<FormState>();
  String search = '';

  final Query<Map<String, dynamic>> _gajihonor =
      FirebaseFirestore.instance.collection('gajihonorpegawai');

  final dataHonorHGaji = ControllerGajiHonor();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Pembayaran Honor'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
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
              child: FutureBuilder(
            future: Future.delayed(Duration(seconds: 3)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: ColorfulCirclePrgressIndicator(),
                );
              } else {
                return StreamBuilder<QuerySnapshot>(
                  stream: (search != "" && search != null)
                      ? _gajihonor.orderBy("nama").orderBy("id", descending: true).startAt([search]).endAt(
                          [search + "\uf8ff"]).snapshots()
                      : _gajihonor.orderBy('id', descending: true).snapshots(),
                  builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, index) {
                      final DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                      Timestamp timerstamp =
                          documentSnapshot['tanggal'];
                      var date = timerstamp.toDate();
                      var tanggal = DateFormat.yMMMMd().format(date);
                      return Dismissible(
                          key: Key(documentSnapshot.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            color: Colors.red,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onDismissed: (direction) async {
                            await dataHonorHGaji.delete(
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
                            Navigator.of(context).push(
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        DetailHonorPegawai(
                                          documentSnapshot:
                                              documentSnapshot,
                                        )));
                          },
                          title: Text(documentSnapshot['nama'],
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold)),
                          subtitle:
                              Text(documentSnapshot['jabatan']),
                          trailing: Text(
                            tanggal.toString(),
                            style: TextStyle(
                              color: (DateFormat('MMMM d, yyyy')
                                      .parse(tanggal)
                                      .isBefore(DateTime.now()
                                          .subtract(
                                              Duration(days: 30))))
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ),
                      ));
                    },
                  );
                  },
                );
              }
            },
          )),
        ],
      ),
      floatingActionButton: SpeedDialFloating(
        animatedIcons: AnimatedIcons.add_event,
        ontap: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: ((context) => FormGajiHonorPegawai()))),
      ),
    );
  }
}

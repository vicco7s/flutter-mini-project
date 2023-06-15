import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/controller/controllerSurat/ControllerSuratPenganti.dart';
import 'package:kec_app/page/agenda/suratPegantiPegawaiPJD/detaiSuratPenganti.dart';
import 'package:kec_app/report/reportSuratPengganti/SuratPengganti.dart';
import 'package:kec_app/util/SpeedDialFloating.dart';
import 'package:intl/intl.dart';
import 'tambahSuratPenganti.dart';

class ListSuratPenganti extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const ListSuratPenganti({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  State<ListSuratPenganti> createState() => _ListSuratPengantiState();
}

class _ListSuratPengantiState extends State<ListSuratPenganti> {
  late DocumentSnapshot documentSnapshot;

  @override
  void initState() {
    super.initState();
    documentSnapshot = widget.documentSnapshot;
  }

  final dataSuratPengganti = ControllerSuratpengganti();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Surat Pengganti PJD'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: documentSnapshot.reference
                  .collection('suratpengganti')
                  .orderBy('id', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final List<QueryDocumentSnapshot> suratPenggantiDocuments =
                    snapshot.data!.docs;
                return ListView.builder(
                  itemCount: suratPenggantiDocuments.length,
                  itemBuilder: (BuildContext context, int index) {
                    final QueryDocumentSnapshot suratPenggantiDoc =
                        suratPenggantiDocuments[index];

                    Timestamp timerstamp = suratPenggantiDoc['tanggal_surat'];
                    var date = timerstamp.toDate();
                    var tanggal = DateFormat.yMMMMd().format(date);

                    return Dismissible(
                        key: Key(suratPenggantiDoc.id),
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
                          await dataSuratPengganti.delete(
                              documentSnapshot, suratPenggantiDoc.id, context);
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
                                        builder: (context) => DetailSuratPengganti(suratPenggantiDoc: suratPenggantiDoc, documentSnapshot: documentSnapshot)));
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
                                              ReportSuratPengganti(suratpenggantiDoc: suratPenggantiDoc,
                                              )));
                                },
                              ),
                              title: Text(suratPenggantiDoc['nama_pengganti'],
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                tanggal.toString(),
                                style: TextStyle(
                                  color: (DateFormat('MMMM d, yyyy')
                                          .parse(tanggal)
                                          .isBefore(DateTime.now()
                                              .subtract(Duration(days: 30))))
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),),
                        ));
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: SpeedDialFloating(
        animatedIcons: AnimatedIcons.add_event,
        ontap: () => Navigator.of(context).push(CupertinoPageRoute(
            builder: ((context) => FormSuratPenganti(
                  documentSnapshot: documentSnapshot,
                )))),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/controller/controllerUser/controllerSuratBatal.dart';
import 'package:kec_app/page/Dashboard%20Camat/SuratBatal/detailsuratBatalcamat.dart';
import 'package:kec_app/report/reportSuratBatal/SuratBatal.dart';

class ListSuratBatalUser extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const ListSuratBatalUser({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  State<ListSuratBatalUser> createState() => _ListSuratBatalUserState();
}

class _ListSuratBatalUserState extends State<ListSuratBatalUser> {
  late DocumentSnapshot documentSnapshot;

  @override
  void initState() {
    super.initState();
    documentSnapshot = widget.documentSnapshot;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Surat Batal PJD'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: documentSnapshot.reference
                  .collection('suratbatal')
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
                final List<QueryDocumentSnapshot> suratBatalDocuments =
                    snapshot.data!.docs;
                return ListView.builder(
                  itemCount: suratBatalDocuments.length,
                  itemBuilder: (BuildContext context, int index) {
                    final QueryDocumentSnapshot suratBatalDoc =
                        suratBatalDocuments[index];

                    Timestamp timerstamp = suratBatalDoc['tanggal_surat'];
                    var date = timerstamp.toDate();
                    var tanggal = DateFormat.yMMMMd().format(date);

                    return Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                      )),
                      elevation: 5.0,
                      child: ListTile(
                          onTap: () async {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => DetailSuratBatalCamat(
                                    suratBatalDoc: suratBatalDoc, documentSnapshot: documentSnapshot,)));
                          },
                          leading: IconButton(
                            icon: Icon(
                              Icons.print,
                              color: Colors.amberAccent,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => ReportSuratBatal(
                                        documentSnapshot: suratBatalDoc,
                                      )));
                            },
                          ),
                          title: Text(suratBatalDoc['nama'],
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
                          ),
                          trailing: Text(
                            suratBatalDoc['status'],
                            style: TextStyle(
                                color:
                                    (suratBatalDoc['status'] == 'Disetujui' ||
                                            suratBatalDoc['status'] ==
                                                'Mohon Tunggu'
                                        ? Colors.blue
                                        : Colors.red)),
                          )),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/page/Dashboard%20Camat/SuratBatal/listsuratBatalUser.dart';
import 'package:kec_app/report/reportSuratBatal/ReporSuratBatal.dart';

class SuratBatalCamat extends StatefulWidget {
  const SuratBatalCamat({super.key});

  @override
  State<SuratBatalCamat> createState() => _SuratBatalCamatState();
}

class _SuratBatalCamatState extends State<SuratBatalCamat> {
  String search = '';

  final Query<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Pegawai Surat Batal'),
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
                  ? _usersCollection
                      .orderBy("nama")
                      .startAt([search]).endAt([search + "\uf8ff"]).snapshots()
                  : _usersCollection.where("rool", isEqualTo: "Pegawai").snapshots(),
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
                              onTap: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => ListSuratBatalUser(documentSnapshot: documentSnapshot,)));
                              },
                              title: Text(documentSnapshot['nama'],style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
                              subtitle: Text(
                                  documentSnapshot['email']),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        

      ]),
    );
  }
}


// Expanded(
//           child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
//             future: _usersCollection.get(),
//             builder: (BuildContext context,
//                 AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }

//               if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               }

//               final List<QueryDocumentSnapshot<Map<String, dynamic>>>
//                   userDocuments = snapshot.data!.docs;

//               return ListView.builder(
//                 itemCount: userDocuments.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final QueryDocumentSnapshot<Map<String, dynamic>> userDoc =
//                       userDocuments[index];
//                   final CollectionReference<Map<String, dynamic>>
//                       suratBatalCollection =
//                       userDoc.reference.collection('suratbatal');

//                   return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                     stream: (search != "" && search != null) ?
//                             suratBatalCollection
//                             .where("nama", isGreaterThanOrEqualTo: search)
//                             .where("nama", isLessThanOrEqualTo: search + "\uf8ff")
//                             .orderBy("nama")
//                             .snapshots()
//                             : suratBatalCollection.snapshots(),
//                     builder: (BuildContext context,
//                         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
//                             suratBatalSnapshot) {
//                       if (suratBatalSnapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       }

//                       if (suratBatalSnapshot.hasError) {
//                         return Center(
//                             child: Text('Error: ${suratBatalSnapshot.error}'));
//                       }

//                       final List<QueryDocumentSnapshot<Map<String, dynamic>>>
//                           suratBatalDocuments = suratBatalSnapshot.data!.docs;

//                       return ListView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: suratBatalDocuments.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           final QueryDocumentSnapshot<Map<String, dynamic>>
//                               suratBatalDoc = suratBatalDocuments[index];

//                           Timestamp timerstamp =
//                               suratBatalDoc['tanggal_surat'];
//                           var date = timerstamp.toDate();
//                           var tanggal = DateFormat.yMMMMd().format(date);

//                           return Card(
//                               shape: const RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(15.0),
//                                 bottomRight: Radius.circular(15.0),
//                                 topRight: Radius.circular(15.0),
//                                 bottomLeft: Radius.circular(15.0),
//                               )),
//                               elevation: 5.0,
//                               child: ListTile(
//                                 onTap: () {
//                                   // Navigator.of(context).push(CupertinoPageRoute(
//                                   //     builder: (context) => DetailPegawaiCamat(documentSnapshot: documentSnapshot,)));
//                                 },
//                                 leading: IconButton(
//                                       icon: Icon(
//                                         Icons.print,
//                                         color: Colors.amberAccent,
//                                       ),
//                                       onPressed: () {
//                                         Navigator.of(context).push(
//                                             CupertinoPageRoute(
//                                                 builder: (context) =>
//                                                     ReportSuratBatal(
//                                                       documentSnapshot:
//                                                           suratBatalDoc,
//                                                     )));
//                                       },
//                                     ),
//                                 title: Text(
//                                   suratBatalDoc['nama'],
//                                   style: TextStyle(
//                                       color: Colors.blueAccent,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 subtitle: Text(
//                                       tanggal.toString(),
//                                       style: TextStyle(
//                                         color: (DateFormat('MMMM d, yyyy')
//                                                 .parse(tanggal)
//                                                 .isBefore(DateTime.now()
//                                                     .subtract(
//                                                         Duration(days: 30))))
//                                             ? Colors.red
//                                             : Colors.green,
//                                       ),
//                                     ),
//                                 trailing: Text(
//                                       suratBatalDoc['status'],
//                                       style: TextStyle(
//                                           color: (suratBatalDoc['status'] ==
//                                                       'Disetujui' ||
//                                                   suratBatalDoc['status'] ==
//                                                       'Mohon Tunggu'
//                                               ? Colors.blue
//                                               : Colors.red)),
//                                     )

//                               ));
//                         },
//                       );
//                     },
//                   );
//                 },
//               );
//             },
//           ),
//         ),

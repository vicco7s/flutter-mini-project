import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../page/Dashboard%20Camat/SuratPengganti/detailSuratpenggantiCamat.dart';

class ListSuratPenggantiCamat extends StatefulWidget {
  const ListSuratPenggantiCamat({super.key});

  @override
  State<ListSuratPenggantiCamat> createState() =>
      _ListSuratPenggantiCamatState();
}

class _ListSuratPenggantiCamatState extends State<ListSuratPenggantiCamat> {
  String search = '';

  final Query<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');

  List<QueryDocumentSnapshot<Map<String, dynamic>>> mergedDocuments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Histori Surat Pengganti'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          
          Expanded(
            child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: _usersCollection.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                return FutureBuilder<
                    List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                  future: mergeAndSortDocuments(snapshot),
                  builder: (BuildContext context,
                      AsyncSnapshot<
                              List<QueryDocumentSnapshot<Map<String, dynamic>>>>
                          mergedSnapshot) {
                    if (mergedSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (mergedSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${mergedSnapshot.error}'));
                    }

                    final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                        mergedDocuments = mergedSnapshot.data!;

                    return Column(
                      children: [
                        
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: mergedDocuments.length,
                            itemBuilder: (BuildContext context, int index) {
                              final QueryDocumentSnapshot<Map<String, dynamic>>
                                  suratPenggantiDoc = mergedDocuments[index];
                              Timestamp timestamp =
                                  suratPenggantiDoc['tanggal_surat'];
                              var date = timestamp.toDate();
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
                                      onTap: () {
                                        Navigator.of(context).push(CupertinoPageRoute(
                                            builder: (context) => DetailSuratPengantiCamat(suratpenggantiDoc: suratPenggantiDoc)));
                                      },
                                      title: Text(
                                        suratPenggantiDoc['nama_pengganti'],
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
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
                                      )));
                            },
                          ),
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> mergeAndSortDocuments(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) async {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> userDocuments = snapshot.data!.docs;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> mergedDocuments = [];

  for (QueryDocumentSnapshot<Map<String, dynamic>> userDoc in userDocuments) {
    final CollectionReference<Map<String, dynamic>> suratPenggantiCollection =
        userDoc.reference.collection('suratpengganti');

    Query<Map<String, dynamic>> query = suratPenggantiCollection.orderBy("tanggal_surat", descending: true);

    if (search != "" && search != null) {
      query = query.where("nama_pengganti", isGreaterThanOrEqualTo: search);
    }

    final QuerySnapshot<Map<String, dynamic>> suratPenggantiSnapshot = await query.get();

    final List<QueryDocumentSnapshot<Map<String, dynamic>>> suratPenggantiDocuments = suratPenggantiSnapshot.docs;

    mergedDocuments.addAll(suratPenggantiDocuments);

    mergedDocuments.sort((a, b) {
      Timestamp timestampA = a['tanggal_surat'];
      Timestamp timestampB = b['tanggal_surat'];
      DateTime dateA = timestampA.toDate();
      DateTime dateB = timestampB.toDate();
      return dateB.compareTo(dateA); // Sort in descending order (latest on top)
    });
  }

  return mergedDocuments;
}
}

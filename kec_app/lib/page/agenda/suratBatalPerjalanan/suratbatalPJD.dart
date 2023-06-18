
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/page/agenda/suratBatalPerjalanan/detailSuratBatalPJD.dart';

class SuratBatalAdminPJD extends StatefulWidget {
  const SuratBatalAdminPJD({super.key});

  @override
  State<SuratBatalAdminPJD> createState() => _SuratBatalAdminPJDState();
}

class _SuratBatalAdminPJDState extends State<SuratBatalAdminPJD> {
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
        title: Text('Surat Batal Pegawai'),
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
                                  suratBatalDoc = mergedDocuments[index];
                              Timestamp timestamp =
                                  suratBatalDoc['tanggal_surat'];
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
                                            builder: (context) => DetailSuratBatalPJDAdmin(suratbatalDoc: suratBatalDoc)));
                                      },
                                      title: Text(
                                        suratBatalDoc['nama'],
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
                                        )
                                      ));
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
      final CollectionReference<Map<String, dynamic>> suratBatalCollection =
          userDoc.reference.collection('suratbatal');

      Query<Map<String, dynamic>> query = suratBatalCollection.orderBy("tanggal_surat", descending: true);

      if (search != "" && search != null) {
        query = query.where("nama", isGreaterThanOrEqualTo: search);
      }

      final QuerySnapshot<Map<String, dynamic>> suratBatalSnapshot = await query.get();

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> suratBatalDocuments = suratBatalSnapshot.docs;

      mergedDocuments.addAll(suratBatalDocuments);

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
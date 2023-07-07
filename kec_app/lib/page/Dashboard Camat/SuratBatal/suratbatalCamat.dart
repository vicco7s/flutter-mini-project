import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/page/Dashboard%20Camat/SuratBatal/listsuratBatalUser.dart';
import 'package:kec_app/report/reportSuratBatal/SuratBatal.dart';

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
        title: Text('Pilih Pegawai'),
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
                  : _usersCollection.where("role", isEqualTo: "Pegawai").snapshots(),
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


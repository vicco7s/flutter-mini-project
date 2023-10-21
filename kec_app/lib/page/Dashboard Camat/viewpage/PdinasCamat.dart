import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../../page/Dashboard%20Camat/detailpage/DetailPdinasCamat.dart';

class PerjalananDinasCamat extends StatefulWidget {
  const PerjalananDinasCamat({super.key});

  @override
  State<PerjalananDinasCamat> createState() => _PerjalananDinasCamatState();
}

class _PerjalananDinasCamatState extends State<PerjalananDinasCamat> {
  final _formkey = GlobalKey<FormState>();

  String search = '';

  final Query<Map<String, dynamic>> _pdinas =
      FirebaseFirestore.instance.collection('pdinas');
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Data Perjalanan Dinas'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (val) => setState(() => search = val),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: "Cari Nama..."),
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: (search != "" && search != null)
                ? _pdinas
                    .orderBy("nama")
                    .startAt([search]).endAt([search + "\uf8ff"]).snapshots()
                : _pdinas.orderBy("id", descending: true).snapshots(),
            builder: (context, snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
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
                                    builder: ((context) => DetailPdinasCamat(
                                        documentSnapshot: documentSnapshot))));
                              },
                              title: Text(documentSnapshot['nama'],
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(documentSnapshot['tujuan']),
                              trailing: (documentSnapshot['status'] ==
                                      'diterima')
                                  ? Text(
                                      documentSnapshot['status'],
                                      style:
                                          const TextStyle(color: Colors.green),
                                    )
                                  : Text(
                                      documentSnapshot['status'],
                                      style: const TextStyle(color: Colors.red),
                                    )),
                        );
                      },
                    );
            },
          ))
        ],
      ),
    );
  }
}
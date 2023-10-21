import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../../page/Dashboard%20Camat/detailpage/DetailSuratKeluar.dart';

class SuratKeluarCamat extends StatefulWidget {
  const SuratKeluarCamat({super.key});

  @override
  State<SuratKeluarCamat> createState() => _SuratKeluarCamatState();
}

class _SuratKeluarCamatState extends State<SuratKeluarCamat> {
  final _formkey = GlobalKey<FormState>();

  String search = '';

  final Query<Map<String, dynamic>> _suratkeluar =
      FirebaseFirestore.instance.collection('suratkeluar');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Surat Keluar'),
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
                  prefixIcon: Icon(Icons.search), hintText: "Cari Alamat..."),
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: (search != "" && search != null)
                ? _suratkeluar
                    .orderBy("alamat_penerima")
                    .startAt([search]).endAt([search + "\uf8ff"]).snapshots()
                : _suratkeluar.orderBy("no", descending: true).snapshots(),
            builder: (context, snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
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
                                  builder: ((context) => DetailSuratKeluarCamat(
                                      documentSnapshot: documentSnapshot))));
                            },
                            title: Text(documentSnapshot['no_berkas'],style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold)),
                            subtitle: Text(documentSnapshot['alamat_penerima']),
                            trailing: (documentSnapshot['keterangan'] ==
                                    'sudah dikirim')
                                ? Text(
                                    documentSnapshot['keterangan'],
                                    style: const TextStyle(color: Colors.green),
                                  )
                                : Text(
                                    documentSnapshot['keterangan'],
                                    style: const TextStyle(color: Colors.red),
                                  ),
                          ),
                        );
                      }));
            },
          ))
        ],
      ),
    );
  }
}

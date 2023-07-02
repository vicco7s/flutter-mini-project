import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TabBarViewWidget extends StatelessWidget {
  TabBarViewWidget({required this.controllers});
  final TabController? controllers;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controllers,
      physics: ScrollPhysics(),
      children: [
        // pegawai
        Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pegawai')
                  .orderBy('id', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
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
                                // Navigator.of(context).push(CupertinoPageRoute(
                                //     builder: (context) => DetailPegawaiCamat(documentSnapshot: documentSnapshot,)));
                              },
                              title: Text(
                                documentSnapshot['nama'],
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  documentSnapshot['nip']),
                            ),
                          );
                        },
                      );
              },
            ))
          ],
        ),
        //surat masuk
        Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('suratmasuk')
                  .orderBy('no', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
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
                                // Navigator.of(context).push(CupertinoPageRoute(
                                //     builder: (context) => DetailPegawaiCamat(documentSnapshot: documentSnapshot,)));
                              },
                              title: Text(documentSnapshot['no_berkas'],style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),),
                              subtitle: Text(documentSnapshot['alamat_pengirim']),
                              
                              trailing: (documentSnapshot['keterangan'] == 'sudah diterima')
                              ? Text(documentSnapshot['keterangan'],style: const TextStyle(color: Colors.green),)
                              : Text(documentSnapshot['keterangan'],style: const TextStyle(color: Colors.red),)
                            ),
                          );
                        },
                      );
              },
            ))
          ],
        ),
        // Surat Keluar
        Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('suratkeluar')
                  .orderBy('no', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
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
                                // Navigator.of(context).push(CupertinoPageRoute(
                                //     builder: (context) => DetailPegawaiCamat(documentSnapshot: documentSnapshot,)));
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
                        },
                      );
              },
            ))
          ],
        ),
        // perjalanan dinas
        Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pdinas')
                  .orderBy('id', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
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
                                // Navigator.of(context).push(CupertinoPageRoute(
                                //     builder: (context) => DetailPegawaiCamat(documentSnapshot: documentSnapshot,)));
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
                                    )
                              ),
                          );
                        },
                      );
              },
            ))
          ],
        ),

      ],
    );
  }
}

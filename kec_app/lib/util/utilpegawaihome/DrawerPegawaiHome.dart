
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/page/Dashboard%20user/surat/suratBatal/buatsuratbatalpjdinas.dart';
import 'package:kec_app/page/Dashboard%20user/surat/suratpengganti/ListSuratPenggantiUser.dart';

class DrawerPegawaiHome extends StatelessWidget {
  const DrawerPegawaiHome({
    super.key,
    required this.currentUser,
  });

  final FirebaseAuth currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where("uid", isEqualTo: currentUser.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, index) {
                        final DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];

                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                height: 100,
                                child: DrawerHeader(
                                  decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                    ),
                                  ),
                                  color: Colors.blue,
                                ),
                                  child: ListTile(
                                    textColor: Colors.white,
                                    title: Text('Hallo,'+ ' ' + documentSnapshot['nama']),
                                    subtitle: Text(documentSnapshot['email']),
                                    onTap: () {
                                      
                                    },
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.send_outlined),
                              title: Text('Buat Surat menolak pejalanan dinas'),
                              onTap: () {
                                Navigator.of(context).push(CupertinoPageRoute(builder: (context) => SuratbatalPjDinas()));
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.email_outlined),
                              title: Text('Surat Peganti Perjalanan Dinas'),
                              onTap: () {
                                Navigator.of(context).push(CupertinoPageRoute(builder: (context) => ListSuratPenggantiUser()));
                              },
                            ),
                          ],
                        );
                      },
                    );
            },
          ),
        ),

        ListTile(
          leading: Text('Powered By Uniska'),
        ),
        
      ]),
    );
  }
}
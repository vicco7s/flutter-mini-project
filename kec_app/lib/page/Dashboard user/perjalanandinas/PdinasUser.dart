import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'DetailPdinasUser.dart';

class PerjalananDinasUser extends StatefulWidget {
  const PerjalananDinasUser({super.key});

  @override
  State<PerjalananDinasUser> createState() => _PerjalananDinasUserState();
}

class _PerjalananDinasUserState extends State<PerjalananDinasUser> {
  final _formkey = GlobalKey<FormState>();

  String search = '';

  final Query<Map<String, dynamic>> _pdinas =
      FirebaseFirestore.instance.collection('pdinas');

  DocumentSnapshot? currentdoc; // Tambahkan variabel currentdoc

  @override
  void initState() {
    super.initState();
    getCurrentUser(); // Panggil fungsi getCurrentUser saat initState
  }

  void getCurrentUser() async {
    // Ambil data pengguna saat login
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        currentdoc = doc;
      });
    }
  }

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
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: _pdinas
                .orderBy('id', descending: true)
                .where("nama", isEqualTo: currentdoc?.get('nama'))
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot = documents[index];
                    Timestamp timerstamp = documentSnapshot['tanggal_mulai'];
                    var date = timerstamp.toDate();
                    var tanggal_awal = DateFormat.yMMMMd().format(date);
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
                                builder: ((context) => DetailPdinasUser(
                                    documentSnapshot: documentSnapshot))));
                          },
                          title: Text(documentSnapshot['nama'],
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(tanggal_awal.toString(), 
                          style: TextStyle(
                                  color: (DateFormat('MMMM d, yyyy')
                                          .parse(tanggal_awal)
                                          .isBefore(DateTime.now()
                                              .subtract(Duration(days: 30))))
                                      ? Colors.red
                                      : Colors.green,
                                ),),
                          trailing: (documentSnapshot['status'] == 'diterima')
                              ? Text(
                                  documentSnapshot['status'],
                                  style: const TextStyle(color: Colors.green),
                                )
                              : Text(
                                  documentSnapshot['status'],
                                  style: const TextStyle(color: Colors.red),
                                )),
                    );
                  },
                );
              } else {
                return Text('No data available');
              }
            },
          ))
        ],
      ),
    );
  }
}

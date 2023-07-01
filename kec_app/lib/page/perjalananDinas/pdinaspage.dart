import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/controller/controllerPerjalananDinas/controllerpdinas.dart';
import 'package:kec_app/page/perjalananDinas/detailpdinas.dart';
import 'package:kec_app/page/perjalananDinas/formpdinas.dart';
import 'package:kec_app/util/SpeedDialFloating.dart';
import 'package:kec_app/util/controlleranimasiloading/CircularControlAnimasiProgress.dart';

class DinasPageList extends StatefulWidget {
  const DinasPageList({super.key});

  @override
  State<DinasPageList> createState() => _DinasPageListState();
}

class _DinasPageListState extends State<DinasPageList> {
  final _formkey = GlobalKey<FormState>();

  String search = '';
  

  final Query<Map<String, dynamic>> _pdinas =
      FirebaseFirestore.instance.collection('pdinas');
  final dataPdinas = ControllerPDinas();
  @override
  Widget build(BuildContext context) {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
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
              child: FutureBuilder(
            future: Future.delayed(Duration(seconds: 3)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ColorfulCirclePrgressIndicator();
              } else {
                return StreamBuilder<QuerySnapshot>(
                  stream: (search != "" && search != null)
                      ? _pdinas.orderBy("nama").startAt([search]).endAt(
                          [search + "\uf8ff"]).snapshots()
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
                    return Dismissible(
                      key: Key(documentSnapshot.id), 
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Icon(Icons.delete,color: Colors.white,),
                        ),
                      ),
                      onDismissed: (direction) async{
                        if (documentSnapshot['konfirmasi_kirim'] == 'sudah dikirim') {
                          scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.yellow,
                            content: Text('Data tidak berhasil dihapus karna bukti sudah dikirim',style: TextStyle(color: Colors.black),),
                          ),
                        );
                        Navigator.pop(context);
                        Navigator.pop(context);
                        } else {
                         try {
                            await dataPdinas.delete(documentSnapshot.id, context);
                            // Penghapusan berhasil, lakukan aksi yang diperlukan (misalnya, refresh data)
                          } catch (error) {
                            scaffoldMessenger.hideCurrentSnackBar(); // Tutup SnackBar saat drawer ditutup
                            Navigator.pop(context); // Penghapusan gagal, langsung navigasi kembali
                          }
                        }
                      },
                      child: Card(
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
                        Navigator.of(context).push(
                            CupertinoPageRoute(
                                builder: ((context) =>
                                    DetailPdinas(
                                        documentSnapshot:
                                            documentSnapshot))));
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
                        style: const TextStyle(
                            color: Colors.green),
                      )
                    : Text(
                        documentSnapshot['status'],
                        style: const TextStyle(
                            color: Colors.red),
                      )),
                    ));
                    },
                    );
                  },
                );
              }
            },
          ))
        ],
      ),
      floatingActionButton: SpeedDialFloating(
        animatedIcons: AnimatedIcons.add_event,
        ontap: () {
          Navigator.of(context).push(
              CupertinoPageRoute(builder: ((context) => FormPDinasPage())));
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kec_app/components/DropdownButtomFormUpdates.dart';
import 'package:kec_app/components/DropdownButtonForm.dart';
import 'package:kec_app/controller/controlerPegawai/controllerPegawai.dart';
import 'package:kec_app/page/Pegawai/DetaiPegawai.dart';
import 'package:kec_app/page/Pegawai/FormPegawaiAsn.dart';
import 'package:kec_app/report/reportPegawai/ReportDetailTunggalPegawai.dart';
import 'package:kec_app/util/OptionDropDown.dart';
import 'package:kec_app/util/SpeedDialFloating.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/util/controlleranimasiloading/CircularControlAnimasiProgress.dart';

class PegawaiAsn extends StatefulWidget {
  const PegawaiAsn({super.key});

  @override
  State<PegawaiAsn> createState() => _PegawaiAsnState();
}

class _PegawaiAsnState extends State<PegawaiAsn> {
  final _formkey = GlobalKey<FormState>();
  String search = '';

  final Query<Map<String, dynamic>> _pegawai =
      FirebaseFirestore.instance.collection('pegawai');

  final dataPegawai = ControllerPegawai();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Data Pegawai'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
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
            child: FutureBuilder(
            future: Future.delayed(Duration(seconds: 2)),
            builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: ColorfulCirclePrgressIndicator(),
              );
            } else {
              return StreamBuilder<QuerySnapshot>(
                stream: (search != "" && search != null)
                    ? _pegawai.orderBy("nama").startAt([search]).endAt(
                        [search + "\uf8ff"]).snapshots()
                    : _pegawai.orderBy('id', descending: true).snapshots(),
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
                        return Dismissible(
                          key: Key(documentSnapshot.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            color: Colors.red,
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onDismissed: (direction) async {
                            await dataPegawai.delete(
                                documentSnapshot.id, context);
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
                            leading: IconButton(onPressed: (){
                              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=> ReportDetailTunggalPegawai(documentSnapshot: documentSnapshot,)));
                            }, icon: Icon(FontAwesomeIcons.print,color: Colors.amber,)),
                            onTap: () {
                              Navigator.of(context).push(
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          DetailPagePegawai(
                                            documentSnapshot:
                                                documentSnapshot,
                                          )));
                            },
                            title: Text(documentSnapshot['nama'],
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(documentSnapshot['nip']),
                          ),
                        ));
                        },
                      );
                },
              );
            }
          })),
        ],
      ),
      floatingActionButton: SpeedDialFloating(
        animatedIcons: AnimatedIcons.add_event,
        ontap: () => Navigator.of(context)
            .push(CupertinoPageRoute(builder: ((context) => FormPegawaiAsn()))),
      ),
    );
  }
}

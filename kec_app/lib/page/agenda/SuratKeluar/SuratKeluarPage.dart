import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kec_app/controller/controllerSurat/controllerSuratKeluar.dart';
import 'package:kec_app/page/agenda/SuratKeluar/DetailSuratKeluar.dart';
import 'package:kec_app/page/agenda/SuratKeluar/FormSuratKeluar.dart';
import 'package:kec_app/page/agenda/Suratmasuk/FormSuratMasuk.dart';
import 'package:kec_app/report/Report_surat_Keluar/ReportpdfOutSurel.dart';
import 'package:kec_app/util/SpeedDialFloating.dart';
import 'package:intl/intl.dart';

class SuratKeluarPage extends StatefulWidget {
  const SuratKeluarPage({super.key});

  @override
  State<SuratKeluarPage> createState() => _SuratKeluarPageState();
}

class _SuratKeluarPageState extends State<SuratKeluarPage> {
  final _formkey = GlobalKey<FormState>();

  String search = '';

  final Query<Map<String, dynamic>> _suratkeluar =
      FirebaseFirestore.instance.collection('suratkeluar');
  final dataSuratKeluar = ControllerSK();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Data Surat Keluar'),
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
                        return Dismissible(
                            key: Key(documentSnapshot.id),
                            background: Container(
                              alignment: Alignment.centerRight,
                              color: Colors.red,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onDismissed: (direction) async {
                              dataSuratKeluar.delete(
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
                                onTap: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: ((context) => DetailSuratKeluar(
                                          documentSnapshot:
                                              documentSnapshot))));
                                },
                                title: Text(
                                  documentSnapshot['no_berkas'],
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle:
                                    Text(documentSnapshot['alamat_penerima']),
                                trailing: (documentSnapshot['keterangan'] ==
                                        'sudah dikirim')
                                    ? Text(
                                        documentSnapshot['keterangan'],
                                        style: const TextStyle(
                                            color: Colors.green),
                                      )
                                    : Text(
                                        documentSnapshot['keterangan'],
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                              ),
                            ));
                      }));
            },
          ))
        ],
      ),
      floatingActionButton: SpeedDialFloating(
        ontap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: ((context) => const FormSuratKeluar()))),
        animatedIcons: AnimatedIcons.add_event,
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../controller/controllerSurat/controlerSuratMasuk.dart';
import '../../../util/SpeedDialFloating.dart';
import '../../../util/controlleranimasiloading/CircularControlAnimasiProgress.dart';
import 'DetailSurat.dart';
import 'FormSuratMasuk.dart';

class SuratMasukPage extends StatefulWidget {
  const SuratMasukPage({super.key});

  @override
  State<SuratMasukPage> createState() => _SuratMasukPageState();
}

class _SuratMasukPageState extends State<SuratMasukPage> {
  final _formkey = GlobalKey<FormState>();

  String search = '';

  final Query<Map<String, dynamic>> _suratmasuk = FirebaseFirestore.instance
      .collection('suratmasuk');
  final dataControlerSM = ControllerSM();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Data Surat Masuk'),
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
                  prefixIcon: Icon(Icons.search),
                  hintText: "Cari Alamat..."),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: (search != "" && search != null) 
              ? _suratmasuk.orderBy("alamat_pengirim")
                  .startAt([search])
                  .endAt([search + "\uf8ff"])
                  .snapshots() 
              : _suratmasuk.orderBy("no", descending: true).snapshots(),
                builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting) 
                ? Center(
                  child: ColorfulCirclePrgressIndicator(),
                )
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                      return Dismissible(
                      key: Key(documentSnapshot.id), 
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: Padding(padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(Icons.delete,color: Colors.white,),
                        ),
                      ),
                      onDismissed: (direction)async {
                        await dataControlerSM.delete(documentSnapshot.id, context);
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
                            Navigator.of(context).push(CupertinoPageRoute(builder: (context) 
                            => DetailSuratMasuk(documentSnapshot: documentSnapshot)));
                          },
                          title: Text(documentSnapshot['no_berkas'],style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold)),
                          subtitle: Text(documentSnapshot['alamat_pengirim']),
                          
                          trailing: (documentSnapshot['keterangan'] == 'sudah diterima')
                          ? Text(documentSnapshot['keterangan'],style: const TextStyle(color: Colors.green),)
                          : Text(documentSnapshot['keterangan'],style: const TextStyle(color: Colors.red),)
                        ),
                      ));
                    },
                );
              },
            )
          )
        ],
      ),
      floatingActionButton: SpeedDialFloating(
        animatedIcons: AnimatedIcons.add_event,
        ontap: (() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => const FormSuratMasuk())));
        }
      )),
    );
  }

}



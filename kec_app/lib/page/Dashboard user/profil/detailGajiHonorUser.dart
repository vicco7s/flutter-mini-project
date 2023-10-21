
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../../controller/controlerPegawai/controllerHonorGaji.dart';
import '../../../util/ContainerDeviders.dart';
import '../../../util/controlleranimasiloading/CircularControlAnimasiProgress.dart';
import '../../../util/controlleranimasiloading/controlleranimasiprogressloading.dart';

import '../../../util/TextCustome.dart';

class DetailHonorPegawaiUser extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const DetailHonorPegawaiUser({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id', null);
    Timestamp timerstamp = documentSnapshot['tanggal'];
    var date = timerstamp.toDate();
    var tanggal = DateFormat.yMMMMd('id').format(date);

    final dataGajiHonor = ControllerGajiHonor();

    return Scaffold(
      backgroundColor: Color(0xFFFEFDE4),
      appBar: AppBar(
        backgroundColor: Color(0xFFFEFDE4),
        foregroundColor: Colors.deepPurple[600],
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text('Detail'),
        centerTitle: true,
      ),
      body: FutureBuilder(
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: ColorfulCirclePrgressIndicator(),
          );
        } else {
          return ListView(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: ListTile(
                title: Text(documentSnapshot['nama'],textAlign: TextAlign.center,style: TextStyleHonor(),),
                subtitle: Text(documentSnapshot['jabatan'], textAlign: TextAlign.center,style: TextStyleHonorSub(),),
                )
              ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)
                ),
                color: Colors.white,
              ),
              alignment: Alignment.center,
              
              child: Column(
                children: [
                  Divider(thickness: 5,indent: 150,endIndent: 150,),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Center(
                      child: Text('Detail Pembayaran Honor/PTT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepPurple[600]),),
                    ),
                  ),
                  ListTile(
                    title:  Text(
                      "Total",
                      style: TextStylesTit(),),
                    subtitle: Text(
                      NumberFormat.currency(
                              locale: 'id', symbol: 'Rp')
                          .format(documentSnapshot['total'])
                          .replaceAll(RegExp(r'(\.|,)00\b'), ''),
                      style: TextStylesSub(),
                    ),
                  ),
                  Containers(),
                  Row(
                    children: [
                      Flexible(
                        child: Column(children: [
                          Container(
                          child: ListTile(
                          title:  Text(
                          "Gaji Honor :",
                          style: TextStylesTit() ),
                          subtitle: Text(
                          NumberFormat.currency(
                                  locale: 'id', symbol: 'Rp')
                              .format(documentSnapshot['gaji_honor'])
                              .replaceAll(RegExp(r'(\.|,)00\b'), ''),
                          style: TextStylesSub(),
                            ),
                          ),
                        ),
                        Containers(),
                        ],),
                      ),
                  Flexible(
                    child: Column(
                      children: [
                        Container(
                      child: ListTile(
                        title:  Text(
                          "Bonus :",
                          style: TextStylesTit(),
                        ),
                        subtitle: Text(
                          NumberFormat.currency(
                                  locale: 'id', symbol: 'Rp')
                              .format(documentSnapshot['bonus'])
                              .replaceAll(RegExp(r'(\.|,)00\b'), ''),
                          style: TextStylesSub(),
                        ),
                      ),
                    ),
                    Containers()
                        ],
                        ),
                      )
                    ],
                  ),
                  ListTile(
                    title: Text(
                      "Tanggal :",
                      style: TextStylesTit(),
                    ),
                    subtitle: Text(
                      tanggal.toString(),
                      style: TextStylesSub(),
                    ),
                    trailing: Icon(FontAwesomeIcons.calendar,color: Colors.deepPurple[800],),
                  ),
                  Containers(),
                  ListTile(
                    title: Text(
                      "Keterangan :",
                      style: TextStylesTit(),
                    ),
                    subtitle: Text(
                      documentSnapshot['keterangan'],
                      style: TextStylesSub(),
                    ),
                  ),
                  Containers(),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          Container(
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              TextButton(
                onPressed: ()  {
                  Navigator.pop(context);
                }, 
                child: const Text("Kembali"),style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.grey[500],
                ),),
              ],
            ),
          ), 
            ]
          );
        }
      })
    );
  }
  
}


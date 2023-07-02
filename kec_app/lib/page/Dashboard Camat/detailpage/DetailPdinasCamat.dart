import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/controller/controllerCamat.dart';
import 'package:kec_app/page/perjalananDinas/buktiKegiatanPJD/detailKegiatanPJD.dart';
import 'package:kec_app/util/controlleranimasiloading/CircularControlAnimasiProgress.dart';
import 'package:kec_app/util/controlleranimasiloading/controlleranimasiprogressloading.dart';

class DetailPdinasCamat extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const DetailPdinasCamat({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    Timestamp timerstamp = documentSnapshot['tanggal_mulai'];
    Timestamp timerstamps = documentSnapshot['tanggal_berakhir'];
    var date = timerstamp.toDate();
    var dates = timerstamps.toDate();
    var timers = DateFormat.yMMMMd().format(date);
    var timer = DateFormat.yMMMMd().format(dates);
    final updateStatus = UpdateCamat();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Detail Perjalanan Dinas'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: ()async {
            await updateStatus.update(documentSnapshot, context);
          }, icon: Icon(FontAwesomeIcons.solidPenToSquare))
        ],
      ),
      body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FutureBuilder(
              future: Future.delayed(Duration(seconds: 3)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ColorfulLinearProgressIndicator();
                }else{
                  return Column(
              children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Color(0xfffc16ffc),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                title: Text(documentSnapshot['nama'],style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 14),),
                subtitle: Text(documentSnapshot['jabatan'],style: TextStyle(color: Colors.white,fontSize: 12)),
                trailing: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white, // Warna garis border
                      width: 1.0, // Lebar garis border
                    ),
                    borderRadius: BorderRadius.circular(5), // Mengatur radius sudut border
                  ),
                  child: Text(
                    documentSnapshot['status'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                )
              )),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.topLeft,
                child: Text("Perjalanan Dinas",style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.only(top: 10),
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Color(0xfffc16ffc),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Divider(indent: 100,endIndent: 100,color: Colors.white,thickness: 2,),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.locationDot,color: Colors.white,),
                      title: Text(documentSnapshot['tujuan'],style: TextStyle(color: Colors.white),),
                    ),
                    Divider(indent: 20,endIndent: 20,color: Colors.white,thickness: 1,),
                    ListTile(
                      leading: Text(timers.toString(),style: TextStyle(color: Colors.white)),
                      title: Icon(FontAwesomeIcons.planeDeparture,color: Colors.white,),
                      trailing: Text(timer.toString(),style: TextStyle(color: Colors.white)),
                    ),
                    Divider(indent: 20,endIndent: 20,color: Colors.white,thickness: 1,),
                    ListTile(
                      title: Text('Keperluan',style: TextStyle(color: Colors.white, fontSize: 11),),
                      subtitle: Text(documentSnapshot['keperluan'], style: TextStyle(color: Colors.white),),
                    ),
                  ],
                )
              ),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Color(0xfffc16ffc),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ExpansionTile(
                  leading: Icon(FontAwesomeIcons.mapPin, color: Colors.white,),
                  title: Text('Anggaran PJD',style: TextStyle(color: Colors.white , fontSize: 14),),
                  children: [
                    Divider(indent: 100,endIndent: 100,thickness: 3,color: Colors.white,),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.mugSaucer, color: Colors.white,),
                      title: Text(NumberFormat.currency(
                                    locale: 'id', symbol: 'Rp')
                                .format(documentSnapshot['uangharian'])
                                .replaceAll(RegExp(r'(\.|,)00\b'), ''), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      trailing: Text("${documentSnapshot['hari'].toString()} Hari",style: TextStyle(color: Colors.white),),
                    ),
                    Divider(indent: 50,endIndent: 50,thickness: 0.3,color: Colors.white,),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.bus, color: Colors.white,),
                      title: Text(NumberFormat.currency(
                                    locale: 'id', symbol: 'Rp')
                                .format(documentSnapshot['transport'])
                                .replaceAll(RegExp(r'(\.|,)00\b'), ''), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      trailing: (documentSnapshot['pulang_pergi'] == 1 ? Text("Pergi",style: TextStyle(color: Colors.white),): Text("Pulang Pergi", style: TextStyle(color: Colors.white),)),
                    ),
                    Divider(indent: 50,endIndent: 50,thickness: 0.3,color: Colors.white,),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.bed, color: Colors.white,),
                      title: Text(NumberFormat.currency(
                                    locale: 'id', symbol: 'Rp')
                                .format(documentSnapshot['penginapan'])
                                .replaceAll(RegExp(r'(\.|,)00\b'), ''), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      trailing: Text('${documentSnapshot['lama_menginap'].toString()} Hari',style: TextStyle(color: Colors.white),),
                    ),
                    Divider(indent: 50,endIndent: 50,thickness: 0.3,color: Colors.white,),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.moneyBill, color: Colors.white,),
                      title: Text(NumberFormat.currency(
                                    locale: 'id', symbol: 'Rp')
                                .format(documentSnapshot['total'])
                                .replaceAll(RegExp(r'(\.|,)00\b'), ''), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  ],
                )
              ),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.topLeft,
                child: Text("Bukti Perjalanan Dinas",style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 10,),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('buktikegiatanpjd').where('uid', isEqualTo: documentSnapshot['uid']).snapshots(),
                builder:(context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: ColorfulCirclePrgressIndicator(),);
                }else if(!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text("Bukti Belum Dikirim",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),);
                } else {
                  return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot docsnap = snapshot.data!.docs[index];
                    Timestamp timerstamp = docsnap['tgl_awal'];
                    var date = timerstamp.toDate();
                    var tanggal_awal = DateFormat.yMMMMd().format(date);
                    return Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Color(0xfffc16ffc),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(builder: (context)=> DetailKegiatanPJD(documentSnapshot: docsnap,)));
                    },
                    title: Text(docsnap['nama'],style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 14),),
                    trailing: Text(
                      tanggal_awal.toString(),
                      style: TextStyle(
                        color: (DateFormat('MMMM d, yyyy')
                                .parse(tanggal_awal)
                                .isBefore(DateTime.now()
                                    .subtract(
                                        Duration(days: 30))))
                            ? const Color.fromARGB(255, 255, 128, 128)
                            : Colors.white,
                      ),
                    ),
                  ));
                  },
                );
                }
              }),
            ]);}
          },
        )
      ),
    )
    );
  }
}

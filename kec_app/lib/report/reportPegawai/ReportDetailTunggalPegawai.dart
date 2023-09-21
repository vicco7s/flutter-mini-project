import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/util/OptionDropDown.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pwLib;
import 'package:pdf/widgets.dart' as pwGr;
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:printing/printing.dart';

class ReportDetailTunggalPegawai extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const ReportDetailTunggalPegawai({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Laporan Pegawai'),
        centerTitle: true,
        elevation: 0,
      ),
      body: PdfPreview(
          canChangeOrientation: false,
          canDebug: false,
          build: (PdfPageFormat format) =>
              generateDocument(format, documentSnapshot)),
    );
  }
}

Future<Uint8List> generateDocument(
    PdfPageFormat format, DocumentSnapshot<Object?> documentSnapshot) async {
  final doc = pw.Document(pageMode: PdfPageMode.outlines);
  final font1 = await PdfGoogleFonts.openSansRegular();
  final font2 = await PdfGoogleFonts.openSansBold();

  final memoryImage = pw.MemoryImage(
    (await rootBundle.load('image/kabtapin.png')).buffer.asUint8List(),
  );
  
  final Uint8List? imageData = await _fetchImageData(documentSnapshot['imageUrl']);
  final Uint8List? imageKtp = await _fetchImageData(documentSnapshot['imageKtp']);
  final imageUrl = pw.MemoryImage(imageData!);
  final imageFotoKtp = pw.MemoryImage(imageKtp!);

  await initializeDateFormatting('id', null);
  final Timestamp timerStamp = documentSnapshot['tgl_lahir'];
  final Timestamp timerStamps = documentSnapshot['tgl_mulaitugas'];
  var date = timerStamp.toDate();
  var dates = timerStamps.toDate();
  var tgl_Lahir = DateFormat.yMMMMd('id').format(date);
  var tgl_mulai = DateFormat.yMMMMd('id').format(dates);

  

  

  doc.addPage(pw.MultiPage(
    pageFormat: format,
    build: (context) {
      return [
        pw.Column(children: [
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Container(
                    width: 65, height: 65, child: pw.Image(memoryImage)),
                pw.SizedBox(width: 30),
                pw.Column(children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.all(0),
                      child: pw.Text("PEMERINTAHAN KABUPATEN TAPIN",
                          style: pw.TextStyle(
                              fontSize: 14, fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: pw.EdgeInsets.only(top: 5),
                      child: pw.Text("KECAMATAN SALAM BABARIS",
                          style: pw.TextStyle(
                              fontSize: 14, fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: pw.EdgeInsets.only(top: 8),
                      child: pw.Text(
                          "Jalan Transmigrasi No.02 Desa Salam Babaris Kode Pos: 71182",
                          style: pw.TextStyle(
                            fontSize: 12,
                          )))
                ]),
              ]),

              pw.Divider(thickness: 3),
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(
                      color: PdfColors.black,
                      width: 1.0,
                      style: pw.BorderStyle.solid,
                    ),
                  ),
                ),
                child: pw.Text(
                  "BIODATA PEGAWAI",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 20),

              //body surat
              pw.Column(children: [
                
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('     Nama'),
                    pw.SizedBox(width: 165),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':  ${documentSnapshot['nama']}'),
                      ),
                    ),
                    pw.SizedBox(width: 30,),
                    pw.Container(
                      child: pw.Image(imageUrl,height: 70,width: 50,fit: pw.BoxFit.fill),
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('     Nip'),
                    pw.SizedBox(width: 178),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':  ${documentSnapshot['nip']}'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20,),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('     Jenis Kelamin'),
                    pw.SizedBox(width: 122),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':  '+(documentSnapshot['jenis_kelamin'] == "L"? "Laki Laki":"Perempuan")),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20,),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('     Tempat,Tanggal Lahir'),
                    pw.SizedBox(width: 80),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':  ${documentSnapshot['tempat_lahir']}, ${tgl_Lahir.toString()}'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20,),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('     Alamat'),
                    pw.SizedBox(width: 160),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':  ${documentSnapshot['alamat']}'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20,),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('     Tanggal Mulai Tugas'),
                    pw.SizedBox(width: 85),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':  ${tgl_mulai.toString()}'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20,),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('     Pendidikan Terakhir'),
                    pw.SizedBox(width: 90),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':  ${documentSnapshot['pendidikan_terakhir']}'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20,),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('     Pangkat/Golongan'),
                    pw.SizedBox(width: 98),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':  ${documentSnapshot['pangkat']}'+(documentSnapshot['golongan'] == '--'? '': ', '+documentSnapshot['golongan'])),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20,),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('     Jabatan'),
                    pw.SizedBox(width: 155),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':  ${documentSnapshot['jabatan']}'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20,),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('     Status Pegawai'),
                    pw.SizedBox(width: 115),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':  ${documentSnapshot['status']}'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20,),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('     Status Pernikahan/Anak'),
                    pw.SizedBox(width: 70),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':  ${documentSnapshot['status_pernikahan']}, ${documentSnapshot['jumlah_anak']}'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20,),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('     Telepon/Wa'),
                    pw.SizedBox(width: 135),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':  ${documentSnapshot['telpon']}'),
                      ),
                    ),
                  ],
                ),
                  
              ]),
            ]),
            pw.SizedBox(height: 30,),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
              pw.Column(children: [
                pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfColors.green600,
                    width: 5,
                  )
                ),
                  child: pw.Image(imageFotoKtp,height: 90,width: 150,fit: pw.BoxFit.fill),
                ),
                pw.SizedBox(height: 10),
                pw.Text("E-KTP",style: pw.TextStyle(color: PdfColors.green600, fontWeight: pw.FontWeight.bold, fontStyle: pw.FontStyle.italic)),
              ])
            ]),
            pw.SizedBox(height: 10),

      ];
    },
  ));

  return doc.save();
}

 Future<Uint8List?> _fetchImageData(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      return null;
    }
  }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';

class ReportBuktiKegiatanPJD extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const ReportBuktiKegiatanPJD({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Laporan Bukti Kegiatan'),
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

  await initializeDateFormatting('id', null);
  final Timestamp timerStamp = documentSnapshot['tgl_awal'];
  final Timestamp timerStamps = documentSnapshot['tgl_akhir'];
  var date = timerStamp.toDate();
  var dates = timerStamps.toDate();
  var firstDate = DateFormat('d', 'id').format(date);
  var endDate = DateFormat.yMMMMd('id').format(dates);

  var awal = DateFormat('yyyy-MM-dd', 'id').format(date);
  var akhir = DateFormat('yyyy-MM-dd', 'id').format(dates);

  DateTime tgl_awal = DateTime.parse(awal);
  DateTime tgl_akhir = DateTime.parse(akhir);

  final List<dynamic> imageUrls = documentSnapshot['imageUrl'];
  final List<pw.Widget> imageUrlWidgets = [];

  for (final imageUrl in imageUrls) {
    final imageWidget = await loadImageFromUrl(imageUrl);
    imageUrlWidgets.add(imageWidget);
  }

  

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
                  "LAPORAN BUKTI KEGIATAN PERJALANAN DINAS",
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
                    pw.Text('I    Dasar'),
                    pw.SizedBox(width: 164),
                    pw.Text(':  '),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text('  \nSurat Dari ${documentSnapshot['alamat_pengirim']} Nomor ${documentSnapshot['no_berkas']}'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('II   Pelaksanaan SPD'),
                    pw.SizedBox(width: 100),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('     NAMA'),
                    pw.SizedBox(width: 163),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':   ${documentSnapshot['nama']}'),
                      ),
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('     NIP'),
                    pw.SizedBox(width: 178),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':   ${documentSnapshot['nip']}'),
                      ),
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('     JABATAN'),
                    pw.SizedBox(width: 144),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':   ${documentSnapshot['jabatan']}'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('III  KEPERLUAN'),
                    pw.SizedBox(width: 125),
                    pw.Text(':'),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text('   ${documentSnapshot['keperluan']}'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('IV TEMPAT / INSTANSI TUJUAN'),
                    pw.SizedBox(width: 35),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':   ${documentSnapshot['tempat']}'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('V  LAMANYA(TANGGAL)'),
                    pw.SizedBox(width: 78),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                            ':   ${tgl_akhir.difference(tgl_awal).inDays} hari / tanggal ${firstDate.toString()} - ${endDate.toString()}'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('VI  BUKTI KEGIATAN'),
                    pw.SizedBox(width: 97),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.SizedBox(width: 19),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text('${documentSnapshot['hasil']}'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                
                  
              ]),
            ]),
            pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('FOTO BUKTI KEGIATAN'),
                    pw.SizedBox(width: 80),
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(':'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Container(
              width: 300,
            child: pw.Column(
              children: imageUrlWidgets.map((imageWidget) {
                return pw.Container(
                  margin: pw.EdgeInsets.only(bottom: 5),
                  width: 400,
                  height: 400, // Adjust the height as needed
                  child: imageWidget,
                );
              }).toList(),
            ),
          ),
              ),
            pw.SizedBox(height: 60),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
              pw.Column(children: [
                pw.Text("Yang Membuat Laporan "),
                pw.SizedBox(height: 50),
                pw.Padding(
                    padding: const pw.EdgeInsets.only(),
                    child: pw.Text(documentSnapshot['nama'],
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.Padding(
                    padding: const pw.EdgeInsets.only(),
                    child: pw.Text('NIP. ' + documentSnapshot['nip'],
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              ])
            ])
      ];
    },
  ));

  return doc.save();
}

Future<pw.Image> loadImageFromUrl(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  final image = pw.MemoryImage(response.bodyBytes);
  return pw.Image(image);
}

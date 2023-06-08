import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<Map<String, Map<String, int>>> getData() async {
  final QuerySnapshot snapshot = await firestore
      .collection('pegawai')
      .where('status', isEqualTo: 'ASN')
      .get();

  final QuerySnapshot snapshot2 = await firestore
      .collection('pegawai')
      .where('status', isEqualTo: 'NON ASN')
      .get();

  Map<String, Map<String, int>> data = {};

  for (var document in snapshot.docs) {
    final pangkat = document['pangkat'];
    if (data.containsKey(pangkat)) {
      data[pangkat]!['ASN'] = (data[pangkat]!['ASN']! + 1);
    } else {
      data[pangkat] = {'ASN': 1, 'BUKAN ASN': 0};
    }
  }

  for (var document in snapshot2.docs) {
    final pangkat = document['pangkat'];
    if (data.containsKey(pangkat)) {
      data[pangkat]!['BUKAN ASN'] = (data[pangkat]!['BUKAN ASN']! + 1);
    } else {
      data[pangkat] = {'ASN': 0, 'BUKAN ASN': 1};
    }
  }

  return data;
}

class ReportPegawaiAsn extends StatefulWidget {
  const ReportPegawaiAsn({
    super.key,
  });

  @override
  // ignore: no_logic_in_create_state
  State<ReportPegawaiAsn> createState() => _ReportPegawaiAsnState();
}

class _ReportPegawaiAsnState extends State<ReportPegawaiAsn> {
  final pdf = pw.Document();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Report Asn dan Non Asn'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final Map<String, Map<String, int>> data =
              snapshot.data as Map<String, Map<String, int>>;
          return PdfPreview(
            canChangeOrientation: false,
            canDebug: false,
            build: (
              PdfPageFormat format,
            ) =>
                generateDocument(
              format,
              data,
            ),
          );
        },
      ),
    );
  }

  Future<Uint8List> generateDocument(
      PdfPageFormat format, Map<String, Map<String, int>> data) async {
    
    final doc = pw.Document(pageMode: PdfPageMode.outlines);
    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();


    final memoryImage = pw.MemoryImage((await rootBundle.load('image/kabtapin.png')).buffer.asUint8List(),);
    
    doc.addPage(pw.MultiPage(
      build: (context) => [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Container(
              width: 65,
              height: 65,
              child: pw.Image(memoryImage)
            ),
            pw.SizedBox(width: 30),
            pw.Column(
              children: [
                  pw.Padding(
                  padding: pw.EdgeInsets.all(0),
                  child: pw.Text("PEMERINTAHAN KABUPATEN TAPIN",style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold))
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.only(top: 5),
                  child: pw.Text("KECAMATAN SALAM BABARIS",style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold))
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.only(top: 8),
                  child: pw.Text("Jalan Transmigrasi No.02 Desa Salam Babaris Kode Pos: 71182",style: pw.TextStyle(fontSize: 12,))
                )
              ]
            )
          ]
        ),
        pw.Divider(thickness: 3),
        pw.SizedBox(height: 20),
        pw.Center(
          child: pw.Text("Laporan Pegawai ASN Dan Bukan ASN",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
        ),
        pw.SizedBox(height: 20),
        pw.Table(
            columnWidths: {
              0: pw.FlexColumnWidth(2.2),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1.4),
            },
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(children: [
                pw.Text("Pangkat",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold
                    )),
                pw.Text("ASN",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 10,fontWeight: pw.FontWeight.bold)),
                pw.Text("Bukan ASN",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 10,fontWeight: pw.FontWeight.bold)),
              ]),
            ]),
        pw.Table(
          columnWidths: {
            0: pw.FlexColumnWidth(2.2),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1.4),
          },
          border: pw.TableBorder.all(),
          children: data.entries
              .map((e) => pw.TableRow(children: [
                    pw.Text(e.key),
                    pw.Text(
                      e.value['ASN'].toString(),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      e.value['BUKAN ASN'].toString(),
                      textAlign: pw.TextAlign.center,
                    )
                  ]))
              .toList(),
        ),
        pw.SizedBox(height: 60),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Column(
              children: [
                pw.Text("Camat"),
                pw.SizedBox(height: 30),
                pw.Padding(padding: const pw.EdgeInsets.only(),
                child: pw.Text("Akhmad, S.Sos., M.AP",style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                ),
                pw.Padding(padding: const pw.EdgeInsets.only(),
                child: pw.Text("198106202010011029",style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                ),
              ]
            )
          ]
        )
      ],
    ));

    return doc.save();
  }
}

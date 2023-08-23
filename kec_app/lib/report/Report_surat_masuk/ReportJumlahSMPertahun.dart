
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<Map<String, int>> getData() async {
  final QuerySnapshot snapshot = await firestore.collection('suratmasuk').get();

  Map<String, int> data = {};
  for (var document in snapshot.docs) {
    final tanggal = document['tanggal'];
    final dateTime = tanggal.toDate();
    final format = DateFormat("yyyy");
    final tahun = format.format(dateTime);

    if (data.containsKey(tahun)) {
      data[tahun] = (data[tahun]! + 1);
    } else {
      data[tahun] = 1;
    }
  }

  return data;
}

class ReportSuratMasukPerTahun extends StatelessWidget {
  const ReportSuratMasukPerTahun({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          title: Text('Laporan Surat Masuk'),
          centerTitle: true,
          elevation: 0,
        ),
        body: FutureBuilder(
          future: getData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final Map<String, int> data = snapshot.data as Map<String, int>;
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
            }
        ),
    );
  }

  Future<Uint8List> generateDocument(
      PdfPageFormat format, Map<String, int> data) async {
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
          child: pw.Text("Laporan Surat Masuk Pertahun",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
        ),
        pw.SizedBox(height: 20),
        pw.Table(
            columnWidths: {
              0: pw.FlexColumnWidth(0.2),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1.4),
            },
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(children: [
                pw.Expanded(child: pw.Text("No",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 10,fontWeight: pw.FontWeight.bold)),),
                pw.Expanded(child: pw.Text("Tahun",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold
                    )),),
                pw.Expanded(child: pw.Text("Jumlah Surat masuk",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 10,fontWeight: pw.FontWeight.bold)),)
              ]),
            ]),
        pw.Table(
          columnWidths: {
            0: pw.FlexColumnWidth(0.2),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1.4),
          },
          border: pw.TableBorder.all(),
          children: data.entries.toList().asMap().entries.map((e) {
            int index = e.key + 1;
            MapEntry<String, int> dataEntry = e.value;
            int suratmasuk = dataEntry.value;
            return pw.TableRow(children: [
              pw.Expanded(child: pw.Text(index.toString(),textAlign: pw.TextAlign.center,)),
              pw.Expanded(child: pw.Text(dataEntry.key,textAlign: pw.TextAlign.center),),
              pw.Expanded(child: pw.Text(
                suratmasuk.toString(),
                textAlign: pw.TextAlign.center,
              ),)
            ]);
          }).toList(),
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
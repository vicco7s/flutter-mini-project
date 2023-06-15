

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ReportSuratPengganti extends StatelessWidget {
  final DocumentSnapshot suratpenggantiDoc;
  const ReportSuratPengganti({super.key, required this.suratpenggantiDoc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Surat Pengganti PJD'),
        centerTitle: true,
        elevation: 0,
      ),
      body: PdfPreview(
        canChangeOrientation: false,
        canDebug: false,
        build: (
          PdfPageFormat format,
        ) =>
            generateDocument(
          format,
          suratpenggantiDoc,
        ),
      ),
    );
  }

  Future<Uint8List> generateDocument(PdfPageFormat format,
      DocumentSnapshot<Object?> suratpenggantiDoc) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);
    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();

    final memoryImage = pw.MemoryImage(
      (await rootBundle.load('image/kabtapin.png')).buffer.asUint8List(),
    );

    await initializeDateFormatting('id', null);
    final Timestamp timerStamp = suratpenggantiDoc['tanggal_surat'];
    final Timestamp timerStamps = suratpenggantiDoc['tanggal_perjalanan'];
    var date = timerStamp.toDate();
    var dates = timerStamps.toDate();
    var tanggal_surat = DateFormat('EEEE, d MMMM yyyy', 'id').format(date);
    var tanggal_perjalanan = DateFormat.yMMMMd('id').format(dates);

    doc.addPage(pw.MultiPage(
      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
      build: (context) => [

        //cop surat 
        pw.Column(children: [
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
            ),
          ]
        ),
        
        pw.Divider(thickness: 3),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [pw.Text(tanggal_surat.toString()),],
        ),
        pw.SizedBox(height: 20),

        //body surat
        pw.Column(children: [

          pw.Row(children: [pw.Paragraph(
            text: 'Perihal : '+'Pergantian Pegawai Dalam Perjalanan Dinas',),],),
          pw.Row(children: [
            pw.Paragraph(
            text: 'Kepada,',),
          ]),
          pw.Row(children: [
            pw.Paragraph(
            text: '${suratpenggantiDoc['nama_pengganti']}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,)),
          ]),
          pw.Row(children: [
            pw.Paragraph(
            text: 'Dengan Hormat,',),
          ]),

        pw.Paragraph(
            text: '     Bersama surat ini, kami ingin menginformasikan bahwa pegawai kami, ' +
            '${suratpenggantiDoc['nama']}, yang seharusnya melaksanakan perjalanan dinas pada tanggal '+
            '${tanggal_perjalanan.toString()}, tidak dapat melaksanakan tugas tersebut karena '+
            '${suratpenggantiDoc['alasan']}.',),
       
        pw.Paragraph(
          text: '     Sebagai pengganti, kami telah menunjuk  ** ' + 
          '${suratpenggantiDoc['nama_pengganti']}' +' **. untuk melaksanakan perjalanan dinas tersebut.'+
          ' ${suratpenggantiDoc['nama_pengganti']} telah kami berikan briefing terkait tugas dan tanggung jawab yang harus diemban selama perjalanan dinas',

        ),

        pw.Paragraph(
          text: '     Kami memohon pengertian dan kerjasama dari pihak pegawai. Terima kasih atas perhatian dan kerjasamanya.'),

        ]),

        ]),

         pw.SizedBox(height: 60),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
          pw.Column(children: [
           pw.Text("Camat"),
            pw.SizedBox(height: 30),
            pw.Padding(
                padding: const pw.EdgeInsets.only(),
                child: pw.Text("Akhmad, S.Sos., M.AP",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Padding(
                padding: const pw.EdgeInsets.only(),
                child: pw.Text("198106202010011029",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          ])
        ])
      ]
    ));

    return doc.save();
  }
}

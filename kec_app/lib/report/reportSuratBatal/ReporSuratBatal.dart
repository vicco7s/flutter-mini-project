import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ReportSuratBatal extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const ReportSuratBatal({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Surat Batal PJD'),
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
          documentSnapshot,
        ),
      ),
    );
  }

  Future<Uint8List> generateDocument(
      PdfPageFormat format, DocumentSnapshot<Object?> documentSnapshot) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);
    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();

    final memoryImage = pw.MemoryImage(
      (await rootBundle.load('image/kabtapin.png')).buffer.asUint8List(),
    );

    final Timestamp timerStamp = documentSnapshot['tanggal_surat'];
    final Timestamp timerStamps = documentSnapshot['tanggal_perjalanan'];
    var date = timerStamp.toDate();
    var dates = timerStamps.toDate();
    var tanggal_surat = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
    var tanggal_perjalanan = DateFormat.yMMMMd('id_ID').format(dates);


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
            text: 'Perihal : '+'Penolakan Perintah Perjalanan Dinas',),],),
          pw.Row(children: [
            pw.Paragraph(
            text: 'Kepada,',),
          ]),
          pw.Row(children: [
            pw.Paragraph(
            text: 'Bapak Camat Salam Babaris',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,)),
          ]),
          pw.Row(children: [
            pw.Paragraph(
            text: 'Dengan Hormat,',),
          ]),

        pw.Paragraph(
            text: '   Saya, '+ documentSnapshot['nama'] + ' dengan ini mengajukan ' +
            'penolakan terhadap perintah perjalanan dinas yang telah '+
            'diberikan kepada saya untuk tanggal '+ tanggal_perjalanan.toString()+'.',),
       
        pw.Paragraph(
          text: '   Alasan penolakan ini adalah ** ' + 
          '${documentSnapshot['alasan']}' +' **. '+ 'Saya memohon pengertian dan kebijaksanaan '+
          'dari pihak yang berwenang untuk mempertimbangkan ' + 'penolakan ini. Saya akan '+
          'tetap berkomitmen untuk melaksanakan tugas-tugas yang lain yang diberikan '+
          'kepada saya dalam lingkup kerja saya.',

        ),

        pw.Paragraph(
          text: '   Demikianlah surat penolakan ini saya sampaikan. Terima kasih atas perhatian dan pengertiannya.'),

        ]),

        ]),

        

        pw.SizedBox(height: 60),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
          pw.Column(children: [
            pw.Text("Hormat Saya,"),
            pw.SizedBox(height: 50),
            pw.Padding(
                padding: const pw.EdgeInsets.only(),
                child: pw.Text(documentSnapshot['nama'],
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          ])
        ])
      ],
    ));

    return doc.save();
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../../../util/OptionDropDown.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';


final FirebaseFirestore firestore = FirebaseFirestore.instance;
String selectedYear = ''; // default

Future<Map<String, int>> getData() async {
  final QuerySnapshot snapshot = await firestore.collection('suratkeluar').get();

  Map<String, int> data = {};
  for (var document in snapshot.docs) {
    final tanggal = document['tanggal'];
    final dateTime = tanggal.toDate();
    final format = DateFormat("MMMM");
    final bulan = format.format(dateTime);
    final tahun = "${dateTime.year}";
    // Tambahkan filter tahun
    if (tahun != selectedYear) {
      continue;
    }

    if (data.containsKey(bulan)) {
      data[bulan] = (data[bulan]! + 1);
    } else {
      data[bulan] = 1;
    }
  }

  return data;
}

class ReportOutperbulan extends StatefulWidget {
  const ReportOutperbulan({
    super.key,
  });

  @override
  // ignore: no_logic_in_create_state
  State<ReportOutperbulan> createState() => _ReportOutperbulanState();
}

class _ReportOutperbulanState extends State<ReportOutperbulan> {
  List<String> years = [];

  @override
  void initState() {
    super.initState();
    fetchYearsFromFirestore();
  }

  Future<void> fetchYearsFromFirestore() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('suratkeluar').get();
    for (var doc in snapshot.docs) {
      String year = DateFormat('yyyy').format(doc['tanggal'].toDate());
      if (!years.contains(year)) {
        years.add(year);
      }
    }
    years = years.reversed.toList(); // Ubah urutan menjadi terbalik (terbaru di atas)
    setState(() {
      selectedYear = years.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          title: Text('Laporan Surat Keluar'),
          centerTitle: true,
          elevation: 0,
          actions: [
            DropdownButton<String>(
              value: selectedYear,
              onChanged: (newValue) {
                setState(() {
                  selectedYear = newValue!;
                });
              },
              items: years.map((year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
            ),
          ],
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
            })
        
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
          child: pw.Text("Laporan Surat Keluar Perbulan",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
        ),
        pw.SizedBox(height: 20),
        pw.Text("Periode Tahun : "+selectedYear,style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Table(
            columnWidths: {
              0: pw.FlexColumnWidth(0.2),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(1.4),
            },
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(children: [
                pw.Expanded(child: pw.Text("No",textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold
                    ))),
                pw.Expanded(child: pw.Text("Bulan",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold
                    )),),
                pw.Expanded(child: pw.Text("Jumlah",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 10,fontWeight: pw.FontWeight.bold)),),
              ]),
            ]),
        pw.Table(
          columnWidths: {
            0: pw.FlexColumnWidth(0.2),
            1: pw.FlexColumnWidth(2),
            2: pw.FlexColumnWidth(1.4),
          },
          border: pw.TableBorder.all(),
          children: data.entries.toList().asMap().entries.map((e) {
            int index = e.key + 1;
            MapEntry<String, int> dataEntry = e.value;
            int suratkeluar = dataEntry.value;
            return pw.TableRow(children: [
              pw.Expanded(child: pw.Text(index.toString(),textAlign: pw.TextAlign.center,)),
              pw.Expanded(child: pw.Text(dataEntry.key),),
              pw.Expanded(child: pw.Text(
                suratkeluar.toString(),
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

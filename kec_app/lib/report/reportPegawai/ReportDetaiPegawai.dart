import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Fungsi untuk mengambil data dari Firestore
Future<Map<String, dynamic>> getData() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('pegawai')
      .orderBy("id", descending: false) // Ganti dengan nama koleksi Anda
      .get();

  List<DocumentSnapshot> documents = querySnapshot.docs;

  // Buat map untuk menyimpan data pegawai
  Map<String, dynamic> pegawaiData = {};

  // Iterasi setiap dokumen
  for (var document in documents) {
    // Ambil data pegawai dan masukkan ke dalam map
    Map<String, dynamic> pegawai = document.data() as Map<String, dynamic>;
    pegawaiData[document.id] = pegawai;
  }

  return pegawaiData;
}

class ReportDetailPegawai extends StatefulWidget {
  const ReportDetailPegawai({super.key});

  @override
  State<ReportDetailPegawai> createState() => _ReportDetailPegawaiState();
}

class _ReportDetailPegawaiState extends State<ReportDetailPegawai> {
  String selectedFilter = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Report Pegawai'),
        centerTitle: true,
        elevation: 0,
        actions: [
          DropdownButton<String>(
            value: selectedFilter,
            onChanged: (newValue) {
              setState(() {
                selectedFilter = newValue!;
              });
            },
            items: [
              'Semua',
              'ASN',
              'Non-ASN',
            ].map((filter) {
              return DropdownMenuItem<String>(
                value: filter,
                child: Text(filter),
              );
            }).toList(),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<Map<String, dynamic>> filteredData = [];

          if (selectedFilter == 'ASN') {
            filteredData = snapshot.data!.values
                .where((pegawai) => pegawai['status'] == 'ASN')
                .toList()
                .cast<Map<String, dynamic>>();
          } else if (selectedFilter == 'Non-ASN') {
            filteredData = snapshot.data!.values
                .where((pegawai) => pegawai['status'] != 'ASN')
                .toList()
                .cast<Map<String, dynamic>>();
          } else {
            filteredData =
                snapshot.data!.values.toList().cast<Map<String, dynamic>>();
          }

          return PdfPreview(
            canChangeOrientation: false,
            canDebug: false,
            canChangePageFormat: false,
            build: (
              PdfPageFormat format,
            ) =>
                generateDocument(
              format,
              filteredData,
              selectedFilter,
            ),
          );
        },
      ),
    );
  }

  Future<Uint8List> generateDocument(PdfPageFormat format,
      List<Map<String, dynamic>> filteredData, String selectedFilter) async {
    String documentName = "Laporan Pegawai $selectedFilter.pdf";

    final doc = pw.Document(
      pageMode: PdfPageMode.outlines,
    );
    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();

    final memoryImage = pw.MemoryImage(
      (await rootBundle.load('image/kabtapin.png')).buffer.asUint8List(),
    );

    doc.addPage(pw.MultiPage(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      pageTheme: pw.PageTheme(
        pageFormat: PdfPageFormat.a4.landscape,
      ),
      build: (context) => [
        pw.Column(children: [
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                pw.Container(
                    width: 75, height: 75, child: pw.Image(memoryImage)),
                pw.SizedBox(width: 0),
                pw.Column(children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.all(0),
                      child: pw.Text("PEMERINTAHAN KABUPATEN TAPIN",
                          style: pw.TextStyle(
                              fontSize: 25, fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: pw.EdgeInsets.only(top: 5),
                      child: pw.Text("KECAMATAN SALAM BABARIS",
                          style: pw.TextStyle(
                              fontSize: 25, fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: pw.EdgeInsets.only(top: 8),
                      child: pw.Text(
                          "Jalan Transmigrasi No.02 Desa Salam Babaris Kode Pos: 71182",
                          style: pw.TextStyle(
                            fontSize: 19,
                          )))
                ])
              ]),
          pw.Divider(thickness: 3),
          pw.SizedBox(height: 20),
          pw.Center(
            child: pw.Text("Laporan Pegawai",
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 20),
          pw.Row(children: [
            pw.Text(selectedFilter,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ]),
          pw.Table(
              columnWidths: {
                0: pw.FlexColumnWidth(0.3),
                1: pw.FlexColumnWidth(1.5),
                2: pw.FlexColumnWidth(1.9),
              },
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(children: [
                  pw.Expanded(
                    child: pw.Text("No",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    child: pw.Text("Nama/Nip",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    child: pw.Text("TTL",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    child: pw.Text("Gender",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    child: pw.Text("Alamat",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    child: pw.Text("Tgl Mulai Tugas",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    child: pw.Text("Pangkat/\nGol",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    child: pw.Text("Jabatan",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    child: pw.Text("Status/\nJumlah Anak",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    child: pw.Text("Pendidikan",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    child: pw.Text("Status Peg",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                ]),
              ]),
          pw.Table(
            columnWidths: {
              0: pw.FlexColumnWidth(0.3),
              1: pw.FlexColumnWidth(1.5),
              2: pw.FlexColumnWidth(1.9),
            },
            border: pw.TableBorder.all(),
            children: filteredData.map((pegawai) {
              initializeDateFormatting('id', null);
              final Timestamp timerstamps = pegawai['tgl_mulaitugas'];
              final Timestamp timerstamp = pegawai['tgl_lahir'];
              var dates = timerstamps.toDate();
              var date = timerstamp.toDate();
              var tgllahir = DateFormat.yMMMMd('id').format(date);
              var tglmulaitugas = DateFormat.yMMMMd('id').format(dates);

              return pw.TableRow(children: [
                pw.Expanded(
                  child: pw.Text(pegawai['id'].toInt().toString(),
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                ),
                pw.Expanded(
                  child: pw.Text(
                    pegawai['nama'] + '\n' + pegawai['nip'],
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    pegawai['tempat_lahir'] + ', ' + tgllahir.toString(),
                    style: pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(pegawai['jenis_kelamin'],
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                ),
                pw.Expanded(
                  child: pw.Text(pegawai['alamat'],
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                ),
                pw.Expanded(
                  child: pw.Text(tglmulaitugas.toString(),
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                ),
                pw.Expanded(
                  child: pw.Text(
                      (pegawai['pangkat'] != '--' ? pegawai['pangkat'] : '') +
                          '\n' +
                          pegawai['golongan'],
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                ),
                pw.Expanded(
                  child: pw.Text(pegawai['jabatan'],
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                ),
                pw.Expanded(
                  child: pw.Text(
                      pegawai['status_pernikahan'] +
                          '\n' +
                          pegawai['jumlah_anak'].toString(),
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                ),
                pw.Expanded(
                  child: pw.Text(pegawai['pendidikan_terakhir'],
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                ),
                pw.Expanded(
                    child: pw.Text(pegawai['status'],
                        style: pw.TextStyle(fontSize: 8),
                        textAlign: pw.TextAlign.center)),
              ]);
            }).toList(),
          ),
        ]),
        pw.SizedBox(height: 60),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
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
      ],
    ));
    final Uint8List pdfbytes = await doc.save();
    return pdfbytes;
  }

}

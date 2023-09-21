import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class ReportHonorPegawai extends StatefulWidget {
  const ReportHonorPegawai({Key? key}) : super(key: key);

  @override
  State<ReportHonorPegawai> createState() => _ReportHonorPegawaiState();
}

class _ReportHonorPegawaiState extends State<ReportHonorPegawai> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    // Set default start and end date to current month
    final now = DateTime.now();
    startDate = DateTime(now.year, now.month, 2);
    endDate = DateTime(now.year, now.month + 1, 0);
  }

  Future<Map<String, dynamic>> getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('gajihonorpegawai')
        .orderBy("id", descending: false) // Ganti dengan nama koleksi Anda
        .get();

    List<DocumentSnapshot> documents = querySnapshot.docs;

    // Buat map untuk menyimpan data pegawai
    Map<String, dynamic> honorData = {};

    // Iterasi setiap dokumen
    for (var document in documents) {
      Map<String, dynamic> honor = document.data() as Map<String, dynamic>;
      Timestamp timestamp = honor['tanggal'];

      // Konversi Timestamp menjadi DateTime
      DateTime date = timestamp.toDate();

      // Periksa apakah tanggal berada dalam rentang yang dipilih
      if (date.isAfter(startDate.subtract(Duration(days: 1))) &&
          date.isBefore(endDate.add(Duration(days: 1)))) {
        honorData[document.id] = honor;
      }
    }

    return honorData;
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(start: startDate, end: endDate);
    final pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: initialDateRange,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(useMaterial3: true).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
            ),
            textSelectionTheme: TextSelectionThemeData(
              selectionColor:
                  Colors.blue, // Warna garis seleksi pada tanggal yang dipilih
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      setState(() {
        startDate = pickedDateRange.start;
        endDate = pickedDateRange.end;
      });
    }
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
        title: Text('Laporan Pegawai'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _selectDateRange(context),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final honorData = snapshot.data!;
            if (honorData.isEmpty) {
              return Center(
                child: Text('No data available'),
              );
            }

            return PdfPreview(
              canChangeOrientation: false,
              canDebug: false,
              build: (
                PdfPageFormat format,
              ) =>
                  generateDocument(
                format,
                honorData,
              ),
            );
          } else {
            return Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }

  Future<Uint8List> generateDocument(
      PdfPageFormat format, Map<String, dynamic> honorData) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);
    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();

    final memoryImage = pw.MemoryImage(
      (await rootBundle.load('image/kabtapin.png')).buffer.asUint8List(),
    );

    await initializeDateFormatting('id', null);

    doc.addPage(pw.MultiPage(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      build: (context) => [
        pw.Column(children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Container(width: 65, height: 65, child: pw.Image(memoryImage)),
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
          pw.SizedBox(height: 20),
          pw.Center(
            child: pw.Text("Laporan Pembayaran Honor / PTT",
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text("Periode Bulan ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
              pw.Text(
                '"Dari '+DateFormat('dd MMMM yyyy','id').format(startDate),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                " Sampai ",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                DateFormat('dd MMMM yyyy','id').format(endDate)+'"',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Table(
              columnWidths: {
                0: pw.FlexColumnWidth(0.3),
                1: pw.FlexColumnWidth(1.5),
                2: pw.FlexColumnWidth(1.0),
                7: pw.FlexColumnWidth(1.4),
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
                    child: pw.Text("Nama",
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
                    child: pw.Text("Tanggal",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    child: pw.Text("Pembayaran",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    child: pw.Text("Bonus",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    child: pw.Text("Total",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    child: pw.Text("Keterangan",
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
              2: pw.FlexColumnWidth(1.0),
              7: pw.FlexColumnWidth(1.4),
            },
            border: pw.TableBorder.all(),
            children: honorData.entries.toList().asMap().entries.map((entry) {
              final index = entry.key + 1;
              final data = entry.value;
              final Timestamp timerStamp = data.value['tanggal'];
              var date = timerStamp.toDate();
              var tanggal = DateFormat.yMMMMd().format(date);

              return pw.TableRow(children: [
                pw.Expanded(
                  child: pw.Text(index.toString(),
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                ),
                pw.Expanded(
                  child: pw.Text(" "+
                    data.value['nama'],
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    data.value['jabatan'],
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    tanggal.toString(),
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                      NumberFormat.currency(locale: 'id', symbol: 'Rp')
                          .format(data.value['gaji_honor'])
                          .replaceAll(RegExp(r'(\.|,)00\b'), ''),
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                ),
                pw.Expanded(
                  child: pw.Text(
                      NumberFormat.currency(locale: 'id', symbol: 'Rp')
                          .format(data.value['bonus'])
                          .replaceAll(RegExp(r'(\.|,)00\b'), ''),
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                ),
                pw.Expanded(
                  child: pw.Text(
                      NumberFormat.currency(locale: 'id', symbol: 'Rp')
                          .format(data.value['total'])
                          .replaceAll(RegExp(r'(\.|,)00\b'), ''),
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                ),
                pw.Expanded(
                  child: pw.Text(data.value['keterangan'],
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                ),
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

    return doc.save();
  }
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class LaporanSuratBatal extends StatefulWidget {
  const LaporanSuratBatal({super.key});

  @override
  State<LaporanSuratBatal> createState() => _LaporanSuratBatalState();
}

class _LaporanSuratBatalState extends State<LaporanSuratBatal> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    // Set default start and end date to current month
    final now = DateTime.now();
    startDate = DateTime(now.year, now.month, 1);
    endDate = DateTime(now.year, now.month + 1, 0);
  }

  Future<Map<String, dynamic>> getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<QueryDocumentSnapshot> userDocuments = querySnapshot.docs;

    // Buat map untuk menyimpan data pegawai
    Map<String, dynamic> suratBatalData = {};

    // Iterasi setiap dokumen
    for (var userDocument in userDocuments) {
      QuerySnapshot subCollectionSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocument.id)
          .collection('suratbatal')
          .orderBy("id", descending: false)
          .get();

      List<DocumentSnapshot> subCollectionDocuments =
          subCollectionSnapshot.docs;

      // Iterasi setiap dokumen di subkoleksi "suratbatal" pengguna
      for (var subCollectionDocument in subCollectionDocuments) {
        Map<String, dynamic> suratBatalDoc =
            subCollectionDocument.data() as Map<String, dynamic>;
        Timestamp timestamp = suratBatalDoc['tanggal_surat'];

        // Konversi Timestamp menjadi DateTime
        DateTime date = timestamp.toDate();

        // Periksa apakah tanggal berada dalam rentang yang dipilih
        if (date.isAfter(startDate.subtract(Duration(days: 1))) &&
            date.isBefore(endDate.add(Duration(days: 1)))) {
          suratBatalData[subCollectionDocument.id] = suratBatalDoc;
        }
      }
    }

    // Urutkan data berdasarkan tanggal secara menurun
    List<MapEntry<String, dynamic>> sortedSuratBatalData =
        suratBatalData.entries.toList()
          ..sort((a, b) {
            DateTime dateA = a.value['tanggal_surat'].toDate();
            DateTime dateB = b.value['tanggal_surat'].toDate();
            return dateB.compareTo(dateA);
          });

    // Buat map baru untuk menyimpan data surat batal yang sudah diurutkan
    Map<String, dynamic> sortedSuratBatalDataMap =
        Map.fromEntries(sortedSuratBatalData);

    return sortedSuratBatalDataMap;
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
        title: Text('Laporan Surat batal'),
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
            final sortedSuratBatalDataMap = snapshot.data!;
            if (sortedSuratBatalDataMap.isEmpty) {
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
                sortedSuratBatalDataMap,
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

  Future<Uint8List> generateDocument(PdfPageFormat format,
      Map<String, dynamic> sortedSuratBatalDataMap) async {
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
            child: pw.Text("Laporan Surat Batal Perjalanan Dinas",
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            children: [
              pw.Text("Periode Bulan : ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
              pw.Text(
                DateFormat('MMMM yyyy','id').format(startDate),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                " - ",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                DateFormat('MMMM yyyy','id').format(endDate),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          pw.SizedBox(height: 3),
          pw.Table(
              columnWidths: {
                0: pw.FlexColumnWidth(0.2),
                1: pw.FlexColumnWidth(1.0),
                2: pw.FlexColumnWidth(0.5),
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
                    child: pw.Text("Tanggal",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    child: pw.Text("Alasan",
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
              0: pw.FlexColumnWidth(0.2),
              1: pw.FlexColumnWidth(1.0),
              2: pw.FlexColumnWidth(0.5),
            },
            border: pw.TableBorder.all(),
            children: sortedSuratBatalDataMap.entries
                .toList()
                .asMap()
                .entries
                .map((entry) {
              final index = entry.key + 1;
              final data = entry.value;
              final Timestamp timerStamp = data.value['tanggal_surat'];
              var date = timerStamp.toDate();
              var tanggal = DateFormat.yMMMMd('id').format(date);

              return pw.TableRow(children: [
                pw.Expanded(
                  child: pw.Text(
                    index.toString(),
                    style: pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.center
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(" "+
                    data.value['nama'],
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
                  child: pw.Text(data.value['alasan'],
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

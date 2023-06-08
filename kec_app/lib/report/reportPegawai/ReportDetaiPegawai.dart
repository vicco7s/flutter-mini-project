import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Fungsi untuk mengambil data dari Firestore
Future<Map<String, dynamic>> getData() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('pegawai') // Ganti dengan nama koleksi Anda
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
        title: Text('Report Detail Pegawai'),
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
                .toList().cast<Map<String, dynamic>>();
          } else if (selectedFilter == 'Non-ASN') {
            filteredData = snapshot.data!.values
                .where((pegawai) => pegawai['status'] != 'ASN')
                .toList().cast<Map<String, dynamic>>();
          } else {
            filteredData = snapshot.data!.values.toList().cast<Map<String, dynamic>>();
          }

          return PdfPreview(
            canChangeOrientation: false,
            canDebug: false,
            build: (
              PdfPageFormat format,
            ) =>
                generateDocument(
                  format, filteredData,
              ),
            );
        },
      ),
    );
  }

  Future<Uint8List> generateDocument(
      PdfPageFormat format, List<Map<String, dynamic>> filteredData, ) async {
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
          child: pw.Text("Laporan Pegawai",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
        ),
        pw.SizedBox(height: 20),
        pw.Text(selectedFilter,style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Table(
            columnWidths: {
              0: pw.FlexColumnWidth(2.2),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1.4),
            },
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(children: [
                pw.Text("Nama",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold
                    )),
                pw.Text("Jabatan",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 10,fontWeight: pw.FontWeight.bold)),
                    pw.Text("Status",
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
          children: filteredData.map((pegawai) => pw.TableRow(children: [
                    pw.Text(pegawai['nama']),
                    pw.Text(pegawai['jabatan']),
                    pw.Text(pegawai['status']),
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


// Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Text(
//                 //   'Daftar Pegawai',
//                 //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 // ),
//                 DataTable(
//                   columns: const [
//                     DataColumn(label: Text('Nama')),
//                     DataColumn(label: Text('Jabatan')),
//                     DataColumn(label: Text('Status')),
//                   ],
//                   rows: filteredData
//                       .map(
//                         (pegawai) => DataRow(
//                           cells: [
//                             DataCell(Text(pegawai['nama'])),
//                             DataCell(Text(pegawai['jabatan'])),
//                             DataCell(Text(pegawai['status'])),
//                           ],
//                         ),
//                       )
//                       .toList(),
//                 ),
//               ],
//             ),
//           );
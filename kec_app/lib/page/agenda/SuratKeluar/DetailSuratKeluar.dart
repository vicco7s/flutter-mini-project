import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:kec_app/controller/controllerSurat/controllerSuratKeluar.dart';
import 'package:kec_app/util/ContainerDeviders.dart';
import 'package:kec_app/util/controlleranimasiloading/CircularControlAnimasiProgress.dart';
import 'package:kec_app/util/controlleranimasiloading/controlleranimasiprogressloading.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loading_overlay/loading_overlay.dart';

class DetailSuratKeluar extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const DetailSuratKeluar({super.key, required this.documentSnapshot});

  @override
  State<DetailSuratKeluar> createState() => _DetailSuratKeluarState();
}

class _DetailSuratKeluarState extends State<DetailSuratKeluar> {
  late DocumentSnapshot documentSnapshot;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    documentSnapshot = widget.documentSnapshot;
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id', null);
    Timestamp timerstamp = documentSnapshot['tanggal'];
    var date = timerstamp.toDate();
    var timers = DateFormat.yMMMMd('id').format(date);

    final dataSuratKeluar = ControllerSK();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Detail Surat Keluar'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await dataSuratKeluar.update(documentSnapshot, context);
              },
              icon: Icon(FontAwesomeIcons.solidPenToSquare))
        ],
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ColorfulLinearProgressIndicator();
          } else {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Card(
                    elevation: 0.0,
                    color: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: ListTile(
                      title: Text(
                        documentSnapshot['no_berkas'],
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      trailing: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          documentSnapshot['keterangan'],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  indent: 100,
                  endIndent: 100,
                  thickness: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Tanggal Surat Keluar",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Card(
                      elevation: 0.0,
                      color: Color.fromARGB(255, 236, 236, 236),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        children: [
                          Divider(
                            indent: 150,
                            endIndent: 150,
                            thickness: 2,
                          ),
                          ListTile(
                            leading: Text(
                              "Tanggal Surat",
                              style: TextStyle(
                                  color: Colors.blueAccent[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            trailing: Text(
                              timers.toString(),
                              style: TextStyle(
                                  color: Colors.blueAccent[200], fontSize: 16),
                            ),
                          ),
                          Containers(),
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.filePdf,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Dokument Surat Keluar")
                              ],
                            ),
                            onTap: () async {
                              // Validasi jika field pada databases pada firestore tidak di temukan
                              var data = documentSnapshot.data();
                              if (data != null) {
                                if (data is Map<String, dynamic> &&
                                    data.containsKey('berkas')) {
                                  String pdfUrl = data['berkas'] ?? '';

                                  if (pdfUrl.isEmpty) {
                                    print("Berkas tidak ditemukan.");
                                  } else {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PDFBottomSheet(
                                          pdfUrl: pdfUrl,
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                              'Field (berkas) tidak ada dalam data atau tipe datanya tidak valid.')));
                                }
                              } else {
                                print("Data tidak tersedia.");
                              }
                            },
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Penerima",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Card(
                      elevation: 0.0,
                      color: Color.fromARGB(255, 236, 236, 236),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: ListTile(
                        title: Text(documentSnapshot['alamat_penerima'],
                            style: TextStyle(
                                color: Colors.blueAccent[200],
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Perihal",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Card(
                      elevation: 0.0,
                      color: Color.fromARGB(255, 236, 236, 236),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: ListTile(
                        title: Text(documentSnapshot['perihal'],
                            style: TextStyle(
                                color: Colors.blueAccent[200],
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      )),
                ),
              ],
            );
          }
        },
      )),
    );
  }
}

class PDFBottomSheet extends StatefulWidget {
  final String pdfUrl;
  const PDFBottomSheet({super.key, required this.pdfUrl});

  @override
  State<PDFBottomSheet> createState() => _PDFBottomSheetState();
}

class _PDFBottomSheetState extends State<PDFBottomSheet> {
  bool isDownloading = false;
  Future<void> downloadPDF(String pdfUrl) async {
    setState(() {
      isDownloading = true;
    });
    // Memeriksa izin penyimpanan
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // Meminta izin penyimpanan jika belum disetujui
      status = await Permission.storage.request();
      if (!status.isGranted) {
        // Izin ditolak, tampilkan pesan toast
        Fluttertoast.showToast(
          msg: "Izin penyimpanan ditolak",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }
    }

    await Future.delayed(Duration(seconds: 2));
    // Mulai mengunduh PDF
    final pdfFileName = "nama_file.pdf"; // Ganti dengan nama file yang sesuai
    final pdfFile = await DefaultCacheManager().getSingleFile(pdfUrl);
    final pdfPath = pdfFile.path;

    // Tampilkan pesan toast sukses
    Fluttertoast.showToast(
      msg: "PDF berhasil diunduh ke $pdfPath",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    setState(() {
      isDownloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: LoadingOverlay(
        isLoading: isDownloading,
        color: Colors.grey,
        progressIndicator: ColorfulCirclePrgressIndicator(),
        child: Column(
          children: [
            AppBar(
              title: Text('PDF Viewer'),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () async {
                    await downloadPDF(widget.pdfUrl);
                  },
                  icon: Icon(Icons.download_outlined)),
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Expanded(
              child: PDF(
                nightMode: false,
                enableSwipe: true,
                fitEachPage: true,
                preventLinkNavigation: false,
              ).cachedFromUrl(
                widget.pdfUrl,
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}

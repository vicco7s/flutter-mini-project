import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kec_app/components/AddRiwayatPegawai.dart';
import 'package:kec_app/controller/controlerPegawai/controllerriwayatpegawai.dart';
import 'package:kec_app/page/Pegawai/Kinerja_Pegawai/kinerjapegawai.dart';
import 'package:kec_app/page/Pegawai/editpegawai.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/util/ContainerDeviders.dart';
import 'package:kec_app/util/controlleranimasiloading/controlleranimasiprogressloading.dart';

import '../../util/RoundedRectagleutiliti.dart';

class DetailPagePegawai extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const DetailPagePegawai({super.key, required this.documentSnapshot});

  @override
  State<DetailPagePegawai> createState() => _DetailPagePegawaiState();
}

class _DetailPagePegawaiState extends State<DetailPagePegawai> {
  late List<dynamic> riwayatPendidikan =
      widget.documentSnapshot["riwayat_pendidikan"];
  late List<dynamic> riwayatPekerjaan =
      widget.documentSnapshot['riwayat_kerja'];

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id', null);
    Timestamp timerstamp = widget.documentSnapshot['tgl_lahir'];
    Timestamp timerstamps = widget.documentSnapshot['tgl_mulaitugas'];
    var dates = timerstamps.toDate();
    var date = timerstamp.toDate();
    var tgllahir = DateFormat.yMMMMd('id').format(date);
    var tglmulaitugas = DateFormat.yMMMMd('id').format(dates);
    final riwayatData = RiwayatController(
      documentSnapshot: widget.documentSnapshot,
      context: context,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Biodata Pegawai'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => KinerjaPegawai(
                          documentsnapshot: widget.documentSnapshot,
                        )));
              },
              icon: Icon(FontAwesomeIcons.chartLine))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: Future.delayed(Duration(seconds: 2)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: ColorfulLinearProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://img.freepik.com/free-vector/realistic-summer-background-with-vegetation_23-2148998580.jpg?w=1060&t=st=1687849389~exp=1687849989~hmac=4e829af04388c777d47fe73fbaa470a4f8c134646d4e6c1c349b1d8ecefd9065"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Container(
                                                width: 300,
                                                height: 300,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        widget.documentSnapshot[
                                                            "imageUrl"]),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: Text('Close'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          image: DecorationImage(
                                            image: NetworkImage(widget
                                                .documentSnapshot["imageUrl"]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 60,
                                      right: 0,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              CupertinoPageRoute(
                                                  builder: (context) => EditPegawai(
                                                      documentSnapshot: widget
                                                          .documentSnapshot)));
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.solidPenToSquare,
                                          color: Colors.blueAccent,
                                          grade: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.documentSnapshot['nama'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.brown[600]),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Card(
                              color: Color.fromRGBO(254, 253, 228, 100),
                              shape: RoundedRectangleBorders(),
                              elevation: 0.0,
                              child: Column(
                                children: [
                                  ListTile(
                                    title:
                                        Text("Nip", style: TextStyleTitles()),
                                    subtitle: Text(
                                      widget.documentSnapshot['nip'],
                                      style: TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text("Jenis Kelamin",
                                        style: TextStyleTitles()),
                                    subtitle: Text(
                                      widget.documentSnapshot['jenis_kelamin'],
                                      style: TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Tempat, Tanggal lahir",
                                      style: TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      '${widget.documentSnapshot['tempat_lahir']}, ${tgllahir.toString()}',
                                      style: TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Alamat",
                                      style: TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      widget.documentSnapshot['alamat'],
                                      style: TextStyleSubtitles(),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Card(
                            color: Color.fromRGBO(254, 253, 228, 100),
                            shape: RoundedRectangleBorders(),
                            elevation: 0.0,
                            child: ExpansionTile(
                              title: Text(
                                "Kartu Tanda Penduduk(KTP)",
                                style: TextStyleSubtitles(),
                              ),
                              children: [
                                ListTile(
                                  title: Container(
                                    width: 100,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                        image: NetworkImage(widget
                                            .documentSnapshot["imageKtp"]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Card(
                                color: Color.fromRGBO(254, 253, 228, 100),
                                shape: RoundedRectangleBorders(),
                                elevation: 0.0,
                                child: ExpansionTile(
                                  title: Text(
                                    "Riwayat Pendidikan",
                                    style: TextStyleSubtitles(),
                                  ),
                                  children: [
                                    ListTile(
                                      onTap: () async {
                                        await showModalBottomSheet(
                                          isScrollControlled: false,
                                          context: context,
                                          useSafeArea: true,
                                          builder: (BuildContext context) {
                                            return ButtonRwytPendidikan(
                                              tambahPendidikan:
                                                  riwayatData.tambahPendidikan,
                                            );
                                          },
                                        );
                                      },
                                      title: Text(
                                        "Tambah Pendidikan",
                                        style: TextStyleSubtitles(),
                                      ),
                                      leading: Icon(
                                        Icons.add,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: riwayatPendidikan.length,
                                      itemBuilder: (context, index) {
                                        final pendidikanMap =
                                            riwayatPendidikan[index]
                                                as Map<String, dynamic>;
                                        final namaSekolah =
                                            pendidikanMap['nama_sekolah']
                                                as String;
                                        var tahunMulai =
                                            pendidikanMap['tahunmulai']
                                                .toDate()
                                                .year;
                                        var tahunBerakhir =
                                            pendidikanMap['tahunberakhir']
                                                .toDate()
                                                .year;

                                        return ListTile(
                                          title: Text(
                                            tahunMulai.toString() +
                                                " - " +
                                                tahunBerakhir.toString(),
                                            style: TextStyleTitles(),
                                          ),
                                          subtitle: Text(namaSekolah,
                                              style: TextStyleSubtitles()),
                                          trailing: IconButton(
                                              onPressed: () async {
                                                await riwayatData
                                                    .hapusPendidikan(index);
                                                Navigator.of(context).pop();
                                                // _loadData();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        backgroundColor:
                                                            Colors.green,
                                                        content: Text(
                                                            'Berhasil Dihapus')));
                                              },
                                              icon: Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                              )),
                                        );
                                      },
                                    )
                                  ],
                                ))),
                        Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Card(
                                color: Color.fromRGBO(254, 253, 228, 100),
                                shape: RoundedRectangleBorders(),
                                elevation: 0.0,
                                child: ExpansionTile(
                                  title: Text(
                                    "Riwayat Pekerjaan",
                                    style: TextStyleSubtitles(),
                                  ),
                                  children: [
                                    ListTile(
                                      onTap: () async {
                                        await showModalBottomSheet(
                                          isScrollControlled: false,
                                          context: context,
                                          useSafeArea: true,
                                          builder: (BuildContext context) {
                                            return ButtonRwytPekerjaan(
                                              tambahPekerjaan:
                                                  riwayatData.tambahPekerjaan,
                                            );
                                          },
                                        );
                                      },
                                      title: Text(
                                        "Tambah Pekerjaan",
                                        style: TextStyleSubtitles(),
                                      ),
                                      leading: Icon(
                                        Icons.add,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: riwayatPekerjaan.length,
                                      itemBuilder: (context, index) {
                                        final pekerjaanMap =
                                            riwayatPekerjaan[index]
                                                as Map<String, dynamic>;
                                        final namaPekerjaan =
                                            pekerjaanMap['posisi'] as String;
                                        var tahunMulai =
                                            pekerjaanMap['tahunmulai']
                                                .toDate()
                                                .year;
                                        var tahunBerakhir =
                                            pekerjaanMap['tahunberakhir']
                                                .toDate()
                                                .year;
                                        return ListTile(
                                          title: Text(
                                            tahunMulai.toString()+' - '+tahunBerakhir.toString(),
                                            style: TextStyleTitles(),
                                          ),
                                          subtitle: Text(namaPekerjaan,
                                              style: TextStyleSubtitles()),
                                          trailing: IconButton(
                                              onPressed: () async {
                                                await riwayatData
                                                    .hapusPekerjaan(index);
                                                Navigator.of(context).pop();
                                                // _loadData();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        backgroundColor:
                                                            Colors.green,
                                                        content: Text(
                                                            'Berhasil Dihapus')));
                                              },
                                              icon: Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                              )),
                                        );
                                      },
                                    )
                                  ],
                                ))),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Card(
                              color: Color.fromRGBO(254, 253, 228, 100),
                              shape: RoundedRectangleBorders(),
                              elevation: 0.0,
                              child: ExpansionTile(
                                title: Text('Selengkapnya',
                                    style: TextStyleSubtitles()),
                                children: [
                                  ListTile(
                                    title: Text(
                                      "Agama",
                                      style: TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      '${widget.documentSnapshot['agama']}',
                                      style: TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Pendidikan Terakhir",
                                      style: TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      widget.documentSnapshot[
                                          'pendidikan_terakhir'],
                                      style: TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Pangkat/Gol",
                                      style: TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      '${widget.documentSnapshot['pangkat']}/${widget.documentSnapshot['golongan']}',
                                      style: TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Jabatan",
                                      style: TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      '${widget.documentSnapshot['jabatan']}',
                                      style: TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Status Pegawai",
                                      style: TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      '${widget.documentSnapshot['status']}',
                                      style: TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Tanggal Mulai Tugas",
                                      style: TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      '${tglmulaitugas.toString()}',
                                      style: TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Status Pernikahan",
                                      style: TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      widget.documentSnapshot[
                                          'status_pernikahan'],
                                      style: TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Jumlah Anak",
                                      style: TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      widget.documentSnapshot['jumlah_anak']
                                          .toString(),
                                      style: TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                  ListTile(
                                    title: Text(
                                      "Nomor Telpon",
                                      style: TextStyleTitles(),
                                    ),
                                    subtitle: Text(
                                      widget.documentSnapshot['telpon'],
                                      style: TextStyleSubtitles(),
                                    ),
                                  ),
                                  Containers(),
                                ],
                              )),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}



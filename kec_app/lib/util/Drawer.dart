import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kec_app/page/Pegawai/pegawaiASN.dart';
import 'package:kec_app/page/agenda/SuratKeluar/SuratKeluarPage.dart';
import 'package:kec_app/page/agenda/Suratmasuk/SuratMasukPage.dart';
import 'package:kec_app/page/perjalananDinas/pdinaspage.dart';
import 'package:kec_app/report/ReportJumlahPegawai.dart';
import 'package:kec_app/report/Report_pDinas/ReportPDinasPerNama.dart';
import 'package:kec_app/report/Report_surat_Keluar/ReportOutSurelPertahun.dart';
import 'package:kec_app/report/Report_surat_masuk/ReportJumlahSMPerbulan.dart';
import 'package:kec_app/report/Report_surat_masuk/ReportJumlahSMPertahun.dart';
import 'package:kec_app/report/ReportpdfASNNonAsn.dart';
import 'package:kec_app/report/Report_surat_Keluar/ReportpdfOutSurel.dart';

class Drawes extends StatelessWidget {
  const Drawes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('image/salba.jpg'), fit: BoxFit.fill),
            ),
            child: Text(
              'Menu Utama',
              // style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text('DashBoard'),
            onTap: () {},
          ),
          ExpansionTile(
            leading: Icon(Icons.groups_outlined),
            title: Text("Kepegawaian"),
            children: <Widget>[
              ListTile(
                title: Text(
                  'Data Pegawai',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      CupertinoPageRoute(builder: ((context) => PegawaiAsn())));
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.mail_outline),
            title: Text("Surat Agenda"),
            children: <Widget>[
              ListTile(
                title: Text(
                  'Data Surat Masuk',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: ((context) => SuratMasukPage())));
                },
              ),
              ListTile(
                title: Text(
                  'Data Surat Keluar',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: ((context) => SuratKeluarPage())));
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.emoji_transportation_outlined),
            title: Text("Perjalanan Dinas"),
            children: <Widget>[
              ListTile(
                title: const Text(
                  'Data Perjalanan Dinas',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      CupertinoPageRoute(builder: ((context) => DinasPageList())));
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.ad_units_outlined),
            title: Text("Laporan"),
            children: <Widget>[
              ListTile(
                title: const Text(
                  'Laporan Pegawai Asn Dan Bukan Asn',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => ReportPegawaiAsn()));
                },
              ),
              ListTile(
                title: const Text(
                  'Laporan Pegawai Berdasarkan Pangkat',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                   Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => ReportJumlahPegawai()));
                },
              ),
              ListTile(
                title: const Text(
                  'Laporan Surat Masuk Perbulan',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: ((context) => const ReportJmSuratMasuk())));
                },
              ),
              ListTile(
                title: const Text(
                  'Laporan Surat Masuk Pertahun',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: ((context) => const ReportSuratMasukPerTahun())));
                },
              ),
              ListTile(
                title: const Text(
                  'Laporan Surat Keluar Perbulan',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: ((context) => const ReportOutperbulan())));
                },
              ),
              ListTile(
                title: const Text(
                  'Laporan Surat Keluar PerTahun',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: ((context) => const ReportOutSurelPertahun())));
                },
              ),
              ListTile(
                title: const Text(
                  'Laporan Perjalanan Dinas PerTahun',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: ((context) => const ReportpDinasPertahun())));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

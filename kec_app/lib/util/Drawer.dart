import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/page/Pegawai/GajiHonorPegawai/Gajihonorpegawai.dart';
import 'package:kec_app/page/Pegawai/pegawaiASN.dart';
import 'package:kec_app/page/agenda/SuratKeluar/SuratKeluarPage.dart';
import 'package:kec_app/page/agenda/Suratmasuk/SuratMasukPage.dart';
import 'package:kec_app/page/agenda/suratBatalPerjalanan/suratbatalPJD.dart';
import 'package:kec_app/page/agenda/suratPegantiPegawaiPJD/pilihpegawai.dart';
import 'package:kec_app/page/perjalananDinas/pdinaspage.dart';
import 'package:kec_app/report/Report_pDinas/ReportBuktiKegiatanPJD.dart';
import 'package:kec_app/report/Report_pDinas/ReportPDinasPerNama.dart';
import 'package:kec_app/report/Report_pDinas/ReportPriodePjd.dart';
import 'package:kec_app/report/Report_surat_Keluar/ReportOutSurelPertahun.dart';
import 'package:kec_app/report/Report_surat_masuk/ReportJumlahSMPerbulan.dart';
import 'package:kec_app/report/Report_surat_masuk/ReportJumlahSMPertahun.dart';
import 'package:kec_app/report/Report_surat_Keluar/ReportpdfOutSurel.dart';
import 'package:kec_app/report/reportPegawai/ReportDetaiPegawai.dart';
import 'package:kec_app/report/reportPegawai/ReportJumlahPegawai.dart';
import 'package:kec_app/report/reportPegawai/ReportPembayaranHonor.dart';
import 'package:kec_app/report/reportPegawai/ReportpdfASNNonAsn.dart';
import 'package:kec_app/report/reportSuratBatal/LaporanSuratbatal.dart';
import 'package:kec_app/report/reportSuratPengganti/LaporanSuratPengganti.dart';

class Drawes extends StatelessWidget {
  const Drawes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('image/salba.jpg'), fit: BoxFit.cover),
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
                ListTile(
                  title: Text(
                    'Gaji Honor Pegawai',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                        CupertinoPageRoute(builder: ((context) => const GajiHonorPegawai())));
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
                ListTile(
                  title: Text(
                    'Data Surat Penganti',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: ((context) => PilihPegawaiSP())));
                  },
                ),
                ListTile(
                  title: Text(
                    'Data Surat Batal',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: ((context) => SuratBatalAdminPJD())));
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
            
            //Laporan
            ExpansionTile(
              leading: Icon(Icons.ad_units_outlined),
              title: Text("Laporan"),
              children: <Widget>[
                ExpansionTile(
                  title: Text("Laporan Pegawai"),
                  children: <Widget>[
                    ListTile(
                          title: const Text(
                          'Laporan Pegawai Asn Dan Bukan Asn',
                          style: TextStyle(fontSize: 13),                  
                      ),
                      onTap:(){
                        Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const ReportPegawaiAsn()));
                      }
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
                    'Laporan Detail Pegawai',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                     Navigator.of(context).push(
                CupertinoPageRoute(builder: (context) => ReportDetailPegawai()));
                  },
                ),
                ListTile(
                  title: const Text(
                    'Laporan Gaji Honor',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                     Navigator.of(context).push(
                CupertinoPageRoute(builder: (context) => ReportHonorPegawai()));
                  },
                ),
                  ],
                ),
                
                ExpansionTile(
                  title: Text("Laporan Surat"),
                  children: [
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
                    'Laporan Surat Batal',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: ((context) => const LaporanSuratBatal())));
                  },
                ),
          
                ListTile(
                  title: const Text(
                    'Laporan Surat Pengganti',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: ((context) => const LaporanSuratPengganti())));
                  },
                ),
              ],
            ),
                
                ExpansionTile(
                  title: Text("Laporan Perjalanan Dinas"),
                  children: [
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
          
                    ListTile(
                      title: const Text(
                        'Laporan Perjalanan Dinas Bulanan',
                        style: TextStyle(fontSize: 13),
                      ),
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: ((context) => const LaporanPjdPerbulan())));
                      },
                    ),
                    
                  ],
                ),
              ],
            ),
              ],
            ),
          ),
          ListTile(
          leading: Text('Powered By Uniska'),
        ),
        ],
      ),
    );
  }
}

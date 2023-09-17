import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RiwayatController {
  final DocumentSnapshot documentSnapshot;
  final BuildContext context;

  RiwayatController({
    required this.documentSnapshot,
    required this.context,
  });

  final CollectionReference pegawaiCollection =
      FirebaseFirestore.instance.collection('pegawai');

  Future<void> tambahPendidikan(String pendidikanBaru, DateTime tahunmulai, DateTime tahunberakhir) async {
    List<dynamic> riwayatPendidikan = documentSnapshot["riwayat_pendidikan"];
    try {
      final Map<String, dynamic> dataBaru = {
        'nama_sekolah': pendidikanBaru,
        'tahunmulai': tahunmulai,
        'tahunberakhir': tahunberakhir,
      };

      final List<dynamic> updatedRiwayatPendidikan =
          List.from(riwayatPendidikan);
      updatedRiwayatPendidikan.add(dataBaru);

      await pegawaiCollection.doc(documentSnapshot.id).update({
        'riwayat_pendidikan': updatedRiwayatPendidikan,
      });

      // Tunggu 2 detik sebelum merefresh tampilan.
      await Future.delayed(Duration(milliseconds: 100));
      // // Perbarui tampilan dengan mengganti state.
      // setState(() {
      //   riwayatPendidikan = updatedRiwayatPendidikan;
      // });
    } catch (e) {
      print('Error tambah pendidikan: $e');
      // Handle error jika terjadi.
    }
  }

  Future<void> hapusPendidikan(int index) async {
    List<dynamic> riwayatPendidikan = documentSnapshot["riwayat_pendidikan"];
    try {
      final List<dynamic> updatedRiwayatPendidikan =
          List.from(riwayatPendidikan);
      updatedRiwayatPendidikan.removeAt(index);

      // Perbarui data langsung di Firestore dengan FieldValue.arrayRemove.
      await pegawaiCollection.doc(documentSnapshot.id).update({
        'riwayat_pendidikan':
            FieldValue.arrayRemove([riwayatPendidikan[index]]),
      });

      // Tunggu sejenak sebelum merefresh tampilan.
      await Future.delayed(Duration(milliseconds: 100));
      // Optional: Refresh tampilan atau lakukan sesuatu setelah berhasil menghapus data.
    } catch (e) {
      print('Error hapus pendidikan: $e');
      // Handle error jika terjadi.
    }
  }

  // Riwayat Pekerjaan
  Future<void> tambahPekerjaan(String pekerjaanBaru, DateTime tahunmulai, DateTime tahunberakhir) async {
    List<dynamic> riwayatPekerjaan = documentSnapshot['riwayat_kerja'];
    try {
      final Map<String, dynamic> dataBaru = {
        'posisi': pekerjaanBaru,
        'tahunmulai': tahunmulai,
        'tahunberakhir': tahunberakhir,
      };

      final List<dynamic> updatedRiwayatPekerjaan =
          List.from(riwayatPekerjaan);
      updatedRiwayatPekerjaan.add(dataBaru);

      await pegawaiCollection.doc(documentSnapshot.id).update({
        'riwayat_kerja': updatedRiwayatPekerjaan,
      });

      // Tunggu 2 detik sebelum merefresh tampilan.
      await Future.delayed(Duration(milliseconds: 100));
      // // Perbarui tampilan dengan mengganti state.
      // setState(() {
      //   riwayatPendidikan = updatedRiwayatPendidikan;
      // });
    } catch (e) {
      print('Error tambah pendidikan: $e');
      // Handle error jika terjadi.
    }
  }

  Future<void> hapusPekerjaan(int index) async {
    List<dynamic> riwayatPekerjaan = documentSnapshot['riwayat_kerja'];
    try {
      final List<dynamic> updatedRiwayatPekerjaan =
          List.from(riwayatPekerjaan);
      updatedRiwayatPekerjaan.removeAt(index);

      // Perbarui data langsung di Firestore dengan FieldValue.arrayRemove.
      await pegawaiCollection.doc(documentSnapshot.id).update({
        'riwayat_kerja':
            FieldValue.arrayRemove([riwayatPekerjaan[index]]),
      });

      // Tunggu sejenak sebelum merefresh tampilan.
      await Future.delayed(Duration(milliseconds: 100));
      // Optional: Refresh tampilan atau lakukan sesuatu setelah berhasil menghapus data.
    } catch (e) {
      print('Error hapus pendidikan: $e');
      // Handle error jika terjadi.
    }
  }

}



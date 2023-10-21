// ignore_for_file: unused_field

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../model/pegawaiAsnServices.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ControllerPegawai {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference pegawai =
      FirebaseFirestore.instance.collection('pegawai');

  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  void createInputPegawai(InputAsn inputAsn) async {
    final json = inputAsn.toJson();
    var querySnapshot =
        await pegawai.orderBy("id", descending: true).limit(1).get();
    var maxId =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("id") : 0;
    json["id"] = maxId + 1;
    json["imageUrl"] = inputAsn.imageUrl;
    var docRef = await pegawai.add(json);

    String uid = docRef.id;
    await pegawai.doc(uid).update({'uid': uid});
  }


  Future<void> delete(String id, BuildContext context) async {
    try {
      // Dapatkan URL gambar dari Firestore
      final snapshot = await pegawai.doc(id).get();
      final data = snapshot.data();

      if (snapshot.exists &&
          data != null &&
          data is Map<String, dynamic> &&
          data['uid'] != null) {
        final uid = data['uid'];

        // Hapus dokumen dari koleksi 'pegawai'
        await pegawai.doc(id).delete();

        // Dapatkan dokumen dengan UID yang sama dari koleksi 'users'
        final userQuery = await users.where('uid', isEqualTo: uid).get();

        if (userQuery.docs.isNotEmpty) {
          final userDoc = userQuery.docs[0];
          final userId = userDoc.id;

          // Hapus dokumen dari koleksi 'users'
          await users.doc(userId).delete();
        }
      }

      if (snapshot.exists &&
          data != null &&
          data is Map<String, dynamic> &&
          data['imageUrl'] != null &&
          data['imageKtp'] != null) {
        final imageUrl = data['imageUrl'];
        final imageKtp = data['imageKtp'];

        // Hapus imageUrl dan imageKtp dari Firebase Storage
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
        await FirebaseStorage.instance.refFromURL(imageKtp).delete();

        // Hapus dokumen dari Firestore
        await pegawai.doc(id).delete();

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Data Berhasil Dihapus'),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Data tidak berhasil dihapus'),
          ),
        );
      }
    } on StateError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Data tidak berhasil di hapus')));
    }
  }

  Future<void> updateImage(File imageFile, String documentID) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference = storage
          .ref()
          .child('images/' + DateTime.now().millisecondsSinceEpoch.toString());

      // Mengambil URL gambar sebelumnya dari Firestore
      DocumentSnapshot docSnapshot = await pegawai.doc(documentID).get();
      String previousImageUrl = docSnapshot.get('imageUrl');

      // Menghapus foto sebelumnya dari Firebase Storage jika ada
      if (previousImageUrl != null) {
        Reference previousImageRef = storage.refFromURL(previousImageUrl);
        await previousImageRef.delete();
      }

      if (imageFile != null) {
        UploadTask uploadTask = storageReference.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        pegawai.doc(documentID).update({
          'imageUrl': imageUrl,
        });
      }
    } catch (error) {
      print(error);
      // Handle error
    }
  }

  Future<void> updateImageKtp(File imageFile, String documentID) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference = storage
          .ref()
          .child('images/' + DateTime.now().millisecondsSinceEpoch.toString());

      // Mengambil URL gambar sebelumnya dari Firestore
      DocumentSnapshot docSnapshot = await pegawai.doc(documentID).get();
      String previousImageUrl = docSnapshot.get('imageKtp');

      // Menghapus foto sebelumnya dari Firebase Storage jika ada
      if (previousImageUrl != null) {
        Reference previousImageRef = storage.refFromURL(previousImageUrl);
        await previousImageRef.delete();
      }

      if (imageFile != null) {
        UploadTask uploadTask = storageReference.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        String imageKtp = await taskSnapshot.ref.getDownloadURL();

        pegawai.doc(documentID).update({
          'imageKtp': imageKtp,
        });
      }
    } catch (error) {
      print(error);
      // Handle error
    }
  }
}

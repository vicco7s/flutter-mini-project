
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/model/UserService/suratbatalservice.dart';


class ControllerSuratBatal {
  final _auth = FirebaseAuth.instance;
  User? _currentUser;

  

  Future<void> delete(String id, BuildContext context) async {
    try {
     _currentUser = _auth.currentUser;
      final _suratBatal = FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser?.uid)
          .collection('suratbatal');

      await _suratBatal.doc(id).delete();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Data Berhasil Di hapus')));
      // ignore: use_build_context_synchronously
    } on StateError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Data tidak berhasil di hapus')));
    }
  }

  void createInputSuratBatal(SuratBatal suratBatal) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');

      final CollectionReference suratBatalCollection =
          userCollection.doc(userId).collection('suratbatal');

      final json = suratBatal.toJson();
      
      var querySnapshot =
          await suratBatalCollection.orderBy("id", descending: true).limit(1).get();
      var maxId =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("id") : 0;
      json["id"] = maxId + 1;
      
      await suratBatalCollection.add(json);
    }
  }

}
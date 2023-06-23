import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/api/firebase_api.dart';
import 'package:kec_app/model/UserService/suratbatalservice.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/util/OptionDropDown.dart';

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

      var querySnapshot = await suratBatalCollection
          .orderBy("id", descending: true)
          .limit(1)
          .get();
      var maxId = querySnapshot.docs.isNotEmpty
          ? querySnapshot.docs.first.get("id")
          : 0;
      json["id"] = maxId + 1;

      await suratBatalCollection.add(json);

      // Mengirim notifikasi saat surat batal ditambahkan
      final title = 'Surat Batal Baru';
      final body = 'Surat batal dengan ID ${json['id']} telah ditambahkan.';
      await FirebaseApi().sendNotification(title, body);
      
    }
  }

  Future<void> update(
      DocumentSnapshot documentSnapshot,
      QueryDocumentSnapshot<Object?> suratBatalDoc,
      BuildContext context) async {
    final _formkey = GlobalKey<FormState>();
    final _no = TextEditingController();
    final _keterangan = TextEditingController();

    _no.text = suratBatalDoc['id'].toString();
    _keterangan.text = suratBatalDoc['keterangan'];

    final CollectionReference userCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(documentSnapshot.id)
        .collection('suratbatal');

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          var options = [
            'Mohon Tunggu',
            'Disetujui',
            'Dibatalkan',
          ];

          var _statusvalue = suratBatalDoc['status'];
          var _status = suratBatalDoc['status'];

          return DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: 20,
                            left: 20,
                            right: 20,
                            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<String>(
                              dropdownColor: Colors.white,
                              isExpanded: true,
                              iconEnabledColor: Colors.black,
                              focusColor: Colors.black,
                              items: options.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(
                                    dropDownStringItem,
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                _statusvalue = newValueSelected!;
                              },
                              value: _status,
                              decoration: const InputDecoration(
                                labelText: 'Status',
                              ),
                            ),
                            TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 2,
                              controller: _keterangan,
                              decoration: const InputDecoration(
                                  labelText: 'Keterangan'),
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  child: const Text('Update'),
                                  onPressed: () async {
                                    final int no = int.parse(_no.text);
                                    final String status = _statusvalue;
                                    final String ket = _keterangan.text;
                                    if (no != null) {
                                      await userCollection
                                          .doc(suratBatalDoc.id)
                                          .update({
                                        "status": status,
                                        "keterangan": ket,
                                      });
                                      _status = '';
                                      _keterangan.text = '';
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  'Berhasil Memperbarui Data')));
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  onPressed: (() => Navigator.pop(context)),
                                  child: const Text("Cencel"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red, // background
                                    foregroundColor: Colors.white, // foreground
                                  ),
                                ),
                              ],
                            )
                          ],
                        )));
              });
        });
  }
}

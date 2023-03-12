
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/components/DropdownButtomFormUpdates.dart';
import 'package:kec_app/model/pegawaiAsnServices.dart';
import 'package:kec_app/util/OptionDropDown.dart';

class ControllerPegawai {
  final CollectionReference pegawai =
        FirebaseFirestore.instance.collection('pegawai');

  void createInputSurel(InputAsn inputAsn) async {
    final json = inputAsn.toJson();
    var querySnapshot = await pegawai.orderBy("id", descending: true).limit(1).get();
    var maxId = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("id") : 0;
    json["id"] = maxId + 1;
    await pegawai.add(json);
  }

  Future<void> delete(String id, BuildContext context) async {
  try {
    await pegawai.doc(id).delete();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Data Berhasil Di hapus')));
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  } on StateError catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Data tidak berhasil di hapus')));
  }
}

   Future<void> update(
    DocumentSnapshot<Object?> documentSnapshot, BuildContext context) async {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _nip = TextEditingController();
  final TextEditingController _jabatan = TextEditingController();

  

  if (documentSnapshot != null) {
    _id.text = documentSnapshot['id'].toString();
    _nama.text = documentSnapshot['nama'];
    _nip.text = documentSnapshot['nip'].toInt().toString();
    _jabatan.text = documentSnapshot['jabatan'];
  }

  await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        var _pakat = documentSnapshot['pangkat'];
        var _gol = documentSnapshot['golongan'];
        var _stas = documentSnapshot['status'];
        return SingleChildScrollView(
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
                TextField(
                  keyboardType: TextInputType.none,
                  controller: _id,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'No',
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _nama,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _nip,
                  decoration: const InputDecoration(
                    labelText: 'Nip',
                  ),
                ),
                DropdownButtonFormUpdates(
                  labelTitle: "Pangkat",
                  itemes: pangkat.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(
                        dropDownStringItem,
                      ),
                    );
                  }).toList(),
                  onchage: (newValueSelected) {
                    var _currentItemSelected = newValueSelected!;
                    _pakat = newValueSelected;
                  },
                  values: documentSnapshot['pangkat'],
                ),
                DropdownButtonFormUpdates(
                  labelTitle: "Golongan",
                  itemes: golongan.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(
                        dropDownStringItem,
                      ),
                    );
                  }).toList(),
                  onchage: (newValueSelected) {
                    var _currentItemSelected = newValueSelected!;
                    _gol = newValueSelected;
                  },
                  values: documentSnapshot['golongan'],
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _jabatan,
                  decoration: const InputDecoration(
                    labelText: 'Jabatan',
                  ),
                ),
                DropdownButtonFormUpdates(
                  labelTitle: "Status",
                  itemes: status.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(
                        dropDownStringItem,
                      ),
                    );
                  }).toList(),
                  onchage: (newValueSelected) {
                    var _currentItemSelected = newValueSelected!;
                    _stas = newValueSelected;
                  },
                  values: documentSnapshot['status'],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      child: const Text('Update'),
                      onPressed: () async {
                        final int no = int.parse(_id.text);
                        final String nama = _nama.text;
                        final int nip = int.parse(_nip.text);
                        final String pangkat = _pakat;
                        final String golongan = _gol;
                        final String jabatan = _jabatan.text;
                        final String status = _stas;
                        if (no != null) {
                          await pegawai.doc(documentSnapshot.id).update({
                            "id": no,
                            "nama": nama,
                            "nip": nip,
                            "pangkat": pangkat,
                            "golongan": golongan,
                            "jabatan": jabatan,
                            "status": status,
                          });
                          _id.text = '';
                          _nama.text = '';
                          _nip.text = '';
                          _pakat = '';
                          _gol = '';
                          _jabatan.text = '';
                          _stas = '';
                          Navigator.pop(context);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('Berhasil Memperbarui Data')));
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
            ),
          ),
        );
      });
}
}


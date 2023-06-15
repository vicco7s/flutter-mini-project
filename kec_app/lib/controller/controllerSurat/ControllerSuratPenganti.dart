import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/model/surat/suratpenggantiService.dart';

import '../../page/agenda/suratPegantiPegawaiPJD/tambahSuratPenganti.dart';

class ControllerSuratpengganti {
  void createInputSuratBatal(DocumentSnapshot documentSnapshot,
      SuratPenggantiService suratPenggantiService) async {
    final CollectionReference _suratpengganti = FirebaseFirestore.instance
        .collection('users')
        .doc(documentSnapshot.id)
        .collection('suratpengganti');

    final json = suratPenggantiService.toJson();
    var querySnapshot =
        await _suratpengganti.orderBy("id", descending: true).limit(1).get();
    var maxId =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("id") : 0;
    json["id"] = maxId + 1;
    await _suratpengganti.add(json);
  }

  Future<void> delete(DocumentSnapshot documentSnapshot, String id,
      BuildContext context) async {
    try {
      final _suratPengganti = FirebaseFirestore.instance
          .collection('users')
          .doc(documentSnapshot.id)
          .collection('suratpengganti');

      await _suratPengganti.doc(id).delete();
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

  Future<void> update(
      DocumentSnapshot documentSnapshot,
      QueryDocumentSnapshot<Object?> suratPenggantiDoc,
      BuildContext context) async {
    final _no = TextEditingController();
    final _jabatan = TextEditingController();
    final _nama_pengganti = TextEditingController();
    final _tanggal_surat = TextEditingController();
    final _tanggal_perjalanan = TextEditingController();
    final _alasan = TextEditingController();

    Timestamp timerstamp = suratPenggantiDoc['tanggal_surat'];
    Timestamp timerstamps = suratPenggantiDoc['tanggal_perjalanan'];
    var date = timerstamp.toDate();
    var dates = timerstamps.toDate();
    var tanggal_surat = DateFormat('yyyy-MM-dd').format(date);
    var tanggal_perjalanan = DateFormat('yyyy-MM-dd').format(dates);

    _no.text = suratPenggantiDoc['id'].toString();
    _jabatan.text = suratPenggantiDoc['jabatan'];
    _nama_pengganti.text = suratPenggantiDoc['nama_pengganti'];
    _tanggal_surat.text = tanggal_surat.toString();
    _tanggal_perjalanan.text = tanggal_perjalanan.toString();
    _alasan.text = suratPenggantiDoc['alasan'];

    final CollectionReference userCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(documentSnapshot.id)
        .collection('suratpengganti');

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          var _selectedValue = suratPenggantiDoc['nama'];

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
                    TextField(
                          keyboardType: TextInputType.none,
                          controller: _no,
                          enabled: false,
                          decoration:
                              const InputDecoration(labelText: 'Nomor'),
                        ),

                    Padding(
                    padding: EdgeInsets.zero,
                    child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("pegawai")
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          QuerySnapshot querySnapshot =
                              snapshot.data as QuerySnapshot;
                          List<DocumentSnapshot> items =
                              querySnapshot.docs;
                          List<DropdownMenuItem<String>>
                              dropdownItems = [];
                          for (var item in items) {
                            dropdownItems.add(DropdownMenuItem(
                              child: Text(item['nama']),
                              value: item['nama'],
                            ));
                          }
                          return Column(
                            children: [
                              DropdownButtonFormField<String>(
                                dropdownColor: Colors.white,
                                isExpanded: true,
                                iconEnabledColor: Colors.black,
                                focusColor: Colors.black,
                                items: dropdownItems,
                                onChanged: (value) {
                                  _selectedValue = value!;
                                  getJabatanByNama(value)
                                      .then((jabatan) {
                                    _jabatan.text =
                                        jabatan; // Set nilai pada _jabatanController
                                  });
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Nama Lengkap',
                                ),
                                value: _selectedValue,
                              ),
                              TextField(
                                keyboardType: TextInputType.none,
                                controller: _jabatan,
                                enabled: false,
                                decoration: const InputDecoration(
                                    labelText: 'Jabatan'),
                              ),
                            ],
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    )),

                    TextField(
                        keyboardType: TextInputType.none,
                        controller: _nama_pengganti,
                        enabled: false,
                        decoration:
                            const InputDecoration(labelText: 'Nama Pengganti'),
                      ),

                    DateTimeField(
                      format: DateFormat('yyyy-MM-dd'),
                      onShowPicker:
                          (BuildContext context, DateTime? currentValue) {
                        return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                      },
                      controller: _tanggal_surat,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.date_range_outlined),
                        labelText: 'Tanggal Surat',
                      ),
                    ),
                    
                    DateTimeField(
                      format: DateFormat('yyyy-MM-dd'),
                      onShowPicker:
                          (BuildContext context, DateTime? currentValue) {
                        return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                      },
                      controller: _tanggal_perjalanan,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.date_range_outlined),
                        labelText: 'Tanggal Perjalanan',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, // background
                                  foregroundColor: Colors.blue, // foreground
                                ),
                                child: const Text('Update'),
                                onPressed: () async {
                                  final int no = int.parse(_no.text);
                                  final String nama = _selectedValue;
                                  final String jabatan = _jabatan.text;
                                  final String nama_pengganti = _nama_pengganti.text;
                                  final DateTime tanggal_surat =
                                      DateTime.parse(_tanggal_surat.text);
                                  final DateTime tanggal_perjalanan =
                                      DateTime.parse(_tanggal_perjalanan.text);
                                  final String alasan = _alasan.text;
                                  if (no != null) {
                                    await userCollection
                                        .doc(suratPenggantiDoc.id)
                                        .update({
                                      "id": no,
                                      "nama": nama,
                                      "jabatan": jabatan,
                                      "nama_pengganti": nama_pengganti,
                                      "tanggal_surat": tanggal_surat,
                                      "tanggal_perjalanan": tanggal_perjalanan,
                                      "alasan": alasan,
                                      
                                    });
                                    _no.text = '';
                                    _selectedValue = '';
                                    _jabatan.text = '';
                                    _tanggal_surat.text = '';
                                    _tanggal_perjalanan.text = '';
                                    _alasan.text = '';
                                    _nama_pengganti.text = '';
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
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
                                  backgroundColor: Colors.white, // background
                                  foregroundColor: Colors.red, // foreground
                                ),
                              ),
                            ],
                          )

                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
